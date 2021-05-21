//
//  HYAudioPlayerTool.h
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *HYPlayerNotificationSeekEnd = @"DFPlayerNotificationSeekEnd";

#define HYPlayerWeakSelf __weak __typeof(&*self) wSelf = self;
#define HYPlayerStrongSelf __strong __typeof(&*self) sSelf = wSelf;

#define HYPlayerHighGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define HYPlayerDefaultGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define HY_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HY_FONTSIZE(size) ((size) / 1334.0) * HY_SCREEN_HEIGHT



/**
 DFPlayer工具类
 */
@interface HYAudioPlayerTool : NSObject

// 链接
+ (NSURL *)customURL:(NSURL *)URL;
+ (NSURL *)originalURL:(NSURL *)URL;

// 是否是本地音频
+ (BOOL)isLocalAudio:(NSURL *)URL;

// 是否是NSURL类型
+ (BOOL)isNSURL:(NSURL *)URL;

@end


@interface UIImage (HYAudioPlayerImageExtensions)

// 裁剪图片
- (UIImage *)hy_imageByResizeToSize:(CGSize)size;

@end


@interface NSString (HYAudioPlayerStringExtensions)

// 字符串去空字符
- (NSString *)hy_removeEmpty;

// 判断是否为空
- (BOOL)hy_isEmpty;

// 是否包含字母
- (BOOL)hy_isContainLetter;


@end


