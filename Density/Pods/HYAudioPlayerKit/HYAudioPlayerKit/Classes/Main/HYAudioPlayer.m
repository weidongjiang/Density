//
//  HYAudioPlayer.m
//  HyWallPaper
//
//  Created by Json on 2020/2/10.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import "HYAudioPlayer.h"
#import "HYAudioDataLoader.h"
#import "HYAudioPlayerModel.h"
#import "HYAudioFileManager.h"
#import "HYAudioPlayerTool.h"
#import "ZYNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#import <HYBasicToolKit/HYUtilsMacro.h>

/**Asset KEY*/
NSString * const HYPlayableKey                  = @"playable";
/**PlayerItem KEY*/
NSString * const HYStatusKey                    = @"status";
NSString * const HYLoadedTimeRangesKey          = @"loadedTimeRanges";
NSString * const HYPlaybackBufferEmptyKey       = @"playbackBufferEmpty";
NSString * const HYPlaybackLikelyToKeepUpKey    = @"playbackLikelyToKeepUp";

@interface HYAudioPlayer()<HYAudioDataLoaderDelegate>
{
    BOOL _isOtherPlaying; // 其他应用是否正在播放
    BOOL _isBackground; // 是否进入后台
    BOOL _isCached; // 当前音频是否缓存
    BOOL _isSeek; // 正在seek
    BOOL _isSeekWaiting; // seek 等待
    BOOL _isNaturalToEndTime; // 是否是自然结束
    BOOL _isFirstPlay; // 是否是第一次播放
    dispatch_group_t _netGroupQueue; // 组队列-网络
    dispatch_group_t _dataGroupQueue; // 组队列-数据
    NSInteger _randomIndex; // 随机数组元素index
    NSInteger _playIndex1; // 播放顺序标识
    NSInteger _playIndex2; // 播放顺序标识
    CGFloat _seekValue; // seek value
    NSMutableDictionary *_remoteInfoDictionary;//控制中心信息
}
/** player */
@property (nonatomic, strong) AVPlayer          *player;
/** playerItem */
@property (nonatomic, strong) AVPlayerItem      *playerItem;
/** 播放进度监测 */
@property (nonatomic, strong) id                timeObserver;
/** 随机数组 */
@property (nonatomic, strong) NSMutableArray    *randomIndexArray;
/** 资源下载器 */
@property (nonatomic, strong) HYAudioDataLoader *resourceLoader;
/** model数据数组 */
@property (nonatomic, strong) NSMutableArray<HYAudioPlayerModel *> *playerModelArray;

@property (nonatomic, copy) void(^seekCompletionBlock)(void);

@property (nonatomic, readwrite, strong) HYAudioPlayerModel *currentAudioModel;
//@property (nonatomic, readwrite, strong) HYAudioPlayerInfoModel *currentAudioInfoModel;
@property (nonatomic, readwrite, assign) HYAudioPlayerState state;
@property (nonatomic, readwrite, assign) CGFloat bufferProgress;
@property (nonatomic, readwrite, assign) CGFloat progress;
@property (nonatomic, readwrite, assign) CGFloat currentTime;
@property (nonatomic, readwrite, assign) CGFloat totalTime;

@property (nonatomic, strong) NSDate *pauseTimeDate;

@property (nonatomic, assign) BOOL isInVideoPage;

@end
@implementation HYAudioPlayer
/** 单例方法 */
+ (HYAudioPlayer *)sharedPlayer {
    static HYAudioPlayer *player = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        player = [[[self class] alloc] init];
    });
    return player;
}

/** 移除监听 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hy_deallocPlayer];
    HYDebugLog(@"%s",__FUNCTION__);

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playMode = HYAudioPlayerModeOrderCycle;
        self.timerMode = HYAudioPlayerTimerModeNone;
        
         [self hy_playerStatusCode:HYAudioPlayerStateDefault];
         self.isObserveProgress          = YES;
         self.isObserveBufferProgress    = YES;
         self.isNeedCache                = NO;
         self.isObserveFileModifiedTime  = NO;
         self.isObserveWWAN              = NO;
        
         _needRemoteControl = NO;
         _isFirstPlay = YES;
         _isCached       = NO;
         _isBackground   = NO;
         _randomIndex    = -1;
         _playIndex2     = 0;
         
         _netGroupQueue  = dispatch_group_create();
         _dataGroupQueue = dispatch_group_create();
         
//            [self addPlayerObserver];
        
        [self addPlayerObserver];


    }
    return self;
}

#pragma mark ----- set
- (void)setNeedRemoteControl:(BOOL)needRemoteControl{
    _needRemoteControl = needRemoteControl;
    if (needRemoteControl == YES) {
        [self addRemoteControlHandler];
    }
}
#pragma mark ----- 初始化播放器
- (void)hy_initPlayerWithUserId:(NSString *)userId{
   
    [HYAudioFileManager hy_saveUserId:userId];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _isOtherPlaying = [AVAudioSession sharedInstance].otherAudioPlaying;
}

#pragma mark ----- 添加系统时间监听
- (void)addPlayerObserver{
    //将要进入后台
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(hy_playerWillResignActive)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    //已经进入前台
    [notificationCenter addObserver:self
                           selector:@selector(hy_playerDidEnterForeground)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    //监测耳机
    [notificationCenter addObserver:self
                           selector:@selector(hy_playerAudioRouteChange:)
                               name:AVAudioSessionRouteChangeNotification
                             object:nil];
    //监听播放器被打断（别的软件播放音乐，来电话）
    [notificationCenter addObserver:self
                           selector:@selector(hy_playerAudioBeInterrupted:)
                               name:AVAudioSessionInterruptionNotification
                             object:[AVAudioSession sharedInstance]];
    //监测其他app是否占据AudioSession
    [notificationCenter addObserver:self
                           selector:@selector(hy_playerSecondaryAudioHint:)
                               name:AVAudioSessionSilenceSecondaryAudioHintNotification
                             object:nil];
}

- (void)hy_playerWillResignActive{
    /** 标识后台状态 */
    _isBackground = YES;
    
    /** 如果不需要后台模式，那么回到后台要停止激活时要播放 */
    if (self->_needRemoteControl) {
        [self addPlayingCenterInfo];
    }else{
        [self hy_pause];
    }
}

- (void)hy_playerDidEnterForeground{
    /** 标识后台状态 */
    _isBackground = NO;
    /** 如果不需要后台模式，那么回到后台要停止激活时要播放 */
    if (!self->_needRemoteControl) {
        [self hy_play];
    }
}

/**
 进入视频播放界面
 */
- (void)enterOtherMediaPage{
    if (self.state != HYAudioPlayerStateStopped) {
        [self hy_pause];
    }
//    [self cleanPlayingCenterInfo];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

    self.isInVideoPage = YES;
}
/**
 退出视频播放界面
 */
- (void)leaveOtherMediaPage{
    
    self.isInVideoPage = NO;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

//    [self addRemoteControlHandler];
}

- (void)cleanPlayingCenterInfo{
    _remoteInfoDictionary = [NSMutableDictionary dictionary];
    
    if (self.currentAudioModel.title) {
        _remoteInfoDictionary[MPMediaItemPropertyTitle] = @"";
    }
    if (self.currentAudioModel.ringName) {
        _remoteInfoDictionary[MPMediaItemPropertyAlbumTitle] = @"";
    }
//    if (self.currentAudioModel.singer) {
//        _remoteInfoDictionary[MPMediaItemPropertyArtist] = self.currentAudioModel.singer;
//    }
    if (self.currentAudioModel.icon) {
        
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[[UIImage alloc] init]];
        _remoteInfoDictionary[MPMediaItemPropertyArtwork] = artwork;
    }
    _remoteInfoDictionary[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = _remoteInfoDictionary;
}


- (void)hy_playerAudioRouteChange:(NSNotification *)notification{
    HYDebugLog(@"%s",__FUNCTION__);
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable://耳机插入
            if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:isHeadphone:)]) {
                [self.delegate hy_player:self isHeadphone:YES];
            }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable://耳机拔出，停止播放操作
            if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:isHeadphone:)]) {
                [self.delegate hy_player:self isHeadphone:NO];
            }else{
                if(self.state != HYAudioPlayerStateDefault){
                    /** 如果播放器曾经播放过音乐 */
                    [self hy_pause];
                }
            }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            //
            break;
        default:
            break;
    }
}

- (void)hy_playerAudioBeInterrupted:(NSNotification *)notification{
    HYDebugLog(@"%s",__FUNCTION__);
    NSDictionary *dic = notification.userInfo;
    if ([dic[AVAudioSessionInterruptionTypeKey] integerValue] == 1) {//打断开始
        if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:isInterrupted:)]) {
            [self.delegate hy_player:self isInterrupted:YES];
        }else{
            if(self.state != HYAudioPlayerStateDefault){
                HYDebugLog(@"%s --- HYAudioPlayerStateNone",__FUNCTION__);
                /** 如果播放器曾经播放过音乐 */
                [self hy_pause];
            }
        }
    }else {//打断结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:isInterrupted:)]) {
            [self.delegate hy_player:self isInterrupted:NO];
        }else{
            if ([notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue] == 1) {
                if(self.state != HYAudioPlayerStateDefault && !self.isInVideoPage){
                    [self hy_play];
                }
            }
        }
    }
}

- (void)hy_playerSecondaryAudioHint:(NSNotification *)notification{
    
}

-(void)hy_playerDidPlayToEndTime:(NSNotification *)notification{
    if(self.isInVideoPage && self->_isBackground == NO){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(hy_playerDidPlayToEndTime:)]) {
            [self.delegate hy_playerDidPlayToEndTime:self];
        }else{
            self->_isNaturalToEndTime = YES;
            [self hy_next];
            HYDebugLog(@"hy_playerDidPlayToEndTime");
        }
    });
}

#pragma mark - 数据源

- (void)hy_reloadData{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hy_audioDataForPlayer:)]) {
        if (!self.playerModelArray) {
            self.playerModelArray = [NSMutableArray array];
        }
        if (self.playerModelArray.count != 0) {
            [self.playerModelArray removeAllObjects];
        }
        
        dispatch_group_enter(_dataGroupQueue);
        dispatch_group_async(_dataGroupQueue, HYPlayerHighGlobalQueue, ^{
            dispatch_async(HYPlayerHighGlobalQueue, ^{
                
                [self.playerModelArray addObjectsFromArray:[self.dataSource hy_audioDataForPlayer:self]];
                
                //更新随机数组
                [self updateRandomIndexArray];
                
                //更新currentAudioId
                if (self.currentAudioModel.audioUrl) {
                    [self.playerModelArray enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(HYAudioPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.audioUrl.absoluteString isEqualToString:self.currentAudioModel.audioUrl.absoluteString]) {
                            self.currentAudioModel.audioIndex = idx;
                            self.currentAudioId = idx;
                            *stop = YES;
                        }
                    }];
                }
                dispatch_group_leave(self->_dataGroupQueue);
            });
        });
    }
}
#pragma mark - 播放 IMPORTANT

- (void)hy_playWithAudioId:(NSUInteger)audioId {
//    if (self->_isFirstPlay && self.isNeedBackgroundMode) {
//        _isFirstPlay  = NO;
//        [self addRemoteControlHandler];
//    }
    
    dispatch_group_notify(_dataGroupQueue, HYPlayerHighGlobalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.playerModelArray.count > audioId) {
                HYAudioPlayerModel *playModel = self.playerModelArray[audioId];
                if (self.currentAudioModel == playModel) {
                    return;
                }
                
                self.currentAudioModel = self.playerModelArray[audioId];
                self.currentAudioId = audioId;
                [self audioPrePlay];
            }
        });
    });
}

- (void)audioPrePlay{
    
    
    [self reset];
    
    if (![HYAudioPlayerTool isNSURL:self.currentAudioModel.audioUrl]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_playerAudioAddToPlayQueue:)]) {
        [self.delegate hy_playerAudioAddToPlayQueue:self];
    }
    
    if ([HYAudioPlayerTool isLocalAudio:self.currentAudioModel.audioUrl]) {
        HYDebugLog(@"-- AudioPlayer：本地音频，Id：%d",1);
        _isCached = YES;
        [self loadPlayerItemWithURL:self.currentAudioModel.audioUrl];
    }else{
        NSString *cachePath = [HYAudioFileManager hy_cachePath:self.currentAudioModel.audioUrl];
        _isCached = cachePath ? YES : NO;
        HYDebugLog(@"-- AudioPlayer：网络音频，Id： 缓存：");
        dispatch_group_notify(_netGroupQueue, HYPlayerDefaultGlobalQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([ZYNetworking sharedZYNetworking].networkStats == StatusUnknown ||
                    [ZYNetworking sharedZYNetworking].networkStats == StatusNotReachable){
                    if (cachePath){//有缓存，播放缓存
                        [self loadPlayerItemWithURL:[NSURL fileURLWithPath:cachePath]];
                    }else{//无缓存，提示联网
                        [self hy_getStatusCode:HYAudioPlayerStatusNoNetwork];
                    }
                }else{
                    if (!self.isNeedCache){//不需要缓存
                        // WWAN网络警告
                        if (self.isObserveWWAN && [ZYNetworking sharedZYNetworking].networkStats == StatusReachableViaWWAN) {
                            [self hy_getStatusCode:HYAudioPlayerStatusViaWWAN];
                            return;
                        }
                        [self loadPlayerItemWithURL:self.currentAudioModel.audioUrl];
                    }else{//需要缓存
                        if (cachePath && !self.isObserveFileModifiedTime) {
                            //有缓存且不监听改变时间，直接播放缓存
                            [self loadPlayerItemWithURL:[NSURL fileURLWithPath:cachePath]];
                        }else{//无缓存 或 需要兼听
                            // WWAN网络警告
                            if (self.isObserveWWAN && [ZYNetworking sharedZYNetworking].networkStats == StatusReachableViaWWAN) {
                                [self hy_getStatusCode:HYAudioPlayerStatusViaWWAN];
                                return;
                            }
                            [self loadAudioWithCachePath:cachePath];
                        }
                    }
                }
            });
        });
    }
}

- (void)loadAudioWithCachePath:(NSString *)cachePath{
    self.resourceLoader = [[HYAudioDataLoader alloc] init];
    self.resourceLoader.delegate = self;
    self.resourceLoader.isCached = _isCached;
    self.resourceLoader.isObserveFileModifiedTime = self.isObserveFileModifiedTime;
    
    NSURL *customUrl = [HYAudioPlayerTool customURL:self.currentAudioModel.audioUrl];
    if (!customUrl) {
        return;
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:customUrl options:nil];
    [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
    HYPlayerWeakSelf
    [asset loadValuesAsynchronouslyForKeys:@[HYPlayableKey] completionHandler:^{
        HYPlayerStrongSelf
        dispatch_async( dispatch_get_main_queue(),^{
            if (!asset.playable) {
                [sSelf hy_playerStatusCode:HYAudioPlayerStateFailed];

                [sSelf.resourceLoader stopDownload];
                [asset cancelLoading];
            }
        });
    }];
    
    self.resourceLoader.checkStatusBlock = ^(NSInteger statusCode){
        HYPlayerStrongSelf
        if (statusCode == 200) {
            [sSelf loadPlayerItemWithAsset:asset];
        }else if (statusCode == 304) { // 服务器文件未变化
            [sSelf loadPlayerItemWithURL:[NSURL fileURLWithPath:cachePath]];
        }else if (statusCode == 206){
            
        }
    };
}


- (void)loadPlayerItemWithURL:(NSURL *)URL{
    if (self.playerItem != NULL) {
        self.playerItem = NULL;
    }
    HYDebugLog(@"%s ---- thread %@",__FUNCTION__,[NSThread currentThread]);
    self.playerItem = [[AVPlayerItem alloc] initWithURL:URL];
    [self loadPlayer];
}

- (void)loadPlayerItemWithAsset:(AVURLAsset *)asset{
  
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self loadPlayer];
}

- (void)loadPlayer{
    if (self.player != NULL) {
        self.player = NULL;
    }
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];

    
    if (@available(iOS 10.0,*)) {
//        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    
    [self hy_play];
    [self addProgressObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:HYStatusKey]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status) {
                case AVPlayerItemStatusUnknown:
                    [self hy_playerStatusCode:HYAudioPlayerStateFailed];
                    [self hy_getStatusCode:HYAudioPlayerStatusUnknown];
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_playerReadyToPlay:)]) {
                        [self.delegate hy_playerReadyToPlay:self];
                    }
                    break;
                case AVPlayerItemStatusFailed:
                    [self hy_playerStatusCode:HYAudioPlayerStateFailed];
                    [self hy_getStatusCode:HYAudioPlayerStatusFailed];
                    break;
                default:
                    break;
            }
        }else if ([keyPath isEqualToString:HYLoadedTimeRangesKey]) {
            [self addBufferProgressObserver];
        }else if ([keyPath isEqualToString:HYPlaybackBufferEmptyKey]) {
            if (self.playerItem.playbackBufferEmpty) {
                [self hy_playerStatusCode:HYAudioPlayerStateBuffering];
            }
        }else if ([keyPath isEqualToString:HYPlaybackLikelyToKeepUpKey]) {
            
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - HYAudioDataLoaderDelegate
/**下载出错*/
- (void)loader:(HYAudioDataLoader *)loader requestError:(NSInteger)errorCode{
    if (errorCode == NSURLErrorTimedOut) {
        [self hy_getStatusCode:HYAudioPlayerStatusTimeOut];
    }else if ([ZYNetworking sharedZYNetworking].networkStats == StatusNotReachable ||
              [ZYNetworking sharedZYNetworking].networkStats == StatusUnknown) {
        [self hy_getStatusCode:HYAudioPlayerStatusNoNetwork];
    }
}

/**是否完成缓存*/
- (void)loader:(HYAudioDataLoader *)loader isCached:(BOOL)isCached{
    _isCached = isCached;
    NSUInteger status = isCached ? HYAudioPlayerStatusCacheSucc : HYAudioPlayerStatusCacheFail;
    [self hy_getStatusCode:status];
}

#pragma mark - 缓冲进度 播放进度 歌曲锁屏信息 音频跳转

- (void)addBufferProgressObserver{
    self.totalTime = CMTimeGetSeconds(self.playerItem.duration);
    if (!self.isObserveBufferProgress) {
        return;
    }
    CMTimeRange timeRange   = [self.playerItem.loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat startSeconds    = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    if (self.totalTime != 0) {//避免出现inf
        self.bufferProgress = (startSeconds + durationSeconds) / self.totalTime;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:bufferProgress:)]) {
        [self.delegate hy_player:self bufferProgress:self.bufferProgress];
    }

    if (_isSeekWaiting) {
        if (self.bufferProgress > _seekValue) {
            _isSeekWaiting = NO;
            HYPlayerWeakSelf
            [self didSeekToTime:_seekValue completionBlock:^{
                HYPlayerStrongSelf
                if (sSelf.seekCompletionBlock) {
                    sSelf.seekCompletionBlock();
                }
            }];
        }
    }
}

- (void)addProgressObserver{
    if (!self.isObserveProgress) {
        return;
    }
    
    HYPlayerWeakSelf
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        HYPlayerStrongSelf
        if (sSelf->_isSeek) {
            return;
        }
        AVPlayerItem *currentItem = sSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0){
            CGFloat currentT = (CGFloat)CMTimeGetSeconds(time);
            sSelf.currentTime = currentT;
            if (sSelf.totalTime != 0) {//避免出现inf

                if (CMTimeGetSeconds([currentItem currentTime]) < 0) {
                    sSelf.progress = 0.f;
                }else{
                    sSelf.progress = CMTimeGetSeconds([currentItem currentTime]) / sSelf.totalTime;
                }
            }
            if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(hy_player:progress:currentTime:)]) {
                [sSelf.delegate hy_player:sSelf progress:sSelf.progress currentTime:currentT];
            }
            [sSelf updatePlayingCenterInfo];
            /** 检查是否需要暂停 */
            [sSelf checkPauseTimer];
        }
    }];
}

- (void)checkPauseTimer{
    if (self.timerMode == HYAudioPlayerTimerModeNone || self.pauseTimeDate == nil) {
        return;
    }
    NSDate *date = [NSDate date];
    NSComparisonResult result = [date compare:self.pauseTimeDate];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        [self hy_pause];
        self.pauseTimeDate = nil;
        self.timerMode = HYAudioPlayerTimerModeNone;
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *delta = [calendar components:NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:self.pauseTimeDate options:0];
        NSString *timeRemaining = [NSString stringWithFormat:@"%02tu:%02tu",delta.minute,delta.second];
//        HYDebugLog(@"%@ -----",timeRemaining);
        self.timeRemaining = timeRemaining;
    }
}


- (void)hy_seekToTime:(CGFloat)value completionBlock:(void (^)(void))completionBlock{
    _isSeek = YES;
    // 先暂停
    if (self.state == HYAudioPlayerStatePlaying) {
        [self hy_pause];
    }
    if (self.bufferProgress < value) {
        _isSeekWaiting = YES;
        _seekValue = value;
        if (completionBlock) {
            self.seekCompletionBlock = completionBlock;
        }
    }else{
        _isSeekWaiting = NO;
        [self didSeekToTime:value completionBlock:completionBlock];
    }
}

- (void)didSeekToTime:(CGFloat)value completionBlock:(void (^)(void))completionBlock{
    [self.player seekToTime:CMTimeMake(floorf(self.totalTime * value), 1)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero
          completionHandler:^(BOOL finished) {
        if (finished) {
            [self hy_play];
            self->_isSeek = NO;
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}
/**倍速播放*/
- (void)hy_setRate:(CGFloat)rate{
    for (AVPlayerItemTrack *track in self.playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio]){
            track.enabled = YES;
        }
    }
    self.player.rate = rate;
}



/**释放播放器*/
- (void)hy_deallocPlayer{
    
    HYDebugLog(@"%s",__FUNCTION__);
    
    [self reset];
    
    [self hy_playerStatusCode:HYAudioPlayerStateStopped];
    
    [self endReceivingRemoteControl];
    
    if (_isOtherPlaying) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }else{
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
    
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    if (self.randomIndexArray) {
        self.randomIndexArray = nil;
    }
    
    if (self.playerModelArray) {
        self.playerModelArray = nil;
    }
    
    if (self.playerItem) {
        self.playerItem = nil;
    }
    
    if (self.player) {
        self.player = nil;
    }
}

- (void)reset{
    HYDebugLog(@"%s",__FUNCTION__);
    if (self.state == HYAudioPlayerStatePlaying) {
        [self hy_pause];
    }
    
    //停止下载
    if (self.resourceLoader) {
        [self.resourceLoader stopDownload];
    }
    
    //移除进度观察者
    if (self.timeObserver) {
        @try{
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    }
    
     //重置
    self.progress = .0f;
    self.bufferProgress = .0f;
    self.currentTime = .0f;
    self.totalTime = .0f;
    _isSeekWaiting = NO;
}

#pragma mark - 播放 暂停 下一首 上一首
/**播放*/
-(void)hy_play{
    [self hy_playerStatusCode:HYAudioPlayerStatePlaying];
    [self.player play];
}

/**暂停*/
-(void)hy_pause{
    [self hy_playerStatusCode:HYAudioPlayerStatePause];
    [self.player pause];
}

/**下一首*/
- (void)hy_next{
    switch (self.playMode) {
        case HYAudioPlayerModeOnlyOnce:
            if (_isNaturalToEndTime) {
                _isNaturalToEndTime = NO;
                [self hy_pause];
            }else{
                [self next];
            }
            break;
        case HYAudioPlayerModeSingleCycle:
            if (_isNaturalToEndTime) {
                _isNaturalToEndTime = NO;
                [self audioPrePlay];
            }else{
                [self next];
            }
            break;
        case HYAudioPlayerModeOrderCycle:
            [self next];
            break;
        case HYAudioPlayerModeShuffleCycle:{
            _playIndex2++;
            self.currentAudioId = [self randomAudioId];
            self.currentAudioModel = self.playerModelArray[_currentAudioId];
            [self audioPrePlay];
            break;
        }
        default:
            break;
    }
}

/**上一首*/
- (void)hy_last{
    if (self.playMode == HYAudioPlayerModeShuffleCycle) {
        if (_playIndex2 == 1) {
            _playIndex2 = 0;
            self.currentAudioModel = self.playerModelArray[_playIndex1];
        }else{
            self.currentAudioId = [self randomAudioId];
            self.currentAudioModel = self.playerModelArray[_currentAudioId];
        }
        [self audioPrePlay];
    }else{
        self.currentAudioId--;
        if (_currentAudioId < 0) {
            self.currentAudioId = self.playerModelArray.count - 1;
        }
        self.currentAudioModel = self.playerModelArray[_currentAudioId];
        [self audioPrePlay];
    }
}

- (void)next{
    
    if (_currentAudioId < 0 || _currentAudioId >= self.playerModelArray.count - 1) {
        self.currentAudioId = 0;
    }else{
        self.currentAudioId++;
    }
    _playIndex1 = _currentAudioId;
    _playIndex2 = 0;
    self.currentAudioModel = self.playerModelArray[_currentAudioId];
    [self audioPrePlay];
}

#pragma mark - 随机播放相关

- (void)updateRandomIndexArray{
    NSInteger startIndex = 0;
    NSInteger length = self.playerModelArray.count;
    NSInteger endIndex = startIndex+length;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:length];
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:length];
    for (NSInteger i = startIndex; i < endIndex; i++) {
        @autoreleasepool {
            NSString *str = [NSString stringWithFormat:@"%ld",(long)i];
            [arr1 addObject:str];
        }
    }
    for (NSInteger i = startIndex; i < endIndex; i++) {
        @autoreleasepool {
            int index = arc4random()%arr1.count;
            int radom = [arr1[index] intValue];
            NSNumber *num = [NSNumber numberWithInt:radom];
            [arr addObject:num];
            [arr1 removeObjectAtIndex:index];
        }
    }
    _randomIndexArray = [NSMutableArray arrayWithArray:arr];
}

- (NSInteger)randomAudioId{
    _randomIndex++;
    if (_randomIndex >= self.randomIndexArray.count) {
        _randomIndex = 0;
    }
    if (_randomIndex < 0) {
        _randomIndex = self.randomIndexArray.count - 1;
    }
    NSInteger index = [self.randomIndexArray[_randomIndex] integerValue];
    //去重
    if (index == _currentAudioId) {
        index = [self randomAudioId];
    }
    return index;
}

#pragma mark - setter

- (void)setCategory:(AVAudioSessionCategory)category{
    [[AVAudioSession sharedInstance] setCategory:category error:nil];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    if (_playerItem == playerItem) {
        return;
    }
    if (_playerItem) {
        @try {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [_playerItem removeObserver:self forKeyPath:HYStatusKey];
            [_playerItem removeObserver:self forKeyPath:HYLoadedTimeRangesKey];
            [_playerItem removeObserver:self forKeyPath:HYPlaybackBufferEmptyKey];
            [_playerItem removeObserver:self forKeyPath:HYPlaybackLikelyToKeepUpKey];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
     
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hy_playerDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [playerItem addObserver:self forKeyPath:HYStatusKey options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:HYLoadedTimeRangesKey options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:HYPlaybackBufferEmptyKey options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:HYPlaybackLikelyToKeepUpKey options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark ----- 后台播放相关
/**远程线控*/
- (void)addRemoteControlHandler{
    if (@available (iOS 7.1, *)) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
        [self addRemoteCommand:center.playCommand selector:@selector(hy_play)];
        [self addRemoteCommand:center.pauseCommand selector:@selector(hy_pause)];
        [self addRemoteCommand:center.previousTrackCommand selector:@selector(hy_last)];
        [self addRemoteCommand:center.nextTrackCommand selector:@selector(hy_next)];
        [center.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            if ([HYAudioPlayer sharedPlayer].state == HYAudioPlayerStatePlaying) {
                [[HYAudioPlayer sharedPlayer] hy_pause];
            }else{
                [[HYAudioPlayer sharedPlayer] hy_play];
            }
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        
        if (@available (iOS 9.1,*)) {
            [center.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
                MPChangePlaybackPositionCommandEvent *positionEvent = (MPChangePlaybackPositionCommandEvent *)event;
                if (self.totalTime > 0) {
                    [self hy_seekToTime:positionEvent.positionTime / self.totalTime completionBlock:nil];
                }
                return MPRemoteCommandHandlerStatusSuccess;
            }];
        }
    }
}

- (void)addRemoteCommand:(MPRemoteCommand *)command selector:(SEL)selector{
    HYPlayerWeakSelf
    [command addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        HYPlayerStrongSelf
        if ([sSelf respondsToSelector:selector]) {
            IMP imp = [sSelf methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(sSelf, selector);
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)addPlayingCenterInfo{
    
    if (!self.currentAudioModel) return;
    
    _remoteInfoDictionary = [NSMutableDictionary dictionary];
    
    if (self.currentAudioModel.title) {
        _remoteInfoDictionary[MPMediaItemPropertyTitle] = self.currentAudioModel.title;
    }
    if (self.currentAudioModel.ringName) {
        _remoteInfoDictionary[MPMediaItemPropertyAlbumTitle] = self.currentAudioModel.ringName;
    }
//    if (self.currentAudioModel.singer) {
//        _remoteInfoDictionary[MPMediaItemPropertyArtist] = self.currentAudioModel.singer;
//    }
    if (self.currentAudioModel.icon) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(50, 50) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return [UIImage imageNamed:@"icon_musiccenter"];
        }];
        _remoteInfoDictionary[MPMediaItemPropertyArtwork] = artwork;
    }
    _remoteInfoDictionary[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = _remoteInfoDictionary;
}

- (void)endReceivingRemoteControl{
    if (@available(iOS 7.1, *)) {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
        [[center playCommand] removeTarget:self];
        [[center pauseCommand] removeTarget:self];
        [[center nextTrackCommand] removeTarget:self];
        [[center previousTrackCommand] removeTarget:self];
        [[center togglePlayPauseCommand] removeTarget:self];
        if(@available(iOS 9.1, *)) {
            [center.changePlaybackPositionCommand removeTarget:self];
        }
    }
}

- (void)updatePlayingCenterInfo{

        if (!_isBackground) {return;}
        if (self.currentAudioModel.title) {
            _remoteInfoDictionary[MPMediaItemPropertyTitle] = self.currentAudioModel.title;
        }
        if (self.currentAudioModel.ringName) {
            _remoteInfoDictionary[MPMediaItemPropertyAlbumTitle] = self.currentAudioModel.ringName;
        }
        _remoteInfoDictionary[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.currentTime)];
        _remoteInfoDictionary[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.duration)];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = _remoteInfoDictionary;
}

#pragma mark - 缓存相关
- (NSString *)hy_cachePath:(NSURL *)audioUrl{
    if ([HYAudioPlayerTool isLocalAudio:audioUrl] || ![HYAudioPlayerTool isNSURL:audioUrl] || !audioUrl) {
        return nil;
    }
    return [HYAudioFileManager hy_cachePath:audioUrl];
}

- (CGFloat)hy_cacheSize:(BOOL)currentUser{
    return [HYAudioFileManager hy_cacheSize:currentUser];
}

- (BOOL)hy_clearAudioCache:(NSURL *)audioUrl{
    return [HYAudioFileManager hy_clearAudioCache:audioUrl];
}

- (BOOL)hy_clearUserCache:(BOOL)currentUser{
    return [HYAudioFileManager hy_clearUserCache:currentUser];
}

#pragma mark - 统一状态代理
- (void)hy_getStatusCode:(NSUInteger)statusCode{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(hy_player:didGetStatusCode:)]) {
            [self.delegate hy_player:self didGetStatusCode:statusCode];
        }
    });
}

#pragma mark ----- 播放器状态
-(void)hy_playerStatusCode:(HYAudioPlayerState)statusCode{
    self.state = statusCode;
    if ([self.delegate respondsToSelector:@selector(hy_player:playerStateCode:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate hy_player:self playerStateCode:statusCode];
        });
    }
}

#pragma mark ----- 设置timeMode
- (void)setTimerMode:(HYAudioPlayerTimerMode)timerMode{
    _timerMode = timerMode;
    
    NSDate *date = [NSDate date];
    if (self.timerMode == HYAudioPlayerTimerModeNone) {
        self.pauseTimeDate = nil;
    }else if (self.timerMode == HYAudioPlayerTimerModeFifteen){
        self.pauseTimeDate = [NSDate dateWithTimeInterval:15 * 60 sinceDate:date];
    }else if (self.timerMode == HYAudioPlayerTimerModeThirty){
        self.pauseTimeDate = [NSDate dateWithTimeInterval:30 * 60 sinceDate:date];
    }else{
        self.pauseTimeDate = [NSDate dateWithTimeInterval:60 * 60 sinceDate:date];
    }
}

@end
