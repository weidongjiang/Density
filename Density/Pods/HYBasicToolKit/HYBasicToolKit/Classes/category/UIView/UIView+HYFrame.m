//
//  UIView+HYFrame.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "UIView+HYFrame.h"

@implementation UIView (HYFrame)

- (CGFloat)hy_x {
    return self.frame.origin.x;
}
- (void)setHy_x:(CGFloat)hy_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = hy_x;
    self.frame        = newFrame;
}

- (CGFloat)hy_y {
    return self.frame.origin.y;
}
- (void)setHy_y:(CGFloat)hy_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = hy_y;
    self.frame        = newFrame;
}

- (CGFloat)hy_width {
    return CGRectGetWidth(self.bounds);
}
- (void)setHy_width:(CGFloat)hy_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = hy_width;
    self.frame          = newFrame;
}

- (CGFloat)hy_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setHy_height:(CGFloat)hy_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = hy_height;
    self.frame           = newFrame;
}

- (CGFloat)hy_top {
    return self.frame.origin.y;
}

- (void)setHy_top:(CGFloat)hy_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = hy_top;
    self.frame        = newFrame;
}

- (CGFloat)hy_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setHy_bottom:(CGFloat)hy_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = hy_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)hy_left {
    return self.frame.origin.x;
}

- (void)setHy_left:(CGFloat)hy_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = hy_left;
    self.frame        = newFrame;
}

- (CGFloat)hy_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setHy_right:(CGFloat)hy_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = hy_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)hy_centerX {
    return self.center.x;
}

- (void)setHy_centerX:(CGFloat)hy_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = hy_centerX;
    self.center       = newCenter;
}

- (CGFloat)hy_centerY {
    return self.center.y;
}

- (void)setHy_centerY:(CGFloat)hy_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = hy_centerY;
    self.center       = newCenter;
}

- (CGPoint)hy_origin {
    return self.frame.origin;
}

- (void)setHy_origin:(CGPoint)hy_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = hy_origin;
    self.frame      = newFrame;
}

- (CGSize)hy_size {
    return self.frame.size;
}

- (void)setHy_size:(CGSize)hy_size {
    CGRect newFrame = self.frame;
    newFrame.size   = hy_size;
    self.frame      = newFrame;
}

@end
