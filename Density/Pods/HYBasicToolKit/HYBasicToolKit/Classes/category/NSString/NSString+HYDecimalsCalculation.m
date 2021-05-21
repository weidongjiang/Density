//
//  NSString+HYDecimalsCalculation.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSString+HYDecimalsCalculation.h"
// HYCalculationType
typedef NS_ENUM(NSInteger,HYCalculationType){
    HYCalculationAdding,
    HYCalculationSubtracting,
    HYCalculationMultiplying,
    HYCalculationDividing,
};

@implementation NSString (HYDecimalsCalculation)
// Compare
- (NSComparisonResult)hy_numberStringCompare:(NSString *)numberString {
    NSDecimalNumber *selfNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *calcuationNumber = [NSDecimalNumber decimalNumberWithString:numberString];
    return [selfNumber compare:calcuationNumber];
}
// Adding
- (NSString *)hy_stringByAdding:(NSString *)stringNumber {
    return [self hy_stringByAdding:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)hy_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self hy_stringByAdding:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)hy_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:HYCalculationAdding by:stringNumber roundingMode:roundingModel scale:scale];
}

// Substracting
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber {
    return [self  hy_stringBySubtracting:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self  hy_stringBySubtracting:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)hy_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:HYCalculationSubtracting by:stringNumber roundingMode:roundingModel scale:scale];
}

// Multiplying
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber {
    return [self hy_stringByMultiplyingBy:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self hy_stringByMultiplyingBy:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)hy_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:HYCalculationMultiplying by:stringNumber roundingMode:roundingModel scale:scale];
}

// Dividing
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber {
    return [self hy_stringByDividingBy:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self hy_stringByDividingBy:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)hy_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:HYCalculationDividing by:stringNumber roundingMode:roundingModel scale:scale];
}


- (NSString *)_stringByCalculationType:(HYCalculationType)type by:(NSString *)stringNumber roundingMode:(NSRoundingMode)roundingModel scale:(NSUInteger)scale{
    
    NSDecimalNumber *selfNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *calcuationNumber = [NSDecimalNumber decimalNumberWithString:stringNumber];
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:roundingModel scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *result = nil;
    switch (type) {
        case HYCalculationAdding:
            result = [selfNumber decimalNumberByAdding:calcuationNumber withBehavior:handler];
            break;
        case HYCalculationSubtracting:
            result =  [selfNumber decimalNumberBySubtracting:calcuationNumber withBehavior:handler];
            break;
        case HYCalculationMultiplying:
            result = [selfNumber decimalNumberByMultiplyingBy:calcuationNumber withBehavior:handler];
            break;
        case HYCalculationDividing:
            result =[selfNumber decimalNumberByDividingBy:calcuationNumber withBehavior:handler];
            break;
    }
    
    //  使用自定义formatter
    NSNumberFormatter *numberFormatter = [self _numberFormatterWithScale:scale];
    return [numberFormatter stringFromNumber:result];
}

- (NSNumberFormatter *)_numberFormatterWithScale:(NSInteger)scale{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.numberStyle = kCFNumberFormatterNoStyle;
    });
    numberFormatter.alwaysShowsDecimalSeparator = !(scale == 0);
    numberFormatter.minimumFractionDigits = scale;
    return numberFormatter;
}

- (NSString *)hy_stringByremoveTrialZero{
    CGFloat num = [self doubleValue];
    NSNumber *number = [NSNumber numberWithDouble:num];
    NSString *resultStr = [number stringValue];
    return resultStr;
}


@end
