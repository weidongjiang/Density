//
//  UIView+HYViewRect.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/27.
//

#import "UIView+HYViewRect.h"

@implementation UIView (HYViewRect)

- (CGRect)hy_viewRectfromWindow {
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    return rect;
}
- (CGFloat)hy_viewCenterYfromWindow {
    CGRect windowRect = [self hy_viewRectfromWindow];
    CGFloat centerY = windowRect.origin.y + windowRect.size.height / 2;
    return centerY;
}

@end
