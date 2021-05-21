//
//  UIImageView+HYExtension.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/17.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "UIImageView+HYExtension.h"
#import "HYPhotoModel.h"
#import "SDWebImage.h"

@implementation UIImageView (HYExtension)
- (void)hy_setImageWithModel:(HYPhotoModel *)model progress:(void (^)(CGFloat progress, HYPhotoModel *model))progressBlock completed:(void (^)(UIImage * image, NSError * error, HYPhotoModel * model))completedBlock {
    __weak typeof(self) weakSelf = self;
    // 崩溃在这里说明SDWebImage版本过低
    [self sd_setImageWithURL:model.networkPhotoUrl placeholderImage:model.thumbPhoto options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        model.receivedSize = receivedSize;
        model.expectedSize = expectedSize;
        CGFloat progress = (CGFloat)receivedSize / expectedSize;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(progress, model);
            }
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error != nil) {
            model.downloadError = YES;
            model.downloadComplete = YES;
        }else {
            if (image) {
                weakSelf.image = image;
                model.imageSize = image.size;
                model.thumbPhoto = image;
                model.previewPhoto = image;
                model.downloadComplete = YES;
                model.downloadError = NO;
            }
        }
        if (completedBlock) {
            completedBlock(image,error,model);
        }
    }];

}
@end
