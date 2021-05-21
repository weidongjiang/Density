//
//  UIColor+HYUtilities.m
//  EasyDarkMode
//
//  Created by 蒋伟东 on 2021/5/10.
//

#import "UIColor+HYUtilities.h"
#import "UIColor+DM.h"

@implementation UIColor (HYUtilities)

+ (UIColor *)hy_colorWithColorLight:(UIColor *)light dark:(UIColor *)dark {
    return [UIColor dm_colorWithColorLight:light dark:dark];
}

+ (UIColor *)hy_colorWithHex:(NSString *)hex {
    return [self hy_colorWithHex:hex alpha:1.0f];
}


+ (UIColor *)hy_colorLightWithLightHex:(NSString *)lightHex colorDark:(NSString *)darkHex {
    return [UIColor dm_colorWithColorLight:[self hy_colorWithHex:lightHex alpha:1.0f] dark:[self hy_colorWithHex:darkHex alpha:1.0f]];
}


+ (UIColor *)hy_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanString];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)hy_colorLightWithLightHex:(NSString *)lightHex
                            lightAlpha:(CGFloat)lightAlpha
                             colorDark:(NSString *)darkHex
                             darkAlpha:(CGFloat)darkAlpha {
    return [UIColor dm_colorWithColorLight:[self hy_colorWithHex:lightHex alpha:lightAlpha] dark:[self hy_colorWithHex:darkHex alpha:darkAlpha]];
}


+ (UIColor *)hy_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [self hy_rgbColor:r g:g b:b a:1.0f];
}

+ (UIColor *)hy_rgbColorLightR:(CGFloat)lightR
                        lightG:(CGFloat)lightG
                        lightB:(CGFloat)lightB
                         darkR:(CGFloat)darkR
                         darkG:(CGFloat)darkG
                         darkB:(CGFloat)darkB {
    
    return [UIColor dm_colorWithColorLight:[self hy_rgbColor:lightR g:lightG b:lightB] dark:[self hy_rgbColor:darkR g:darkG b:darkB]];

}


+ (UIColor *)hy_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
    r = MAX(0.0f, MIN(255.0f, r));
    g = MAX(0.0f, MIN(255.0f, g));
    b = MAX(0.0f, MIN(255.0f, b));
    a = MAX(0.0f, MIN(1.0f, a));
    
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a];
}

+ (UIColor *)hy_rgbColorLightR:(CGFloat)lightR
                        lightG:(CGFloat)lightG
                        lightB:(CGFloat)lightB
                        lightA:(CGFloat)lightA
                         darkR:(CGFloat)darkR
                         darkG:(CGFloat)darkG
                         darkB:(CGFloat)darkB
                         darkA:(CGFloat)darkA {
    return [UIColor dm_colorWithColorLight:[self hy_rgbColor:lightR g:lightG b:lightB a:lightA] dark:[self hy_rgbColor:darkR g:darkG b:darkB a:darkA]];
}


+ (UIColor *)hy_color:(CGFloat)same {
    return [self hy_color:same alpha:1.0f];
}

+ (UIColor *)hy_color:(CGFloat)same alpha:(CGFloat)alpha {
    same = MAX(0.0f, MIN(255.0f, same));
    alpha = MAX(0.0f, MIN(1.0f, alpha));
    return [self hy_rgbColor:same g:same b:same a:alpha];
}

+ (UIColor *)hy_randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)hy_topicHeaderBgColor {
    return [self hy_rgbColor:246.0 g:246.0 b:246.0 a:1];
}

+ (UIColor *)hy_discoveryBackgroundColor {
    return [self hy_rgbColor:255 g:255 b:255 a:1];
}

@end
