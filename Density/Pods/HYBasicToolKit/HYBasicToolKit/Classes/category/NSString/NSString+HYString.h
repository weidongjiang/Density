//
//  NSString+HYString.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HYString)

- (NSInteger)hy_stringCount;

- (NSString *)hy_interceptionByGBK:(int)length;

- (BOOL)hy_isValidNickname;

- (BOOL)hy_isValiddDesc;

- (BOOL)hy_isPhoneNumber;

- (BOOL)hy_isEmail;

- (BOOL)hy_isPassword;

- (BOOL)hy_isMobileNumber;

- (id)hy_JSONValue;

- (NSString *)hy_getChineseCaptialChar;

- (NSString *)hy_MD5String;

- (NSString *)hy_second2String;

- (NSString *)hy_urlEncode;
- (NSString *)hy_urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)hy_urlDecode;
- (NSString *)hy_urlDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)absoluteString;

- (NSDictionary*)hy_parseQuery;

- (NSString *)hy_firstPYString;

+ (BOOL)hy_stringContainsEmoji:(NSString *)string;

//emoji按照一个character计算
- (NSUInteger)hy_realLength;

//获取指定长度字体的压缩字符串，性能不保证，不建议在高频计算中使用
- (NSString*)hy_limitStringWithFont:(UIFont*)font length:(CGFloat)length;

- (NSInteger)hy_calculateSubStringCount:(NSString*)str;

/**
 返回label可显示的合适字符串
 【解决表情字符只截一段问题】

 @param labelSize label的宽高
 @param font 字体
 @return 新得字符串
 */
- (NSString *)hy_clipFitStringForLabel:(CGSize)labelSize font:(UIFont *)font;

/**
 返回字符串对应字体下单行宽度

 @param font 字体大小
 @return 宽度
 */
- (CGFloat)hy_singleLineWidthWithFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
