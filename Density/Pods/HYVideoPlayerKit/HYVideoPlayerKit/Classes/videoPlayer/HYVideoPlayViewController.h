//
//  HYVideoPlayViewController.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/1.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HYVideoPlayView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYVideoPlayVCBackBlock)(void);

@interface HYVideoPlayViewController : UIViewController

@property (nonatomic, copy)HYVideoPlayVCBackBlock backBlock; //播放器左上角返回按钮事件回调

- (instancetype)initWithUrl:(NSURL *)url context:(HYVideoPlayContext *)context;
- (instancetype)initWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context;
- (void)play;
- (void)pause;
- (void)seekToTime:(double)time;

@end

NS_ASSUME_NONNULL_END
