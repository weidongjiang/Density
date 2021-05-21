//
//  HYEditVideoViewController.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HYWditVideoCutTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYEditVideoViewController : UIViewController

/// 剪辑视频界面返回按钮事件
@property (nonatomic,copy) void (^backButtonActionBlock)(void);

/// 视频剪辑输出路径地址
@property (nonatomic,copy) void (^editVideoCompletionBlock)(NSURL *outPutUrl);

- (instancetype)initWithAsset:(AVURLAsset *)asset;

- (instancetype)initWithUrl:(NSURL *)url;// 支持file:// http:// https://

@end

NS_ASSUME_NONNULL_END
