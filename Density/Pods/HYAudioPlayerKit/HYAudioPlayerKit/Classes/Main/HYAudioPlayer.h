//
//  HYAudioPlayer.h
//  HyWallPaper
//
//  Created by Json on 2020/2/10.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "HYAudioPlayerModel.h"

//播放器状态
typedef NS_ENUM(NSInteger, HYAudioPlayerState) {
    HYAudioPlayerStateStopped = 0,    // 停止播放
    HYAudioPlayerStateFailed,     // 播放失败
    HYAudioPlayerStateBuffering,  // 缓冲中
    HYAudioPlayerStatePlaying,    // 播放中
    HYAudioPlayerStatePause,      // 暂停播放
    HYAudioPlayerStateDefault = HYAudioPlayerStateStopped // 默认是停止播放
};

//播放模式
typedef NS_ENUM(NSInteger, HYAudioPlayerMode){
    HYAudioPlayerModeOrderCycle,     //顺序循环
    HYAudioPlayerModeShuffleCycle,    //随机循环
    HYAudioPlayerModeSingleCycle,    //单曲循环
    HYAudioPlayerModeOnlyOnce       //单曲只播放一次，默认
};

typedef NS_ENUM(NSInteger, HYAudioPlayerTimerMode){
    HYAudioPlayerTimerModeNone,     //定时关闭
    HYAudioPlayerTimerModeFifteen,    //15分钟关闭
    HYAudioPlayerTimerModeThirty,    //30分钟关闭
    HYAudioPlayerTimerModeSixty       //60分钟关闭
};

//状态码
typedef NS_ENUM(NSUInteger, HYAudioPlayerStatusCode) {
    
    HYAudioPlayerStatusNoNetwork = 2100, //未缓存的网络音频，点击播放时若无网络会返回该状态码。缓冲完成前若断网也会返回该状态码。（HYAudioPlayer 支持运行时断点续传，即缓冲时网络从无到有，可以断点续传，而某音频没缓冲完就退出app，再进入app没做断点续传，以上特点与QQ音乐一致）
    HYAudioPlayerStatusViaWWAN = 2101, //WWAN网络状态（注意：属性isObserveWWAN（默认NO）为YES时，对于未缓存的网络音频，点击该音频时开始缓冲时返回该状态码。而音频正在缓冲时，网络状态由wifi到wwan并不会返回该状态码，以上特点与QQ音乐一致）
    
    HYAudioPlayerStatusTimeOut = 2200, //音频请求超时（根据服务器返回的状态码）
    
    HYAudioPlayerStatusFailed = 2300, //音频无法播放（AVPlayerItemStatusFailed）
    HYAudioPlayerStatusUnknown = 2301, //未知错误（AVPlayerItemStatusUnknown）
    
    HYAudioPlayerStatusCacheFail = 2400, //当前音频缓存失败
    HYAudioPlayerStatusCacheSucc = 2401  //当前音频缓存成功
};


@class HYAudioPlayer;

@protocol HYAudioPlayerDataSource <NSObject>

@required

/**
 数据源1：音频数组
 */
- (NSArray<HYAudioPlayerModel *> *)hy_audioDataForPlayer:(HYAudioPlayer *)player;

@end


@protocol HYAudioPlayerDelegate <NSObject>

@optional
/**
 音频已经加入播放队列
 */
- (void)hy_playerAudioAddToPlayQueue:(HYAudioPlayer *)player;

/**
 准备播放
 */
- (void)hy_playerReadyToPlay:(HYAudioPlayer *)player;

/**
 缓冲进度代理  (属性isObserveBufferProgress(默认YES)为YES时有效）
 @param bufferProgress 缓冲进度
 */
- (void)hy_player:(HYAudioPlayer *)player bufferProgress:(CGFloat)bufferProgress;

/**
 播放进度代理 （属性isObserveProgress(默认YES)为YES时有效）
 @param progress 播放进度
 @param currentTime 当前播放到的时间
 */
- (void)hy_player:(HYAudioPlayer *)player progress:(CGFloat)progress currentTime:(CGFloat)currentTime;

/**
 播放结束代理
 （默认播放结束后调用hy_next，如果实现此代理，播放结束逻辑由您处理）
 */
- (void)hy_playerDidPlayToEndTime:(HYAudioPlayer *)player;

/**
 播放状态码代理
 @param statusCode 状态码(统一在主线程返回)
 */
- (void)hy_player:(HYAudioPlayer *)player didGetStatusCode:(HYAudioPlayerStatusCode)statusCode;
/**
播放器状态码代理
@param stateCode 状态码(统一在主线程返回)
*/
- (void)hy_player:(HYAudioPlayer *)player playerStateCode:(HYAudioPlayerState)stateCode;

/**
 播放器被系统打断代理
 （默认被系统打断暂停播放，打断结束检测能够播放则恢复播放，如果实现此代理，打断逻辑由您处理）
 @param isInterrupted YES:被系统打断开始  NO:被系统打断结束
 */
- (void)hy_player:(HYAudioPlayer *)player isInterrupted:(BOOL)isInterrupted;

/**
 监听耳机插入拔出代理
 @param isHeadphone YES:插入 NO:拔出
 */
- (void)hy_player:(HYAudioPlayer *)player isHeadphone:(BOOL)isHeadphone;

@end


@interface HYAudioPlayer : NSObject

/** HYAudioPlayer数据源 */
@property (nonatomic, weak) id<HYAudioPlayerDataSource> dataSource;

/** HYAudioPlayer代理 */
@property (nonatomic, weak) id<HYAudioPlayerDelegate> delegate;

/**
 播放器类型，默认AVAudioSessionCategoryPlayback
 Tips:AVAudioSessionCategoryPlayback，需在工程里设置targets->capabilities->选择backgrounds modes->勾选audio,airplay,and picture in picture
 */
@property (nonatomic, assign) AVAudioSessionCategory category;

/**
 播放模式，默认HYPlayerModeOnlyOnce。
 */
@property (nonatomic, assign) HYAudioPlayerMode playMode;

/**
 定时模式
 */
@property (nonatomic, assign) HYAudioPlayerTimerMode timerMode;

/**
 当前正在播放的音频Id
 */
@property (nonatomic, assign) NSInteger currentAudioId;
/**
 是否监听播放进度，默认YES
 */
@property (nonatomic, assign) BOOL isObserveProgress;

/**
 是否监听缓冲进度，默认YES
 */
@property (nonatomic, assign) BOOL isObserveBufferProgress;

/**
 是否需要缓存，默认YES
 */
@property (nonatomic, assign) BOOL isNeedCache;

/**
 是否监测WWAN无线广域网（2g/3g/4g）,默认NO。
 播放本地音频（工程目录和沙盒文件）不监测。
 播放网络音频时，HYPlayer为您实现无网络有缓存播放缓存，无网络无缓存返回无网络错误码，wifi下自动播放。开启该属性，当网络为WWAN时，通过代理6返回状态码HYPlayerStatusViaWWAN。
 */
@property (nonatomic, assign) BOOL isObserveWWAN;

/**
 是否监听服务器文件修改时间，默认NO。
 第一次请求某资源时，HYAudioPlayer缓存文件的同时会记录文件在服务器端的修改时间。
 开启该属性，以后播放该资源时，HYAudioPlayer会判断服务端文件是否修改过，修改过则加载新资源，没有修改过则播放缓存文件。
 关闭此属性，有缓存时将直接播放缓存，不做更新校验，在弱网环境下播放响应速度更快。
 无网络连接时，有缓存直接播放缓存文件。
 */
@property (nonatomic, assign) BOOL isObserveFileModifiedTime;

/**
 播放器状态
 */
@property (nonatomic, readonly, assign) HYAudioPlayerState state;

/**
 当前正在播放的音频model
 */
@property (nonatomic, readonly, strong) HYAudioPlayerModel *currentAudioModel;

///**
// 当前正在播放的音频信息model
// */
//@property (nonatomic, readonly, strong) HYAudioPlayerInfoModel *currentAudioInfoModel;

/**
 当前音频缓冲进度
 */
@property (nonatomic, readonly, assign) CGFloat bufferProgress;

/**
 当前音频播放进度
 */
@property (nonatomic, readonly, assign) CGFloat progress;

/**
 当前音频当前时间
 */
@property (nonatomic, readonly, assign) CGFloat currentTime;

/**
 当前音频总时长
 */
@property (nonatomic, readonly, assign) CGFloat totalTime;


/**
 单例
 */
+ (HYAudioPlayer *)sharedPlayer;

/**
 初始化播放器
 
 @param userId 用户Id。
 isNeedCache（默认YES）为YES时，若同一设备登录不同账号：
 1.userId不为空时，HYPlayer将为每位用户建立不同的缓存文件目录。例如，user_001,user_002...
 2.userId为nil或@""时，统一使用HYAudioPlayerCache文件夹下的user_public作为缓存目录。
 isNeedCache为NO时,userId设置无效，此时不会在沙盒创建缓存目录。
 */
- (void)hy_initPlayerWithUserId:(NSString *)userId;

/**
 刷新数据源数据
 */
- (void)hy_reloadData;

/**
 选择audioId对应的音频开始播放。
 说明：HYAudioPlayer通过数据源方法提前获取数据，通过hy_playWithAudioId选择对应音频播放。
 而在删除、增加音频后需要调用[[HYAudioPlayer shareInstance] hy_reloadData];刷新数据。
 */
- (void)hy_playWithAudioId:(NSUInteger)audioId;

/**
 播放
 */
- (void)hy_play;

/**
 暂停
 */
- (void)hy_pause;

/**
 下一首
 */
- (void)hy_next;

/**
 上一首
 */
- (void)hy_last;

/**
 音频跳转
 
 @param value 时间百分比
 @param completionBlock seek结束
 */
- (void)hy_seekToTime:(CGFloat)value completionBlock:(void(^)(void))completionBlock;

/**
 倍速播放（iOS10之后系统支持的倍速常数有0.50, 0.67, 0.80, 1.0, 1.25, 1.50和2.0）
 @param rate 倍速
 */
- (void)hy_setRate:(CGFloat)rate;

/**
 释放播放器，还原其他播放器
 */
- (void)hy_deallocPlayer;
/**
 进入视频播放界面
 */
- (void)enterOtherMediaPage;
/**
 退出视频播放界面
 */
- (void)leaveOtherMediaPage;


#pragma mark - 缓存相关
/**
 audioUrl对应的音频在本地的缓存地址
 
 @param audioUrl 网络音频url
 @return 无缓存时返回nil
 */
- (NSString *)hy_cachePath:(NSURL *)audioUrl;

/**
 HYAudioPlayer的缓存大小
 
 @param currentUser YES:当前用户  NO:所有用户
 @return 缓存大小
 */
- (CGFloat)hy_cacheSize:(BOOL)currentUser;

/**
 清除音频缓存
 
 @param audioUrl 网络音频url
 @return 是否清除成功（无缓存时返回YES）
 */
- (BOOL)hy_clearAudioCache:(NSURL *)audioUrl;

/**
 清除用户缓存
 
 @param currentUser YES:清除当前用户缓存  NO:清除所有用户缓存
 @return 是否清除成功（无缓存时返回YES）
 */
- (BOOL)hy_clearUserCache:(BOOL)currentUser;

/** 音频栏目ID */
@property (nonatomic , copy) NSString * columnID;

/** 定时模式剩余时间 */
@property (nonatomic, strong) NSString *timeRemaining;

/** 是否需要后台播放 */
@property (nonatomic, assign, getter=isneedRemoteControl) BOOL needRemoteControl;

/** model数据数组 */
@property (nonatomic, strong ,readonly) NSMutableArray<HYAudioPlayerModel *> *playerModelArray;


@end


