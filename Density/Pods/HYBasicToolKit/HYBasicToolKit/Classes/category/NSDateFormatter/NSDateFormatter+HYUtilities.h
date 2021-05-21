//
//  NSDateFormatter+HYUtilities.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// NSDateFormatter 与 NSCalendar 的初始化非常慢（“比文字绘制还慢” by instruments），
// 但它们又不是线程安全的：
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html#//apple_ref/do _Nullable c/uid/10000057i-CH12-122647-BBCCEGFF
// 以下两个方法按当前线程提供缓存过的 formatter 与 calendar

@interface NSDateFormatter (HYUtilities)

/// 多线程使用NSDateFormatter时 为了避免内存的增加以及创建 NSDateFormatter的耗时操作
+ (instancetype _Nullable )hy_dateFormateterForCurrentThread;
@end

NS_ASSUME_NONNULL_END


@interface NSCalendar (HYUtilities)
+ (instancetype _Nullable )hy_calendarForCurrentThread;
@end
