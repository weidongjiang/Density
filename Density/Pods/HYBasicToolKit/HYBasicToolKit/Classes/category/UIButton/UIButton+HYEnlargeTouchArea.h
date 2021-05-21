//
//  UIButton+HYEnlargeTouchArea.h
//  UUVideo
//
//  Created by 朱玉 on 16/7/22.
//  Copyright © 2016年 朱玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HYEnlargeTouchArea)

- (void)hy_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;

@end
