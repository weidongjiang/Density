//
//  UtilsMacro.h
//  uu2me
//
//  Created by znxh on 15/9/29.
//  Copyright © 2015年 Znxh. All rights reserved.
//


#import "HYUtilsDeviceMacro.h"

#ifndef HYUtilsMacro_h
#define HYUtilsMacro_h

#pragma mark - 发送消息
#define AISend(instance, protocol, message) [(id<protocol>)(instance) message]

#pragma mark - weakSelf
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


#pragma mark - dispatch_hy_main_sync_safe
#define dispatch_hy_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#pragma mark - HYDebugLog
#ifdef DEBUG
#define HYDebugLog(FORMAT, ...) do { fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]); fprintf(stderr, "-------\n"); }while(0)
#define NSLog(...) NSLog(__VA_ARGS__);

#else

#define HYDebugLog(FORMAT, ...)
#endif


#pragma mark - 打印结构体 Rect Size Point
#define kHYNSLogRect(rect)             NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define kHYNSLogSize(size)             NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define kHYNSLogPoint(point)           NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)


#pragma mark - 国际化文本显示
#define kHYLocalStr(str)               NSLocalizedString(str, nil)


#define kHYREGEX_INPUT_SPECIAL_CHAR    @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\\u2026\\ufffc\r\n]"

// suppress warnning
#define CCSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#endif
