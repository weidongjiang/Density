//
//  NSString+HYDecimalsCalculation.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HYDecimalsCalculation)
// 数字字符比较
/*
 @return NSComparisonResult
 NSOrderedAscending = -1L, NSOrderedSame,           NSOrderedDescending
 当前数小于numberString      当前数等于numberString      当前数大于numberString
 */
- (NSComparisonResult)hy_numberStringCompare:(NSString *)numberString;
// 加
/**
 加法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果,
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 被加数
 @return 返回结果
 */
- (NSString *)hy_stringByAdding:(NSString *)stringNumber;
- (NSString *)hy_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)hy_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 减
/**
 减法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber;
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 乘
/**
 乘法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber;
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 除
/**
 除法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber;
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;


//补充, 去掉小数点后面的零
- (NSString *)hy_stringByremoveTrialZero;
@end

NS_ASSUME_NONNULL_END
