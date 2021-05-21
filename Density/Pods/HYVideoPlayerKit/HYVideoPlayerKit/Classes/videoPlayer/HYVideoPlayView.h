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

@end

NS_ASSUME_NONNULL_END
