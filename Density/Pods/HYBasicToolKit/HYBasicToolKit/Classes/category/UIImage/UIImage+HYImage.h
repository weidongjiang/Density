//
//  UIImage+HYImage.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HYImage)

+ (UIImage *)hy_imageLightImageName:(NSString *)lightImageName darkImageName:(NSString *)darkImageName;

+ (UIImage *)hy_imageLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;

@end

NS_ASSUME_NONNULL_END
