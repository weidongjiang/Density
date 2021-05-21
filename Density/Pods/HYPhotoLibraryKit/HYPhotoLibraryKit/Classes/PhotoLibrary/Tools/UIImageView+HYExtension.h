//
//  UIImageView+HYExtension.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/17.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HYPhotoModel;
@interface UIImageView (HYExtension)

- (void)hy_setImageWithModel:(HYPhotoModel *)model progress:(void (^)(CGFloat progress, HYPhotoModel *model))progressBlock completed:(void (^)(UIImage * image, NSError * error, HYPhotoModel * model))completedBlock ;

@end


