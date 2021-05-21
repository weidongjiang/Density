//
//  UIColor+HYUtilities.h
//  EasyDarkMode
//
//  Created by 蒋伟东 on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HYUtilities)



/// UIColor
/// @param light 浅色
/// @param dark 深色
+ (UIColor *)hy_colorWithColorLight:(UIColor *)light dark:(UIColor *)dark;

/**
 生成给定Hex字符串的UIColor

 @param hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
 @return 返回给定Hex字符串的UIColor
 */
+ (UIColor *)hy_colorWithHex:(NSString *)hex;

/// 生成给定Hex字符串的UIColor  alpha=1
/// @param lightHex 浅色 hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
/// @param darkHex 深色 hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
+ (UIColor *)hy_colorLightWithLightHex:(NSString *)lightHex colorDark:(NSString *)darkHex;

/**
 生成给定Hex字符串且带alpha的UIColor

 @param hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
 @param alpha 取值范围 (0.0f ~ 1.0f)
 @return 返回给定Hex字符串且带alpha的UIColor
 */
+ (UIColor *)hy_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

/// 生成给定Hex字符串的UIColor
/// @param lightHex 浅色 hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
/// @param lightAlpha 浅色 hex alpha 取值范围 (0.0f ~ 1.0f)
/// @param darkHex 深色 hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
/// @param darkAlpha 深色 hex alpha 取值范围 (0.0f ~ 1.0f)
+ (UIColor *)hy_colorLightWithLightHex:(NSString *)lightHex
                            lightAlpha:(CGFloat)lightAlpha
                             colorDark:(NSString *)darkHex
                             darkAlpha:(CGFloat)darkAlpha;

/**
 生成给定RGB值UIColor

 @param r 取值范围 (0.0f ~ 255.0f)
 @param g 取值范围 (0.0f ~ 255.0f)
 @param b 取值范围 (0.0f ~ 255.0f)
 @return 返回给定RGB值UIColor
 */
+ (UIColor *)hy_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;


/// 生成给定RGB值UIColor 浅色 深色
/// @param lightR 浅色 r 取值范围 (0.0f ~ 255.0f)
/// @param lightG 浅色 g 取值范围 (0.0f ~ 255.0f)
/// @param lightB 浅色 b 取值范围 (0.0f ~ 255.0f)
/// @param darkR 深色 r 取值范围 (0.0f ~ 255.0f)
/// @param darkG 深色 g 取值范围 (0.0f ~ 255.0f)
/// @param darkB 深色 b 取值范围 (0.0f ~ 255.0f)
+ (UIColor *)hy_rgbColorLightR:(CGFloat)lightR
                        lightG:(CGFloat)lightG
                        lightB:(CGFloat)lightB
                         darkR:(CGFloat)darkR
                         darkG:(CGFloat)darkG
                         darkB:(CGFloat)darkB;

/**
 生成给定RGBA值UIColor

 @param r 取值范围 (0.0f ~ 255.0f)
 @param g 取值范围 (0.0f ~ 255.0f)
 @param b 取值范围 (0.0f ~ 255.0f)
 @param a 取值范围 (0.0f ~ 1.0f)
 @return 返回给定RGBA值UIColor
 */
+ (UIColor *)hy_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;


/// 生成给定RGBA值UIColor 浅色 深色
/// @param lightR 浅色 r 取值范围 (0.0f ~ 255.0f)
/// @param lightG 浅色 g 取值范围 (0.0f ~ 255.0f)
/// @param lightB 浅色 b 取值范围 (0.0f ~ 255.0f)
/// @param lightA 浅色 a 取值范围 (0.0f ~ 1.0f)
/// @param darkR 深色 r 取值范围 (0.0f ~ 255.0f)
/// @param darkG 深色 g 取值范围 (0.0f ~ 255.0f)
/// @param darkB 深色 b 取值范围 (0.0f ~ 255.0f)
/// @param darkA 深色 a 取值范围 (0.0f ~ 1.0f)
+ (UIColor *)hy_rgbColorLightR:(CGFloat)lightR
                        lightG:(CGFloat)lightG
                        lightB:(CGFloat)lightB
                        lightA:(CGFloat)lightA
                         darkR:(CGFloat)darkR
                         darkG:(CGFloat)darkG
                         darkB:(CGFloat)darkB
                         darkA:(CGFloat)darkA;
/**
 生成RGB值都是same的UIColor

 @param same 取值范围 (0.0f ~ 255.0f)
 @return 返回RGB值都是same的UIColor
 */
+ (UIColor *)hy_color:(CGFloat)same;


/**
 生成RGB值都是same且带alpha的UIColor

 @param same 取值范围 (0.0f ~ 255.0f)
 @param alpha 取值范围 (0.0f ~ 1.0f)
 @return 返回RGB值都是same且带alpha的UIColor
 */
+ (UIColor *)hy_color:(CGFloat)same alpha:(CGFloat)alpha;


/**
 生成随机颜色的UIColor

 @return 返回随机颜色的UIColor
 */
+ (UIColor *)hy_randomColor;


/**
 生成topicHeaderBgColor  r:246.0 g:246.0 b:246.0 a:1

 @return UIColor
 */
+ (UIColor *)hy_topicHeaderBgColor;

/**
 生成discoveryBackgroundColor r:255 g:255 b:255 a:1

 @return UIColor
 */
+ (UIColor *)hy_discoveryBackgroundColor;
@end

NS_ASSUME_NONNULL_END
