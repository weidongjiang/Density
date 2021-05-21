//
//  NSDate+HYUtilities.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

/*!
 *  将NSDate转换成相应文字描述字符串的工具方法。
 */

typedef enum{
    HYTimeDisplayDescription_JustNow,
    HYTimeDisplayDescription_InOneDay,
    HYTimeDisplayDescription_InYesterday,
    HYTimeDisplayDescription_InOneHour,
    HYTimeDisplayDescription_InOneYear,
    HYTimeDisplayDescription_Other,
}HYTimeDisplayDescription;


NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HYUtilities)
/*!
 *  根据指定的NSTimeInterval，生成并返回转换成时间格式的NSString对象
 *  如：今天： 今天 HH:mm
 *     今年： MM-dd HH:mm
 *     去年： yyyy-MM-dd HH:mm
 *
 *  @param t 需要转换的NSTimeInterval
 *
 *  @return 转换后的NSString
 */
+ (NSString *)hy_convertToTimeHeadFromTimeInterval:(NSTimeInterval)t;

/*!
*  根据指定的NSTimeInterval，生成并返回转换成时间格式的NSString对象
*  如  今年： MM-dd HH:mm
*        去年： yyyy-MM-dd HH:mm
*
*  @param t 需要转换的NSTimeInterval
*
*  @return 转换后的NSString
*/
+ (NSString *)hy_convertToDateStringFromTimeInterval:(NSTimeInterval)t;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“2分钟前”
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_relativeFormattedString;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“刚刚”
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_generalRelativeFormattedString;
- (NSString *)hy_generalRelativeFormattedStringWithTimeDescription:(HYTimeDisplayDescription)description;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“3周前”
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_briefRelativeFormattedString;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“12：35”或 如果转换日期不是今日，显示“4月20日 12：35”
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_dateTimeString;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“2014-04-21 12:40“
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_formattedStringForMessageBoxDetailList;

/*!
 *  根据当前的NSDate，生成并返回一个相对时间描述的NSString对象
 *  如“昨天“
 *
 *  @return 转换后的NSString
 */
- (NSString *)hy_detailedrelativeFormattedString;

/*!
 *  根据指定的时间格式字符串，生成并返回一个当前日期的NSString对象
 *
 *  @param formatterString 格式化String
 *
 *  @return 格式化NSDate后的string
 */
- (NSString *)hy_stringWithFormatter:(NSString *)formatterString;

/*!
 *  将本身转换成一个绝对的格式返回“2014-04-21 12:40“
 */
- (NSString *)hy_formattedStringForStatusDetail;

@end

NS_ASSUME_NONNULL_END
