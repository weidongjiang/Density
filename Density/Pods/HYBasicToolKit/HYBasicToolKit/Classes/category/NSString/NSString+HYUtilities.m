//
//  NSString+HYUtilities.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSString+HYUtilities.h"
static inline BOOL hy_isEmpty(id thing) {
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}
@implementation NSString (HYUtilities)
- (BOOL)hy_isWhitespace {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hy_isEmptyOrWhitespace {
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL)hy_isEmptyWhitespaceOrNewLines {
    return !self.length || ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (NSString *)hy_stringWithMaxLength:(NSUInteger)maxLen {
    NSUInteger length = [self length];
    if (length <= maxLen || length <= 3) {
        return self;
    }
    return [NSString stringWithFormat:@"%@...", [self substringToIndex:maxLen - 3]];
}

- (NSString *)hy_stringByReplacingRange:(NSRange)aRange with:(NSString *)aString {
    NSUInteger bufferSize;
    NSUInteger selfLen = [self length];
    NSUInteger aStringLen = [aString length];
    unichar *buffer;
    NSRange localRange;
    NSString *result;
    
    bufferSize = selfLen + aStringLen - aRange.length;
    buffer = NSAllocateMemoryPages(bufferSize*sizeof(unichar));
    
    /* Get first part into buffer */
    localRange.location = 0;
    localRange.length = aRange.location;
    [self getCharacters:buffer range:localRange];
    
    /* Get middle part into buffer */
    localRange.location = 0;
    localRange.length = aStringLen;
    [aString getCharacters:(buffer+aRange.location) range:localRange];
    
    /* Get last part into buffer */
    localRange.location = aRange.location + aRange.length;
    localRange.length = selfLen - localRange.location;
    [self getCharacters:(buffer+aRange.location+aStringLen) range:localRange];
    
    /* Build output string */
    result = [NSString stringWithCharacters:buffer length:bufferSize];
    
    NSDeallocateMemoryPages(buffer, bufferSize);
    
    return result;
}

- (NSString *)hy_trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)hy_firstNonNsNullStringWithString:(NSString*)string, ... {
    NSString* result = nil;
    
    id arg = nil;
    va_list argList;
    
    if (string && [string isKindOfClass:[NSString class]])
    {
        return string;
    }
    
    va_start(argList, string);
    while ((arg = va_arg(argList, id)))
    {
        if (arg && [arg isKindOfClass:[NSString class]])
        {
            result = arg;
            break;
        }
    }
    va_end(argList);
    return result;
}


- (NSString *)hy_stringByReplacingPercentEscapesOnce {
    NSString *unescaped = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //self may be a string that looks like an invalidly escaped string,
    //eg @"100%", in that case it clearly wasn't escaped,
    //so we return it as our unescaped string.
    return unescaped ? unescaped : self;
}
- (NSString *)hy_stringByAddingPercentEscapesOnce {
    return [[self hy_stringByReplacingPercentEscapesOnce] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)hy_stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *UUIDstring = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return UUIDstring;
}


- (BOOL)hy_hasSubstring:(NSString*)substring {
    if(hy_isEmpty(substring))
        return NO;
    NSRange substringRange = [self rangeOfString:substring];
    return substringRange.location != NSNotFound && substringRange.length > 0;
}

- (NSString *)hy_substringAfterSubstring:(NSString*)substring {
    if([self hy_hasSubstring:substring])
        return [self substringFromIndex:NSMaxRange([self rangeOfString:substring])];
    return nil;
}

- (BOOL)hy_isEqualToStringIgnoringCase:(NSString*)otherString {
    if(!otherString)
        return NO;
    return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch + NSWidthInsensitiveSearch];
}
@end
