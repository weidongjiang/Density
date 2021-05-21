//
//  UIImage+HYImage.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/5/11.
//

#import "UIImage+HYImage.h"
#import "UIImage+DM.h"

@implementation UIImage (HYImage)

+ (UIImage *)hy_imageLightImageName:(NSString *)lightImageName darkImageName:(NSString *)darkImageName {
    return [UIImage dm_imageWithNameLight:lightImageName dark:darkImageName];
}

+ (UIImage *)hy_imageLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
    return [UIImage dm_imageWithImageLight:lightImage dark:darkImage];
}
@end


