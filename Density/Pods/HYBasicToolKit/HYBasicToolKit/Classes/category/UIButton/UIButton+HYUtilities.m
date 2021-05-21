//
//  UIButton+HYUtilities.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/27.
//

#import "UIButton+HYUtilities.h"

@interface UIButton ()
/** text */
@property (nonatomic , copy) UIButton * (^hy_normalTextIs)(NSString *text);

/** textcolor - normal */
@property (nonatomic , copy) UIButton * (^hy_normalTextColorIs)(UIColor * color);

/** textcolor - selected */
@property (nonatomic , copy) UIButton * (^hy_selectedTextColorIs)(UIColor * color);

/** font*/
@property (nonatomic , copy) UIButton * (^hy_fontIs)(UIFont *font);

/** image */
@property (nonatomic , copy) UIButton * (^hy_normalImgIs)(NSString * img);

/** sele-image */
@property (nonatomic , copy ) UIButton * (^hy_selectImgIs)(NSString * img);

@end

@implementation UIButton (HYUtilities)

- (UIButton * _Nonnull (^)(NSString * _Nonnull))hy_normalTextIs{
    return ^(NSString * text){
        [self setTitle:text forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIColor * _Nonnull))hy_normalTextColorIs
{
    return ^(UIColor * color){
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIColor * _Nonnull))hy_selectedTextColorIs
{
    return ^(UIColor * color){
        [self setTitleColor:color forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIFont * _Nonnull))hy_fontIs
{
    return ^(UIFont * font){
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton * _Nonnull (^)(NSString * _Nonnull))hy_normalImgIs
{
    return ^(NSString * img){
        if (img.length) {
            [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            [self setImage:[UIImage new] forState:UIControlStateNormal];
        }
        return self;
    };
}

- (UIButton * _Nonnull (^)(NSString * _Nonnull))hy_selectImgIs{
    return ^(NSString * img){
        [self setImage:[UIImage imageNamed:img] forState:UIControlStateSelected];
        return self;
    };
}


@end
