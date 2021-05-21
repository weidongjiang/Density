//
//  NSString+HYUtilities.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HYUtilities)

/**
 * Determines if the string contains only whitespace.
 */
- (BOOL)hy_isWhitespace;

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)hy_isEmptyOrWhitespace;
- (BOOL)hy_isEmptyWhitespaceOrNewLines;
/*!
 *  生成并返回指定最大长度后的字符串；如果要转换的字符串的长度超过指定长度，生成字符串后三位以“...”显示
 *  如， “abcdef” maxLen = 4 -> "a..."
 *
 *  @param maxLen 最大长度
 *
 *  @return 复合最大长度的字符串
 */
- (NSString *)hy_stringWithMaxLength:(NSUInteger)maxLen;

/*!
 *  生成并返回将当前字符串指定范围替换后的字符串
 *
 *  @param aRange  替换范围
 *  @param aString 替换字符串
 *
 *  @return 替换后的字符串
 */
- (NSString *)hy_stringByReplacingRange:(NSRange)aRange with:(NSString *)aString;

/*!
 *  生成并返回去掉当前字符串中的空格和换行符后的字符串
 *
 *  @return 转换后的字符串
 */
- (NSString *)hy_trimmedString;

/*!
 *  返回第一个字符串对象
 *
 *  @param string 输入字符串
 *
 *  @return 第一个字符串对象
 */
+ (NSString *)hy_firstNonNsNullStringWithString:(NSString*)string, ...;



//------------------------------------------ 我是分割线 -------------------------------------------------
/*!
 *  返回一个将当前字符串中的转义字符decode的字符串
 *
 *  @return decode后的字符串
 */
- (NSString *)hy_stringByAddingPercentEscapesOnce;

/*!
 *  返回一个将当前字符串encode的字符串
 *
 *  @return encode后的字符串
 */
- (NSString *)hy_stringByReplacingPercentEscapesOnce;

//------------------------------------------ 我是分割线 -------------------------------------------------
/*!
 *  生成并返回一个UUID字符串
 *
 *  @return UUID字符串
 */
+ (NSString *)hy_stringWithUUID;

//------------------------------------------ 我是分割线 -------------------------------------------------
/*!
 *  判断当前字符串是否包含对应子串
 *
 *  @param substring 要判断的子串
 *
 *  @return YES，包含；NO，不包含
 */
- (BOOL)hy_hasSubstring:(NSString *)substring;

/*!
 *  生成一个指定子字符串出现后的字符串，
 *  如"donganyuan" substring "an" 返回 "yuan"
 *
 *  @param substring 要判断的子串
 *
 *  @return 返回的子字符串
 */
- (NSString *)hy_substringAfterSubstring:(NSString *)substring;

/*!
 *  不考虑大小写，判断两个字符串是否相同
 *
 *  @param otherString 要比较的字符串
 *
 *  @return YES，相同；NO，不相同；
 */
- (BOOL)hy_isEqualToStringIgnoringCase:(NSString *)otherString;

//------------------------------------------ 我是分割线 -------------------------------------------------

@end

NS_ASSUME_NONNULL_END
