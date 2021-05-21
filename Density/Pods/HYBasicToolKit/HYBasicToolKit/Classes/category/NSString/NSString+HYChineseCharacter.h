//
//  NSString+HYChineseCharacter.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HYChineseCharacter)

/**
 返回当前string 中汉字的个数

 @return 汉字个数
 */
- (NSInteger)hy_chineseCharacterCount;

/**
 返回固定宽度内的substring
 
 @param width wid
 @param font fint
 @return return value description
 */
- (NSString *)hy_subStringMaxWidth:(CGFloat)width font:(UIFont *)font;
/**
 获取最大字符个数

 @param max 最大个数
 @return sub
 */
- (NSString *)hy_subStringOfMaxLength:(NSInteger)max;

/**
 是不是全部是英文字符
 
 @return 是 return yes
 */
- (BOOL)hy_isAllEnglishChar;

@end

NS_ASSUME_NONNULL_END
