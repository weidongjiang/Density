//
//  NSDateFormatter+HYUtilities.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "NSDateFormatter+HYUtilities.h"

static NSString * const kThreadDateFormatterKey = @"com.hy.thread-dateformatter";
static NSString * const kThreadNSCalendarKey = @"com.hy.thread-calendar";


@implementation NSDateFormatter (HYUtilities)
+ (instancetype)hy_dateFormateterForCurrentThread {
    NSMutableDictionary *currentThreadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormater = [currentThreadDictionary objectForKey:kThreadDateFormatterKey];
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        [currentThreadDictionary setObject:dateFormater forKey:kThreadDateFormatterKey];
    }
    return dateFormater;
}
@end


@implementation NSCalendar (HYUtilities)
+ (instancetype)hy_calendarForCurrentThread {
    NSMutableDictionary * currentThreadDictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *calendar = [currentThreadDictionary objectForKey:kThreadNSCalendarKey];
    if (!calendar){
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [currentThreadDictionary setObject:calendar forKey:kThreadNSCalendarKey];
    }
    return calendar;
}

@end
