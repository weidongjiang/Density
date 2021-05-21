//
//  UIView+HYFrame.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HYFrame)
@property (nonatomic) CGFloat hy_x;
@property (nonatomic) CGFloat hy_y;
@property (nonatomic) CGFloat hy_width;
@property (nonatomic) CGFloat hy_height;

@property (nonatomic) CGFloat hy_top;
@property (nonatomic) CGFloat hy_bottom;
@property (nonatomic) CGFloat hy_left;
@property (nonatomic) CGFloat hy_right;

@property (nonatomic) CGFloat hy_centerX;
@property (nonatomic) CGFloat hy_centerY;

@property (nonatomic) CGPoint hy_origin;
@property (nonatomic) CGSize  hy_size;

@end

NS_ASSUME_NONNULL_END
