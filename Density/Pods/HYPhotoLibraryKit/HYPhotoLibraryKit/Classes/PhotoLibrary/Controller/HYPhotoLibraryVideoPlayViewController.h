//
//  HYPhotoLibraryVideoPlayViewController.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/12.
//

#import <UIKit/UIKit.h>
//#import "HYVideoPlayView.h"
#import <HYVideoPlayerKit/HYVideoPlayView.h>
NS_ASSUME_NONNULL_BEGIN

@interface HYPhotoLibraryVideoPlayViewController : UIViewController

/// 返回按钮事件
@property (nonatomic,copy) void (^backButtonActionBlock)(void);
@property (nonatomic,copy) void (^sureButtonDidBlock)(void);

- (instancetype)initWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context;

@end

NS_ASSUME_NONNULL_END
