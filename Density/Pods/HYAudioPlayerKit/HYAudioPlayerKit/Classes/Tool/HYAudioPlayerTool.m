//
//  HYAudioPlayerTool.m
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import "HYAudioPlayerTool.h"

@implementation HYAudioPlayerTool

+ (NSURL *)customURL:(NSURL *)URL{
    NSString *URLString = [URL absoluteString];
    if ([URLString rangeOfString:@":"].location != NSNotFound) {
        NSString *scheme = [[URLString componentsSeparatedByString:@":"] firstObject];
        if (scheme) {
            NSString *newScheme = [scheme stringByAppendingString:@"-streaming"];
            URLString = [URLString stringByReplacingOccurrencesOfString:scheme withString:newScheme];
            return [NSURL URLWithString:URLString];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

+ (NSURL *)originalURL:(NSURL *)URL{
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:URL
                                                resolvingAgainstBaseURL:NO];
    components.scheme = [components.scheme stringByReplacingOccurrencesOfString:@"-streaming" withString:@""];
    return [components URL];
}

+ (BOOL)isLocalAudio:(NSURL *)URL{
    return [URL.absoluteString hasPrefix:@"http"] ? NO : YES;
}

+ (BOOL)isNSURL:(NSURL *)URL{
    return [URL isKindOfClass:[NSURL class]];
}

@end

@implementation UIImage (HYAudioPlayerImageExtensions)

- (UIImage *)hy_imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0){
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation NSString (HYAudioPlayerStringExtensions)

- (NSString *)hy_removeEmpty{
    NSString *str = [NSString stringWithFormat:@"%@",self];
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)hy_isEmpty{
    if(!self || [self isEqualToString:@"(null)"] || [self isKindOfClass:[NSNull class]] || [self isEqual:[NSNull null]]){
        return YES;
    }
    return [self hy_removeEmpty].length == 0;
}

- (BOOL)hy_isContainLetter{
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return count > 0;
}

@end
