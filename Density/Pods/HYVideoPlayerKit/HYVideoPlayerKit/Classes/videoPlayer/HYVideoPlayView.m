//
//  HYVideoPlayView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "HYVideoPlayView.h"
#import "HYVideoPlaySliderModuleView.h"
#import "HYVideoThumbnail.h"
#import "UIResponder+HYCurrentViewController.h"
#import "HYUtilsMacro.h"

static NSString *STATUS_KEYPATH = @"status";
static NSString *STATUS_KEYPATH_ID = @"PlayerItemStatusContext";
static NSString *LOADEDTIMERANGES_KEYPATH = @"loadedTimeRanges";
static NSString *PLAYBACKBUFFEREMPTY_KEYPATH = @"playbackBufferEmpty";
static NSString *PLAYBACKLIKRLYTOKEEPUP_KEYPATH = @"playbackLikelyToKeepUp";
#define REFRESH_INTERVAL 0.05f


@interface HYVideoPlayView ()

@property (nonatomic, strong) NSURL                 *url;
@property (nonatomic, strong) AVAsset               *asset;
@property (nonatomic, strong) AVPlayer              *player;
@property (nonatomic, assign) CGRect                playViewFrame;
@property (nonatomic, strong) HYVideoPlaySliderModuleView  *sliderModuleView;
@property (nonatomic, strong) id                    timeObserver;
@property (nonatomic, strong) id                    itemEndObserver;
@property (nonatomic, strong) HYVideoPlayContext          *context;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;//!< 菊花

@end



@implementation HYVideoPlayView
- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url context:(HYVideoPlayContext *)context {
    if (self = [super initWithFrame:frame]) {
        self.playViewFrame = frame;
        self.asset = [AVAsset assetWithURL:url];
        self.context = context;
        [self initPlayer];
        [self initUI];
        [self setCongfin];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame asset:(AVAsset *)asset context:(HYVideoPlayContext *)context {
    if (self = [super initWithFrame:frame]) {
        self.playViewFrame = frame;
        self.asset = asset;
        self.context = context;
        [self initPlayer];
        [self initUI];
        [self setCongfin];
    }
    return self;
}

- (void)dealloc {
    HYDebugLog(@"%s",__func__);
    [self.player.currentItem removeObserver:self forKeyPath:STATUS_KEYPATH context:nil];
}

- (void)setCongfin {
    self.startPlayTime = 0;
    self.endPlayTime = CMTimeGetSeconds(self.player.currentItem.duration);
}

- (void)initPlayer {
    // 元素
    NSArray *keys = @[@"tracks",@"duration",@"commonMetadata",@"availableMediaCharacteristicsWithMediaSelectionOptions"];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, self.playViewFrame.size.width, self.playViewFrame.size.height);
    [self.layer addSublayer:playerLayer];
    
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self.player.currentItem addObserver:self forKeyPath:STATUS_KEYPATH options:0 context:nil];

}

- (void)initUI {
    
    // UI
    self.backgroundColor = [UIColor blackColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.context.isShowSliderView) {// 展示的时候才显示
        self.sliderModuleView = [[HYVideoPlaySliderModuleView alloc] initWithFrame:CGRectMake(0, self.playViewFrame.size.height - 40, self.playViewFrame.size.width, 40)];
        [self addSubview:self.sliderModuleView];
        
        kWeakSelf
        self.sliderModuleView.playButtonBlock = ^(HYVideoPlaySliderModulePlayButtonStatus playButtonStatus) {
            if (playButtonStatus == HYVideoPlaySliderModulePlayButtonStatus_toPlay) {
                [weakSelf.player play];
                [weakSelf.sliderModuleView videoPlay];
            }else if (playButtonStatus == HYVideoPlaySliderModulePlayButtonStatus_toPause) {
                [weakSelf.player pause];
                [weakSelf.sliderModuleView videoPause];
            }
        };
        
        self.sliderModuleView.playSeekToTimeBlock = ^(double playSeekToTime) {
            [weakSelf _seekToTime:playSeekToTime];
        };
    }
    
    CGFloat activityIndicatorView_w = 20;
    CGFloat activityIndicatorView_h = 20;
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, activityIndicatorView_w, activityIndicatorView_h)];
    self.activityIndicatorView.center = self.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.activityIndicatorView startAnimating];
    [self addSubview:self.activityIndicatorView];
    
}

- (void)play {
    [self _seekToTime:self.startPlayTime];
    [self.player play];
    [self.sliderModuleView videoPlay];
}

- (void)pause {
    [self.player pause];
    [self.sliderModuleView videoPause];
}

- (void)stop {
    [self.player pause];
    [self _seekToTime:0];
}

- (void)seekToTime:(double)time {
    [self _seekToTime:time];
}

- (void)_seekToTime:(NSTimeInterval)time {
    int32_t timeScale = self.player.currentItem.asset.duration.timescale;
    CMTime t_time = CMTimeMakeWithSeconds(time, timeScale);
    [self.player seekToTime:t_time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:STATUS_KEYPATH]) {
                
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"HYVideoPlayView----observeValueForKeyPath--AVPlayerItemStatusReadyToPlay");

            [self.player play];
            [self.sliderModuleView videoPlay];
            
            double duration = CMTimeGetSeconds(self.player.currentItem.duration);
            [self.sliderModuleView setPlaySliderTotalTime:duration];
            
            [self addPlayerItemTimeObserver];
            [self addItemEndObserverForPlayerItem];
            [self generateThumbnails];
            
        }else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"HYVideoPlayView----observeValueForKeyPath--AVPlayerItemStatusFailed");
            self.activityIndicatorView.hidden = YES;

            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"播放失败，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [vc addAction:action];
            [self.hy_currentViewController presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)addPlayerItemTimeObserver {
    
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    kWeakSelf
    void (^callBack)(CMTime time) = ^(CMTime time) {
        
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);

        [weakSelf.sliderModuleView setPlaySliderCurrentTime:currentTime];
        [weakSelf.sliderModuleView setSliderViewValue:currentTime/duration];
        
//        NSLog(@"addPlayerItemTimeObserver   currentTime - :%f",currentTime);
//        NSLog(@"addPlayerItemTimeObserver   startPlayTime - :%f",weakSelf.startPlayTime);
//        NSLog(@"addPlayerItemTimeObserver   endPlayTime - :%f",weakSelf.endPlayTime);

        if (currentTime >= weakSelf.endPlayTime && weakSelf.endPlayTime > 0 && weakSelf.startPlayTime >= 0 && weakSelf.startPlayTime < weakSelf.endPlayTime) {// 截取的区间轮播
            
            [weakSelf _seekToTime:weakSelf.startPlayTime];
            [weakSelf.player play];
        }
        
        if (weakSelf.currentTimeBlock) {
            weakSelf.currentTimeBlock(currentTime, duration);
        }
        
        weakSelf.activityIndicatorView.hidden = YES;

    };
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:queue
                                                             usingBlock:callBack];
    
}

- (void)addItemEndObserverForPlayerItem {

    kWeakSelf
    void (^callBack)(NSNotification * _Nonnull note) = ^(NSNotification * _Nonnull notification) {
        
        if (weakSelf.context.isLoopPlay) {
            [weakSelf seekToTime:weakSelf.startPlayTime];
            [weakSelf.player play];
            [weakSelf.sliderModuleView videoPlay];
            
            NSLog(@"startAnimateMoveLineViewAnimateDuration--isLoopPlay");
            
        }else {
            
            [weakSelf seekToTime:0.0];
            [weakSelf.player pause];
            [weakSelf.sliderModuleView videoPause];
        }
    };
    
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                             object:self.player.currentItem
                                                                              queue:[NSOperationQueue mainQueue]
                                                                         usingBlock:callBack];
}

// 获取缩率图
- (void)generateThumbnails {
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    
    self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);

    CMTime duration = self.asset.duration;

    CGFloat duratioTime = CMTimeGetSeconds(duration);
    CGFloat defautTime = 600;//默认十分钟600秒
    
    CGFloat increment = 60;// 1分钟的区间
    CGFloat count = 10;
    if (duratioTime <= defautTime) {// 小于等于 10分钟 时间10等分
        increment = duratioTime / count;
    }else {
        count = duratioTime / increment;
    }
    
    
    NSMutableArray *times = [NSMutableArray array];
    CGFloat currentValue = increment * duration.timescale;
    
    for (int i = 0; i < count; i++) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment * duration.timescale;
    }
    
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];

    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime,
                CGImageRef imageRef,
                CMTime actualTime,
                AVAssetImageGeneratorResult result,
                NSError *error) {
        
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            id thumbnail = [HYVideoThumbnail thumbnailWithImage:image time:actualTime];
            [images addObject:thumbnail];
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }

        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.thumbnailImagesBlock) {
                    self.thumbnailImagesBlock(images,CMTimeGetSeconds(self.player.currentItem.duration));
                }
            });
        }
    };

    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                              completionHandler:handler];
}

@end


NSString * _Nullable const HYVideoPlayIsShowViewKey = @"HYVideoPlayIsShowViewKey";
NSString * _Nullable const HYVideoPlayIsLoopPlayKey = @"HYVideoPlayIsLoopPlayKey";// 播放器结束时 是否循环播放器
