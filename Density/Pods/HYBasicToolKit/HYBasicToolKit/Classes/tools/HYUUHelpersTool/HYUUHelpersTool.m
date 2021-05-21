//
//  HYUUHelpersTool.m
//  EasyDarkMode
//
//  Created by 蒋伟东 on 2021/5/13.
//

#import "HYUUHelpersTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "NSString+HYHash.h"

@implementation HYUUHelpersTool

+ (NSString *)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";

    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    
    if ([deviceString isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";

    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"iPad8,1"] || [deviceString isEqualToString:@"iPad8,2"])    return @"iPad Pro (11-inch) WiFi";
    if ([deviceString isEqualToString:@"iPad8,3"] || [deviceString isEqualToString:@"iPad8,4"])    return @"iPad Pro (11-inch) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad8,5"] || [deviceString isEqualToString:@"iPad8,6"])    return @"iPad Pro (12.9-inch) (3rd generation) WiFi";
    if ([deviceString isEqualToString:@"iPad8,7"] || [deviceString isEqualToString:@"iPad8,8"])    return @"iPad Pro (12.9-inch) (3rd generation) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad8,9"])      return @"iPad Pro (12.9-inch) (4th generation) WiFi";
    if ([deviceString isEqualToString:@"iPad8,10"])     return @"iPad Pro (12.9-inch) (4th generation) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad8,11"])     return @"iPad Pro (11-inch) (2nd generation) WiFi";
    if ([deviceString isEqualToString:@"iPad8,12"])     return @"iPad Pro (11-inch) (2nd generation) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad11,1"])     return @"iPad Mini 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad11,2"])     return @"iPad mini (5th generation) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad11,3"])     return @"iPad Air (3rd generation) WiFi";
    if ([deviceString isEqualToString:@"iPad11,4"])     return @"iPad Air (3rd generation) Wi-Fi + Cellular";
    if ([deviceString isEqualToString:@"iPad13,1"])     return @"iPad Air (4th generation) WiFi";
    if ([deviceString isEqualToString:@"iPad13,2"])     return @"iPad Air (4th generation) Wi-Fi + Cellular";

    if ([deviceString isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceString;

}

+ (NSString *)getUUID {
    NSString *uuid = [[NSUUID UUID] UUIDString].hy_md5String;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]) {
        uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:@"uuid"];
    }
    return uuid;
}

@end
