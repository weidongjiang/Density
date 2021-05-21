//
//  HYUtilitiesTools.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYUtilitiesTools : NSObject

/**
 判断URL 里面有没有该参数

 @param urlString url
 @param keyString keyString description
 @return return value description
 */
+ (BOOL)getParamsWithUrlString:(NSString *)urlString keyString:(NSString *)keyString;

#pragma mark - userdefault
+ (id)getUserDefault:(NSString *)key;
+ (void)saveUserDefault:(NSString *)key value:(id)value;

#pragma mark - image
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)aRect;

/*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
+ (UIImage *)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;

#pragma mark - string
+ (NSString *)getVideoLengthStringFromSeconds:(Float64)iVideoSeconds;

#pragma mark - size and font 定宽度或者高度，根据文本来计算对应另一边的值
+ (NSInteger)numberOfLinesWithFont:(UIFont *)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str;
+ (NSInteger)heightWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str;
+ (NSInteger)heightWithFontAndLineBreak:(UIFont*)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str;
+ (NSInteger)widthWithFont:(UIFont*)font withLineHeight:(NSInteger)lineHeight string:(NSString *)str;
+ (CGSize)sizeWithFont:(UIFont*)font string:(NSString *)str;
+ (CGSize)sizeWithFontAndLineSpace:(UIFont*)font string:(NSString *)str;
#pragma mark - ip
+ (NSString *)getDeviceIPAdress;

+ (CGFloat)statusBarHeight;

@end

NS_ASSUME_NONNULL_END
