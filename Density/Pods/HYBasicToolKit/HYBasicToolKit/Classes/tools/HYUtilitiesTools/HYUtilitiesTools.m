//
//  HYUtilitiesTools.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import "HYUtilitiesTools.h"
#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>


@implementation HYUtilitiesTools

/**
 判断URL 里面有没有该参数

 @param urlString url
 @param keyString keyString description
 @return return value description
 */
+ (BOOL)getParamsWithUrlString:(NSString *)urlString keyString:(NSString *)keyString {
    
    BOOL isHaveKey = NO;
    if(urlString.length==0) {
        NSLog(@"链接为空！");
        return isHaveKey;
    }
    NSArray *allElements = [urlString componentsSeparatedByString:@"?"];
    if(allElements.count == 2) {

        //有参数或者?后面为空
        NSString *paramsString = allElements[1];
        //获取参数对
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count >= 2) {
            for(NSInteger i = 0; i < paramsArray.count; i++) {
                NSString *singleParamString = paramsArray[i];
                NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count == 2) {
                    NSString *key = singleParamSet[0];
                    NSString *value = singleParamSet[1];
                    if(key.length > 0|| value.length>0) {

                        // 判断
                        if ([key isEqualToString:keyString]) {
                            isHaveKey = YES;
                        }else {
                            isHaveKey = NO;
                        }
                    }
                }
            }
        }else if(paramsArray.count == 1) {

            //无 &。url只有?后一个参数
            NSString *singleParamString = paramsArray[0];
            NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];

            if(singleParamSet.count == 2) {
                NSString *key = singleParamSet[0];
                NSString *value = singleParamSet[1];
                if(key.length > 0 || value.length > 0) {
                    // 判断
                    if ([key isEqualToString:keyString]) {
                        isHaveKey = YES;
                    }else {
                        isHaveKey = NO;
                    }
                }
            }else{
                //问号后面啥也没有 xxxx?  无需处理
                // 判断
                isHaveKey = NO;
            }
        }
    }else if(allElements.count > 2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        isHaveKey = NO;
    }else {
        NSLog(@"链接不包含参数！");
        isHaveKey = NO;
    }

    return isHaveKey;
}


#pragma mark - userdefault
+ (id)getUserDefault:(NSString *)key {
    if (key == nil ) {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults valueForKey:key];
    return value;
}

+ (void)saveUserDefault:(NSString *)key value:(id)value {
    if (key == nil || value == nil) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

#pragma mark - image
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)aRect {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(aRect);
    
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(aRect.origin.x*scale, aRect.origin.y*scale, aRect.size.width*scale, aRect.size.height*scale);
    CGImageRef cgImg = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage* aImg = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    
    return aImg;
}

/*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
+ (UIImage *)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool {
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool) {
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    }else {
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    //kk bug1 内存泄漏
    CGImageRelease(subImageRef);
    return smallImage;
}

#pragma mark - string
+ (NSString *)getVideoLengthStringFromSeconds:(Float64)iVideoSeconds {
    int iSecond = 0;
    int iMinute = 0;
    int iHour = 0;
    NSString *strRet = nil;
    
    //计算小时
    iHour = (UInt32)(iVideoSeconds/3600);
    iHour = MIN(iHour, 59);
    
    //计算分钟
    iMinute = (UInt32)(iVideoSeconds/60);
    if(iMinute>60) iMinute = iMinute % 60;
    iMinute = MIN(iMinute, 59);
    
    //计算秒数
    iSecond = ((UInt32)iVideoSeconds) % 60;
    iSecond = MIN(iSecond, 59);
    
    //显示时间格式
    strRet = [NSString stringWithFormat:@"%02i:%02i:%02i",iHour,iMinute,iSecond];
    return strRet;
}

#pragma mark - size and font 定宽度或者高度，根据文本来计算对应另一边的值
+ (NSInteger)numberOfLinesWithFont:(UIFont *)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    NSInteger lines = rect.size.height / [font lineHeight];
    return lines;
}

+ (NSInteger)heightWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return ceil(rect.size.height);
}

+ (NSInteger)heightWithFontAndLineBreak:(UIFont*)font withLineWidth:(NSInteger)lineWidth string:(NSString *)str {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return ceil(rect.size.height);
}

+ (NSInteger)widthWithFont:(UIFont*)font withLineHeight:(NSInteger)lineHeight string:(NSString *)str {
    NSInteger width = 0;
    @try {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        width = ceil(rect.size.width);
    }
    @catch (NSException *exception) {
        return width;
    }
    @finally {
        return width;
    }
}

+ (CGSize)sizeWithFont:(UIFont*)font string:(NSString *)str {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    CGSize size = [str sizeWithAttributes:attributes];
    return size;
}

+ (CGSize)sizeWithFontAndLineSpace:(UIFont*)font string:(NSString *)str {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSParagraphStyleAttributeName]=paragraphStyle;
    CGSize size = [str sizeWithAttributes:attributes];
    return size;
}

#pragma mark - ip
+ (NSString *)getDeviceIPAdress {
    return [[self class] deviceIPAdress];
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"unknown";
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * temp_addr;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        temp_addr = addrs;
        while (temp_addr != NULL) {
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"])
            {
                //如果是IPV4地址，直接转化
                if (temp_addr->ifa_addr->sa_family == AF_INET){
                    // Get NSString from C String
                    address = [[self class] formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
                }
                
                //如果是IPV6地址
                else if (temp_addr->ifa_addr->sa_family == AF_INET6){
                    address = [[self class] formatIPV6Address:((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr];
                    if (address && ![address isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"]) break;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return address;
}

//for IPV6
+ (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr{
    NSString *address = nil;
    
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

//for IPV4
+ (NSString *)formatIPV4Address:(struct in_addr)ipv4Addr{
    NSString *address = nil;
    
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    if(inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    return address;
}

+ (CGFloat)statusBarHeight {
    CGFloat _statusBarHeight =  0;
    if (@available(iOS 13.0, *)) {
        _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    return _statusBarHeight;
}
@end
