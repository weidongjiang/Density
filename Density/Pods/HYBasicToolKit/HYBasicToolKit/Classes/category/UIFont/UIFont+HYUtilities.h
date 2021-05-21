//
//  UIFont+HYUtilities.h
//  EasyDarkMode
//
//  Created by 蒋伟东 on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (HYUtilities)

/// 返回对应的UIFont
/// @param name 字体 name
/// @param size 字体 size
/// @param sizeRatio 字体 size 的缩放系数，和屏幕适配有关
+ (UIFont *)hy_fontWithName:(NSString *)name size:(CGFloat)size sizeRatio:(CGFloat)sizeRatio;

/// 返回对应的UIFont 字体PingFangSC-Regular
/// @param size size 字体 size
/// @param sizeRatio 字体 size 的缩放系数，和屏幕适配有关
+ (UIFont *)hy_regularFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio;

/// 返回对应的UIFont 字体PingFangSC-Light
/// @param size size 字体 size
/// @param sizeRatio 字体 size 的缩放系数，和屏幕适配有关
+ (UIFont *)hy_lightFontOfSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio;

/// 返回对应的UIFont 字体PingFangSC-Medium
/// @param size size 字体 size
/// @param sizeRatio 字体 size 的缩放系数，和屏幕适配有关
+ (UIFont *)hy_mediumFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio;

/// 返回对应的UIFont 字体PingFangSC-Semibold
/// @param size size 字体 size
/// @param sizeRatio 字体 size 的缩放系数，和屏幕适配有关
+ (UIFont *)hy_semiboldFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio;

@end

NS_ASSUME_NONNULL_END
