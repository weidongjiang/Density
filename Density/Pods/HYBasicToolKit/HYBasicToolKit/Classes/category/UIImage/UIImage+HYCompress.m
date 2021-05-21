//
//  UIImage+HYCompress.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/11/10.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import "UIImage+HYCompress.h"

@implementation UIImage (HYCompress)

+ (NSData *)hy_compress {
    CGSize size = [[self class] hyImageSize];
    UIImage *resizeImage = [self hy_resizedImage:size];
    NSData *imageData;
    float imageCompressSize = 0.7f;
    if ([self calulateImageFileSize:resizeImage] < 100) {
        imageCompressSize = 1.0f;
    }
    
    if (UIImageJPEGRepresentation(resizeImage, 1.0)) {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(resizeImage, imageCompressSize);
    }else {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(resizeImage);
    }
    return imageData;
}

+ (UIImage *)hy_linkImageCompress {
    CGSize size = [[self class] hyLinkImageSize];
    UIImage *resizeImage = [self hy_resizedImage:size];
    NSData *imageData;
    float imageCompressSize = 0.7f;
    if ([self calulateImageFileSize:resizeImage] < 100) {
        imageCompressSize = 1.0f;
    }
    
    if (UIImageJPEGRepresentation(resizeImage, 1.0)) {
        //返回为png图像。
        imageData = UIImageJPEGRepresentation(resizeImage, imageCompressSize);
    }else {
        //返回为JPEG图像。
        imageData = UIImagePNGRepresentation(resizeImage);
    }
    return [UIImage imageWithData:imageData];
}
// 计算图片大小
+ (double)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }
    double dataLength = [data length] * 1.0;
    dataLength /= 1024.0;
    return dataLength;
}

// 计算比例值
- (CGSize)hyImageSize{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat boundary = 1500;
    
    // width, height <= 1500, Size remains the same
    if (width <= boundary || height <= boundary) {
        return CGSizeMake(width, height);
    }else {
        CGFloat x = MIN(width, height) / boundary;
        if (width < height) {
            width = boundary;
            height = height / x;
        } else {
            height = boundary;
            width = width / x;
        }
    }
    return CGSizeMake(width, height);
}

/**
  缩放图片到规定的状态
 */
+ (UIImage *)hy_resizedImage:(CGSize)newSize {
    CGRect newRect = CGRectMake(0, 0, newSize.width, newSize.height);
    UIGraphicsBeginImageContext(newRect.size);
    UIImage *image = (UIImage *)[self class];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:1 orientation:image.imageOrientation];
    [newImage drawInRect:newRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 计算比例值
- (CGSize)hyLinkImageSize{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat boundary = 680;
    
    // width, height <= 680, Size remains the same
    if (width <= boundary) {
        return CGSizeMake(width, height);
    }else {
        CGFloat x = width / boundary;
        width = boundary;
        height = height / x;
    }
    return CGSizeMake(width, height);
}

@end
