//
//  NSString+HYSimpleMatching.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSString+HYSimpleMatching.h"

@implementation NSString (HYSimpleMatching)
// Returns YES if the string is nil or equal to @""
+ (BOOL)hy_isEmptyString:(NSString *)string {
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    return string == nil || [string isEqualToString:@""];
}

- (BOOL)hy_containsCharacterInSet:(NSCharacterSet *)searchSet {
    NSRange characterRange = [self rangeOfCharacterFromSet:searchSet];
    return characterRange.length != 0;
}

- (BOOL)hy_containsString:(NSString *)searchString options:(unsigned int)mask {
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString options:mask].length > 0;
}

- (BOOL)hy_containsString:(NSString *)searchString {
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString].length > 0;
}

- (BOOL)hy_hasLeadingWhitespace {
    if ([self length] == 0)
        return NO;
    switch ([self characterAtIndex:0]) {
        case ' ':
        case '\t':
        case '\r':
        case '\n':
            return YES;
        default:
            return NO;
    }
}
@end
