//
//  UIButton+HYImagePosition.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/28.
//

#import "UIButton+HYImagePosition.h"
#import <objc/runtime.h>

@implementation UIButton (HYImagePosition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method layoutSubViews_original = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method layoutSubviews_swizzled = class_getInstanceMethod(self, @selector(hy_layoutSubviews));
        method_exchangeImplementations(layoutSubViews_original, layoutSubviews_swizzled);
    });
}

#pragma mark - swizzling

- (void)hy_layoutSubviews {
    [self hy_layoutSubviews];
    if (self.hy_imagePositionMode == HYImagePositionModeDefault) {
        return;
    }
    self.adjustsImageWhenHighlighted = self.hy_adjustsImageWhenHighlighted;
    
    CGRect imgRect_temp = self.imageView.frame;
    CGRect titleRect_temp = self.titleLabel.frame;
    
    imgRect_temp.size = self.hy_imageSize;
    titleRect_temp.size = [self titleSize];
    
    CGFloat margin_x = (self.frame.size.width - (imgRect_temp.size.width + titleRect_temp.size.width) - self.hy_middleDistance) / 2;
    CGFloat margin_y = (self.frame.size.height - (imgRect_temp.size.height + titleRect_temp.size.height) - self.hy_middleDistance) / 2;
    
    // 水平布局的图片 y, 文字 y
    CGFloat img_y_h = (self.frame.size.height - imgRect_temp.size.height) / 2;
    CGFloat label_y_h = (self.frame.size.height - titleRect_temp.size.height) / 2;
    
    // 垂直布局的图片 y, 文字 y
    CGFloat img_x_v = (self.frame.size.width - imgRect_temp.size.width) / 2;
    CGFloat label_x_v = (self.frame.size.width - titleRect_temp.size.width) / 2;
    
    switch (self.hy_imagePositionMode) {
        case HYImagePositionModeRight: {
            if (!self.titleLabel.textAlignment) {
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }
            titleRect_temp.origin = CGPointMake(margin_x, label_y_h);
            imgRect_temp.origin = CGPointMake(margin_x + titleRect_temp.size.width + self.hy_middleDistance, img_y_h);
            
            break;
        }
        case HYImagePositionModeTop: {
            if (!self.titleLabel.textAlignment) {
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            imgRect_temp.origin = CGPointMake(img_x_v, margin_y);
            titleRect_temp.origin = CGPointMake(label_x_v, margin_y + imgRect_temp.size.height + self.hy_middleDistance);
            
            break;
        }
        case HYImagePositionModeBottom: {
            if (!self.titleLabel.textAlignment) {
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            titleRect_temp.origin = CGPointMake(label_x_v, margin_y);
            imgRect_temp.origin = CGPointMake(img_x_v, margin_y + titleRect_temp.size.height + self.hy_middleDistance);
            
            break;
        }
        default:
            
            break;
    }
    
    // imageView 改成用 center 和 bounds 来替换 frame，目的是为了解决按钮图片旋转时不变形
    self.imageView.bounds = CGRectMake(0, 0, imgRect_temp.size.width, imgRect_temp.size.height);
    CGFloat imageCenterX = imgRect_temp.origin.x + imgRect_temp.size.width/2;
    CGFloat imageCenterY = imgRect_temp.origin.y + imgRect_temp.size.height/2;
    self.imageView.center = CGPointMake(imageCenterX, imageCenterY);
    self.titleLabel.frame = titleRect_temp;
}

- (CGSize)titleSize {
    CGFloat maxWidth = 0.0;
    CGFloat maxHeight = 0.0;
    
    // 文字宽高需要重新计算
    CGSize titleSzie = [self calculationStringSizeWith:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (self.hy_imagePositionMode == HYImagePositionModeTop ||
        self.hy_imagePositionMode == HYImagePositionModeBottom) {
        if ((self.frame.size.height - self.hy_imageSize.height - self.hy_middleDistance) < 0) {
            self.hy_middleDistance = 0;
        }
        maxHeight = ceilf(titleSzie.height);
        maxWidth = self.frame.size.width;
    } else {
        if ((self.frame.size.width - self.hy_imageSize.width - self.hy_middleDistance) < 0) {
            self.hy_middleDistance = 0;
        }
        maxHeight = self.frame.size.height;
        maxWidth = self.frame.size.width - self.hy_imageSize.width - self.hy_middleDistance;
        maxWidth = MIN(maxWidth, ceilf(titleSzie.width));
    }
    titleSzie = CGSizeMake(maxWidth, maxHeight);
    
    return titleSzie;
}

- (CGSize)calculationStringSizeWith:(CGSize)size {
    // NSStringDrawingTruncatesLastVisibleLine: 如果显示不下，则截断并在结尾显示...
    // NSStringDrawingUsesLineFragmentOrigin: 把每行的高度加起来，不包括行间距
    // NSStringDrawingUsesFontLeading: 以文字的行间距来计算每行高度
    return [self.titleLabel.text boundingRectWithSize:CGSizeMake(size.width, size.height)
                                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : self.titleLabel.font}
                                              context:nil].size;
}

#pragma mark - getter & setter


- (CGSize)hy_imageSize {
    NSValue *imgSizeValue = objc_getAssociatedObject(self, _cmd);
    CGSize imgSize = imgSizeValue.CGSizeValue;
    if (CGSizeEqualToSize(imgSize, CGSizeZero)) {
        imgSize = self.imageView.frame.size;
    }
    return imgSize;
}

- (void)setHy_imageSize:(CGSize)hy_imageSize {
    NSValue *imgSizeValue = [NSValue valueWithCGSize:hy_imageSize];
    objc_setAssociatedObject(self, @selector(hy_imageSize), imgSizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYImagePositionMode)hy_imagePositionMode {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).integerValue;
}

- (void)setHy_imagePositionMode:(HYImagePositionMode)hy_imagePositionMode {
    objc_setAssociatedObject(self, @selector(hy_imagePositionMode), @(hy_imagePositionMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hy_middleDistance {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).floatValue;
}
- (void)setHy_middleDistance:(CGFloat)hy_middleDistance {
    objc_setAssociatedObject(self, @selector(hy_middleDistance), @(hy_middleDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hy_adjustsImageWhenHighlighted {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}

- (void)setHy_adjustsImageWhenHighlighted:(BOOL)hy_adjustsImageWhenHighlighted {
    objc_setAssociatedObject(self, @selector(hy_adjustsImageWhenHighlighted), @(hy_adjustsImageWhenHighlighted), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
