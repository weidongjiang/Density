//
//  NSDate+HYUtilities.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSDate+HYUtilities.h"
#import "NSDateFormatter+HYUtilities.h"

@implementation NSDate (HYUtilities)
- (NSDateFormatter *)dateFormatterFromCurrentThread {
    return [NSDateFormatter hy_dateFormateterForCurrentThread];
}

- (NSCalendar *)calendarFromCurrentThread {
    return [NSCalendar hy_calendarForCurrentThread];
}

- (NSString *)hy_formattedStringForMessageBoxDetailList {
    NSCalendar* calendar= [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *dateFormatter = [self dateFormatterFromCurrentThread];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(-24*60*60)]];
    
    NSString *timeStr = nil;
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
    }
    else if([yesterdayComponents year] == [dateComponents year] &&
            [yesterdayComponents month] == [dateComponents month] &&
            [yesterdayComponents day] == [dateComponents day])
    {
        [dateFormatter setDateFormat:@"'昨天 'HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
    }
    else if([nowComponents year] == [dateComponents year])
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
    }
    else
    {
        [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
    }
    
    return timeStr;
}

- (NSString *)hy_formattedStringForStatusDetail {
    NSCalendar *calendar = [self calendarFromCurrentThread];
    NSDateFormatter *dateFormatter = [self dateFormatterFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    
    if (nowComponents.year == dateComponents.year) {
        [dateFormatter setDateFormat:@"M-d HH:mm"];
    }else{
        [dateFormatter setDateFormat:@"yy-M-d HH:mm"];
    }
    return [dateFormatter stringFromDate:self];
}


- (NSString *)hy_briefRelativeFormattedString {
    NSCalendar* calendar= [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    
    NSString *timeStr = nil;
    if ([components day] >= 7) {
        timeStr = [NSString stringWithFormat:@"%d周前", 1];
    }
    else if ([components day] > 1)
    {
        timeStr = [NSString stringWithFormat:@"%ld天s前", (long)[components day]];
    }
    else if ([components day] == 1)
    {
        timeStr = [NSString stringWithFormat:@"%ld天前", (long)[components day]];
    }
    else if ([components hour] > 1)
    {
        timeStr = [NSString stringWithFormat:@"%ld小时s前", (long)[components hour]];
    }
    else if ([components hour] == 1)
    {
        timeStr = [NSString stringWithFormat:@"%ld小时前", (long)[components hour]];
    }
    else if ([components minute] > 1)
    {
        timeStr = [NSString stringWithFormat:@"%ld分钟s前", (long)[components minute]];
    }
    else
    {
        timeStr = @"1分钟前";
    }
    
    return timeStr;
}

- (NSString *)hy_generalRelativeFormattedStringWithTimeDescription:(HYTimeDisplayDescription)description{
    
    NSCalendar *calendar = [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *dateFormatter = [self dateFormatterFromCurrentThread];
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(-24*60*60)]];
    
    NSString *formattedString = nil;
    
    HYTimeDisplayDescription _description = HYTimeDisplayDescription_Other;
    
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])                // 今天
    {
        int diff = [self timeIntervalSinceNow];
        if (diff <= 0 && diff > -60 * 60 * 24)                        // 一天之内.
        {
            int min = -diff / 60;
            if (min == 0)
            {
                min = 1;
            }
            
            if (min <= 10)                                          //10分钟
            {
                formattedString = @"刚刚";
                _description = HYTimeDisplayDescription_JustNow;
            }
            else if (min <= 59)                                     //一小时内
            {
                formattedString = [NSString stringWithFormat:@"%d分钟前", min];
                _description = HYTimeDisplayDescription_InOneHour;
            }
            else
            {
                int hour = min / 60;
                formattedString = [NSString stringWithFormat:@"%d小时前", hour];
                _description = HYTimeDisplayDescription_InOneDay;
            }
        }
        else if (diff > 0)
        {
            formattedString = @"1分钟前";
        }
    }
    else if([yesterdayComponents year] == [dateComponents year] &&
            [yesterdayComponents month] == [dateComponents month] &&
            [yesterdayComponents day] == [dateComponents day])          // 昨天
    {
        [dateFormatter setDateFormat:@"'昨天 'HH:mm"];
        formattedString = [dateFormatter stringFromDate:self];
        _description = HYTimeDisplayDescription_InYesterday;
    }
    else
    {
        NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:mainlandChinaLocale];
        
        if ([nowComponents year] == [dateComponents year])
        {
            [dateFormatter setDateFormat:@"M-d"];
            _description = HYTimeDisplayDescription_InOneYear;
        }
        else
        {
            [dateFormatter setDateFormat:@"yy-M-d"];
            _description = HYTimeDisplayDescription_Other;
        }
        formattedString = [dateFormatter stringFromDate:self];
    }
    
    if (description) {
        description = _description;
    }
    return formattedString;

}

- (NSString *)hy_generalRelativeFormattedString
{
    return [self hy_generalRelativeFormattedStringWithTimeDescription:HYTimeDisplayDescription_JustNow];
}

- (NSString *)hy_detailedrelativeFormattedString
{
    NSCalendar *calendar = [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *dateFormatter = [self dateFormatterFromCurrentThread];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:yesterday];
    
    NSString *formattedString = nil;
    
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])
    {
        [dateFormatter setDateFormat:@"H:mm"];
        formattedString = [dateFormatter stringFromDate:self];
    }
    else if ([yesterdayComponents year] == [dateComponents year] &&
             [yesterdayComponents month] == [dateComponents month] &&
             [yesterdayComponents day] == [dateComponents day])
    {
        formattedString = @"昨天";
    }
    else if ([nowComponents year] == [dateComponents year])
    {
        [dateFormatter setDateFormat:@"M-d"];
        formattedString = [dateFormatter stringFromDate:self];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-M-d"];
        formattedString = [dateFormatter stringFromDate:self];
    }
    
    
    return formattedString;
}

- (NSString *)hy_relativeFormattedString
{
    NSCalendar *calendar = [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *dateFormatter = [self dateFormatterFromCurrentThread];
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(-24*60*60)]];
    
    NSString *formattedString = nil;
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])                // 今天.
    {
        
        int diff = [self timeIntervalSinceNow];
        
        if (diff <= 0 && diff > -60 * 60)                            // 一小时之内.
        {
            int min = -diff / 60;
            
            if (min == 0)
            {
                min = 1;
            }
            
            if (min <= 1)
            {
                formattedString = @"刚刚";
            }
            else
            {
                formattedString = [NSString stringWithFormat:@"%d分钟s前", min];
            }
        }
        else if (diff > 0)
        {
            formattedString = @"1分钟前";
        }
        else
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            formattedString = [dateFormatter stringFromDate:self];
        }
    }
    else if([yesterdayComponents year] == [dateComponents year] &&
            [yesterdayComponents month] == [dateComponents month] &&
            [yesterdayComponents day] == [dateComponents day])          // 昨天
    {
        [dateFormatter setDateFormat:@"'昨天 'HH:mm"];
        formattedString = [dateFormatter stringFromDate:self];
    }
    else
    {
        NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:mainlandChinaLocale];
        
        if ([nowComponents year] == [dateComponents year])
        {
            [dateFormatter setDateFormat:@"M-d' 'HH:mm"];
        }
        else
        {
            [dateFormatter setDateFormat:@"yyyy-M-d' 'HH:mm"];
        }
        
        formattedString = [dateFormatter stringFromDate:self];
    }
    return formattedString;
}

- (NSString *)hy_dateTimeString
{
    NSCalendar *calendar = [self calendarFromCurrentThread];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateFormatter * formatter = [self dateFormatterFromCurrentThread];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    
    NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:mainlandChinaLocale];
    
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])
    {
        // 若为今天，不显示日期，只显示时间
        [formatter setDateFormat:@"HH:mm"];
    }
    else
    {
        [formatter setDateFormat:@"MM-dd' 'HH:mm"];
    }
    NSString * formatedString = [formatter stringFromDate:self];
    
    return formatedString;
}

- (NSString *)hy_stringWithFormatter:(NSString *)formatterString
{
    NSDateFormatter * formatter = [self dateFormatterFromCurrentThread];
    [formatter setDateFormat:formatterString];
    NSString * formatedString = [formatter stringFromDate:self];
    return formatedString;
}


+ (NSString *)hy_convertToTimeHeadFromTimeInterval:(NSTimeInterval)t
{
    NSString* time;
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    double dd = t;
    NSDate* createdAt = [NSDate dateWithTimeIntervalSince1970:dd];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *createdAtComponents = [calendar components:unitFlags fromDate:createdAt];
    if([nowComponents year] == [createdAtComponents year] &&
       [nowComponents month] == [createdAtComponents month] &&
       [nowComponents day] == [createdAtComponents day])
    {//今天
        [dateFormatter setDateFormat:@"'今天 'HH:mm"];
        
        time = [dateFormatter stringFromDate:createdAt];
        
    } else if ([nowComponents year] == [createdAtComponents year]) {
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        //        [dateFormatter setDateFormat:loadMuLanguage(@"MMMMd'日 'HH:mm",@"")];
        [dateFormatter setDateFormat:@"MM-dd' 'HH:mm"];
        time = [dateFormatter stringFromDate:createdAt];
    } else {//去年
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
        time = [dateFormatter stringFromDate:createdAt];
    }
    
    return time;
}

+ (NSString *)hy_convertToDateStringFromTimeInterval:(NSTimeInterval)t
{
    NSString* time;
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    double dd = t;
    NSDate* createdAt = [NSDate dateWithTimeIntervalSince1970:dd];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *createdAtComponents = [calendar components:unitFlags fromDate:createdAt];
    if ([nowComponents year] == [createdAtComponents year]) {
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [dateFormatter setDateFormat:@"MM-dd' 'HH:mm"];
        time = [dateFormatter stringFromDate:createdAt];
    } else {//去年
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
        time = [dateFormatter stringFromDate:createdAt];
    }
    
    return time;
}
@end
