//
//  UIButton+HYImagePosition.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HYImagePosition)

typedef NS_ENUM(NSInteger, HYImagePositionMode) {
    HYImagePositionModeDefault,           // Image is on left, system default style.
    HYImagePositionModeRight,             // Image is on right.
    HYImagePositionModeTop,               // Image is on top.
    HYImagePositionModeBottom             // Image is on bottom.
};

/// 图片相对于文字的位置
@property (nonatomic, assign) HYImagePositionMode hy_imagePositionMode;

/// 图片与文字间的间距
@property (nonatomic, assign) CGFloat hy_middleDistance;

/// 指定按钮图片尺寸
@property (nonatomic, assign) CGSize hy_imageSize;

/// 点击时图片是否高亮，默认NO
@property (nonatomic, assign) BOOL hy_adjustsImageWhenHighlighted;

@end

NS_ASSUME_NONNULL_END
