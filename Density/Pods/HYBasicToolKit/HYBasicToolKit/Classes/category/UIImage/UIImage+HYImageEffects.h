//
//  UIImage+HYImageEffects.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HYImageEffects)

+ (UIImage *)hy_applyLightEffect;
+ (UIImage *)hy_applyExtraLightEffect;
+ (UIImage *)hy_applyDarkEffect;
+ (UIImage *)hy_applyTintEffectWithColor:(UIColor *)tintColor;
+ (UIImage *)hy_applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage * __nullable)maskImage;

@end

NS_ASSUME_NONNULL_END
