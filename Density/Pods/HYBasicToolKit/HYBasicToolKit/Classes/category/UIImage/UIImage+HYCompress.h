//
//  UIImage+HYCompress.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/11/10.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYCompress)

+ (NSData *)hy_compress;

+ (UIImage *)hy_linkImageCompress;

+ (UIImage *)hy_resizedImage:(CGSize)newSize;

@end


