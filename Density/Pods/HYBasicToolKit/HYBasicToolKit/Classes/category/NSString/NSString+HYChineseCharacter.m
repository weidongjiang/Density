//
//  NSString+HYChineseCharacter.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSString+HYChineseCharacter.h"

@implementation NSString (HYChineseCharacter)
- (NSInteger)hy_chineseCharacterCount{
    NSInteger count = 0;
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *charW = [self substringWithRange:range];
        const char *cChar = [charW UTF8String];
        if (cChar) {
            if (strlen(cChar) == 3) {
                count++;
            }
        }
    }
    return count;
}

- (NSString *)hy_subStringMaxWidth:(CGFloat)width font:(UIFont *)font{
    for (NSInteger i = self.length; i > 1; i--) {
        NSString *subS = [self substringWithRange:NSMakeRange(0, i)];
        if ([subS sizeWithAttributes:@{NSFontAttributeName:font}].width < width) {
            if (i == self.length) {
                return subS; // 本身满足需求直接返回
            }else{// 否则拼接... 继续剪切
                subS = [subS stringByAppendingString:@"..."];
                if ([subS sizeWithAttributes:@{NSFontAttributeName:font}].width < width) {
                    return subS;
                }
            }
        }
    }
    return @"";
}

- (BOOL)hy_isAllEnglishChar{
    for (int i = 0; i < self.length ; i++) {
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        const char *uf = [s UTF8String];
        if (uf) {
            if (strlen(uf) != 1) {
                return NO;
            }
            
            char c = [self characterAtIndex:i];
            if (c < 65 && c > 90) {
                return NO;
            }
        }else{
            return NO;
        }
    }
    return YES;
}

- (NSString *)hy_subStringOfMaxLength:(NSInteger)max{
    NSInteger last = 0;
    for (int i = 0; i < self.length ; i++) {
        if ([[self substringToIndex:i] hy_lengthLongThen:max]) {
            break;
        }
        last = i;
    }
    return [self substringToIndex:(last)];
}

- (BOOL)hy_lengthLongThen:(NSInteger)leng{
    float cnCharCount = [self hy_chineseCharacterCount];
    float enCharCount = self.length - cnCharCount;
    
    if ((cnCharCount + enCharCount/2) > leng) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
@end
