//
//  HYVideoPlayView.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HYVideoPlayContext.h"

UIKIT_EXTERN NSString * _Nullable const HYVideoPlayIsShowViewKey;// 收否展示播放器上层的view
UIKIT_EXTERN NSString * _Nullable const HYVideoPlayIsLoopPlayKey;// 播放器结束时 是否循环播放器


typedef void(^HYVideoPlayThumbnailImagesBlock)(NSArray * _Nullable images,double totalTime);
typedef void(^HYVideoPlayCurrentTimeBlock)(double currentTime,double totalTime);

NS_ASSUME_NONNULL_BEGIN

@interface HYVideoPlayView : UIView

@property (nonatomic, copy) HYVideoPlayThumbnailImagesBlock thumbnailImagesBlock;
@property (nonatomic, copy) HYVideoPlayCurrentTimeBlock     currentTimeBlock;
@property (nonatomic, assign) double startPlayTime;//开始播放时间
@property (nonatomic, assign) double endPlayTime;//播放结束时间

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url context:(HYVideoPlayContext *)context;
- (instancetype)initWithFrame:(CGRect)frame asset:(AVAsset *)asset context:(HYVideoPlayContext *)context;
- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToTime:(double)time;


/// 当初始化后需要更新 时调用
/// @param frame frame description
- (void)updatePlayViewFrame:(CGRect)frame;

/// 当还是当前播放器，需要更换播放数据源的时候更新,新的数据源从0开始播放
/// @param url url description
- (void)updatePlayerWithUrl:(NSURL *)url;

/// 单独更新播放设置
/// @param context context description
- (void)updatePlayContext:(HYVideoPlayContext *)context;

/// 只初始化 播放器组件
- (void)initPlay;
@end

NS_ASSUME_NONNULL_END
