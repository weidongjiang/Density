//
//  HYVideoPlaySliderModuleView.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HYVideoPlaySliderModulePlayButtonStatus) {
    HYVideoPlaySliderModulePlayButtonStatus_toPlay   = 0, // 去播放
    HYVideoPlaySliderModulePlayButtonStatus_toPause  = 1, // 去暂停
};

typedef void(^HYVideoPlaySliderModulePlayButtonBlock)(HYVideoPlaySliderModulePlayButtonStatus playButtonStatus);

typedef void(^HYVideoPlaySliderModuleSetPlaySeekToTimeBlock)(double playSeekToTime);



NS_ASSUME_NONNULL_BEGIN

@interface HYVideoPlaySliderModuleView : UIView

@property (nonatomic, copy) HYVideoPlaySliderModulePlayButtonBlock playButtonBlock;

@property (nonatomic, copy) HYVideoPlaySliderModuleSetPlaySeekToTimeBlock playSeekToTimeBlock;

- (void)setPlaySliderCurrentTime:(double)currentTime;

- (void)setPlaySliderTotalTime:(double)totalTime;

- (void)setSliderViewValue:(double)value;

- (void)videoPlay;

- (void)videoPause;


@end

NS_ASSUME_NONNULL_END
