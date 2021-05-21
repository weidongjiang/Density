//
//  UIFont+HYUtilities.m
//  EasyDarkMode
//
//  Created by 蒋伟东 on 2021/5/10.
//

#import "UIFont+HYUtilities.h"

@implementation UIFont (HYUtilities)

+ (UIFont *)hy_regularFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio {
    UIFont *font = [UIFont hy_fontWithName:@"PingFangSC-Regular" size:size sizeRatio:sizeRatio];
    return  font ? font : [UIFont systemFontOfSize:size * sizeRatio weight:UIFontWeightRegular];
}

+ (UIFont *)hy_lightFontOfSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio {
    UIFont *font = [UIFont hy_fontWithName:@"PingFangSC-Light" size:size sizeRatio:sizeRatio];
    return  font ? font : [UIFont systemFontOfSize:size * sizeRatio weight:UIFontWeightLight];
}

+ (UIFont *)hy_mediumFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio {
    UIFont *font = [UIFont hy_fontWithName:@"PingFangSC-Medium" size:size sizeRatio:sizeRatio];
    return  font ? font : [UIFont systemFontOfSize:size * sizeRatio weight:UIFontWeightMedium];
}

+ (UIFont *)hy_semiboldFontSize:(CGFloat)size sizeRatio:(CGFloat)sizeRatio {
    UIFont *font = [UIFont hy_fontWithName:@"PingFangSC-Semibold" size:size sizeRatio:sizeRatio];
    return  font ? font : [UIFont systemFontOfSize:size * sizeRatio weight:UIFontWeightSemibold];
}


+ (UIFont *)hy_fontWithName:(NSString *)name size:(CGFloat)size sizeRatio:(CGFloat)sizeRatio {
    UIFont *font = [UIFont fontWithName:name size:size*sizeRatio];
    if (font == nil) {
        font = [UIFont systemFontOfSize:size*sizeRatio];
    }
    return font;
}
@end

