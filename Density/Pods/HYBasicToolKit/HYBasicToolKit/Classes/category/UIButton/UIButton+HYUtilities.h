//
//  UIButton+HYUtilities.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HYUtilities)
/** text - normal */
@property (nonatomic , copy , readonly) UIButton * (^hy_normalTextIs)(NSString *text);

/** textcolor - normal */
@property (nonatomic , copy , readonly) UIButton * (^hy_normalTextColorIs)(UIColor * color);

/** textcolor - selected */
@property (nonatomic , copy , readonly) UIButton * (^hy_selectedTextColorIs)(UIColor * color);

/** font*/
@property (nonatomic , copy , readonly) UIButton * (^hy_fontIs)(UIFont *font);

/** nor-image */
@property (nonatomic , copy , readonly) UIButton * (^hy_normalImgIs)(NSString * img);

/** sele-image */
@property (nonatomic , copy , readonly) UIButton * (^hy_selectImgIs)(NSString * img);

@end

NS_ASSUME_NONNULL_END
