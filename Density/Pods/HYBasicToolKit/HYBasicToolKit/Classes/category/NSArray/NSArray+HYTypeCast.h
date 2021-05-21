//
//  NSArray+HYTypeCast.h
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HYTypeCast)

/*!
 *  返回数组index对应的对象
 *
 *  @param index index
 *
 *  @return 数组index对应的对象
 */
- (id)hy_objectAtIndex:(NSUInteger)index  __attribute__((deprecated));

/*!
 *  返回数组index对应的对象
 *
 *  @param index index
 *
 *  @return 数组index对应的对象
 */
- (id)hy_unknownObjectAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSNumber类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSNumber，则返回指定默认值。
 *
 *  @return 数组对应index的NSNumber对象
 */
- (NSNumber *)hy_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)defaultValue;

/*!
 *  返回数组index对应的NSNumber类型对象；如果对应index对象类型不为NSNumber，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSNumber对象
 */
- (NSNumber *)hy_numberAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSString类型对象；如果对应index对象类型不为NSString，则返回指定默认值。
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSString，则返回指定默认值。
 *
 *  @return 数组对应index的NSString对象
 */
- (NSString *)hy_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)defaultValue;

/*!
 *  返回数组index对应的NSString类型对象；如果对应index对象类型不为NSString，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSString对象
 */
- (NSString *)hy_stringAtIndex:(NSUInteger)index;


/**
 返回非空字符，如果字符串为@"",则返回nil

 @param index index
 @return 返回非空字符，如果字符串为@"",则返回nil
 */
- (NSString *)hy_validStringAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSArray并且数组内的对象都为NSString，则返回指定默认值。
 *
 *  @return 数组对应index的NSArray（数组中保存的都是NSString）对象
 */
- (NSArray *)hy_stringArrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue;

/*!
 *  返回数组index对应的对象；如果对应index对象类型不为NSArray并且数组内的对象都为NSString，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSArray（数组中保存的都是NSString）对象
 */
- (NSArray *)hy_stringArrayAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSDictonary类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSDictonary，则返回指定默认值。
 *
 *  @return 数组对应index的NSDictionary对象
 */
- (NSDictionary *)hy_dictAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)defaultValue;

/*!
 *  返回数组index对应的NSDictonary类型对象；如果对应index对象类型不为NSDictonary，则返回指定默认值。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSDictionary对象
 */
- (NSDictionary *)hy_dictAtIndex:(NSUInteger)index;


/**
 返回长度不为0的字典，如果长度为0，则返回nil

 @param index index
 @return 返回长度不为0的字典，如果长度为0，则返回nil
 */
- (NSDictionary *)hy_validDictAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSArray类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSArray，则返回指定默认值。
 *
 *  @return 数组对应index的NSArray对象
 */
- (NSArray *)hy_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue;

/*!
 *  返回数组index对应的NSArray类型对象；如果对应index对象类型不为NSArray，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSArray对象
 */
- (NSArray *)hy_arrayAtIndex:(NSUInteger)index;


/**
 返回长度不为0的数组，如果长度为0，则返回nil

 @param index index
 @return 返回长度不为0的数组，如果长度为0，则返回nil
 */
- (NSArray *)hy_validArrayAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的float值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成float，则返回指定默认值。
 *
 *  @return 数组index对应的对象的float值
 */
- (float)hy_floatAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;

/*!
 *  返回数组index对应的对象的float值；如果对应index对象类型不能转换成float，则返回0.0f
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的float值
 */
- (float)hy_floatAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的double值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成double，则返回指定默认值。
 *
 *  @return 数组index对应的对象的double值
 */
- (double)hy_doubleAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;

/*!
 *  返回数组index对应的对象的double值，如果对应index对象类型不能转换成double，则返回0.0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的double值
 */
- (double)hy_doubleAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGPoint值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGPoint，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGPoint值
 */
- (CGPoint)hy_pointAtIndex:(NSUInteger)index defaultValue:(CGPoint)defaultValue;

/*!
 *  返回数组index对应的对象的CGPoint值；如果对应index对象类型不能转换成CGPoint，则返回CGPointZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGPoint值
 */
- (CGPoint)hy_pointAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGSize值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGSize，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGSize值
 */
- (CGSize)hy_sizeAtIndex:(NSUInteger)index defaultValue:(CGSize)defaultValue;

/*!
 *  返回数组index对应的对象的CGSize值，如果对应index对象类型不能转换成CGSize，则返回CGSizeZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGSize值
 */
- (CGSize)hy_sizeAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGRect值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGRect，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGRect值
 */
- (CGRect)hy_rectAtIndex:(NSUInteger)index defaultValue:(CGRect)defaultValue;

/*!
 *  返回数组index对应的对象的CGRect值，如果对应index对象类型不能转换成CGRect，则返回CGRectZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGRect值
 */
- (CGRect)hy_rectAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的BOOL值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成BOOL，则返回指定默认值。
 *
 *  @return 数组index对应的对象的BOOL值
 */
- (BOOL)hy_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;

/*!
 *  返回数组index对应的对象的BOOL值，如果对应index对象类型不能转换成BOOL，则返回NO。
 *
 *  @param index index
 *
 *  @return 数组index对应的对象的BOOL值
 */
- (BOOL)hy_boolAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的int值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成int，则返回指定默认值。
 *
 *  @return 数组index对应的对象的int值
 */
- (int)hy_intAtIndex:(NSUInteger)index defaultValue:(int)defaultValue;

/*!
 *  返回数组index对应的对象的int值；如果对应index对象类型不能转换成int，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的int值
 */
- (int)hy_intAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned值
 */
- (unsigned int)hy_unsignedIntAtIndex:(NSUInteger)index defaultValue:(unsigned int)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned值；如果对应index对象类型不能转换成unsigned，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned值
 */
- (unsigned int)hy_unsignedIntAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的Integer值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成Integer，则返回指定默认值。
 *
 *  @return 数组index对应的对象的Integer值
 */
- (NSInteger)hy_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;

/*!
 *  返回数组index对应的对象的Integer值；如果对应index对象类型不能转换成Integer，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的Integer值
 */
- (NSInteger)hy_integerAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned Integer值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned Integer，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned Integer值
 */
- (NSUInteger)hy_unsignedIntegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned Integer值；如果对应index对象类型不能转换成unsigned Integer，则返回0
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned Integer值
 */
- (NSUInteger)hy_unsignedIntegerAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的longlong值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成longlong，则返回指定默认值。
 *
 *  @return 数组index对应的对象的longlong值
 */
- (long long int)hy_longLongAtIndex:(NSUInteger)index defaultValue:(long long int)defaultValue;

/*!
 *  返回数组index对应的对象的longlong值；如果对应index对象类型不能转换成longlong，则返回0LL。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的longlong值
 */
- (long long int)hy_longLongAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned longlong值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned longlong，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned longlong值
 */
- (unsigned long long int)hy_unsignedLongLongAtIndex:(NSUInteger)index defaultValue:(unsigned long long int)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned longlong值；如果对应index对象类型不能转换成unsigned longlong，则返回0ULL。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned longlong值
 */
- (unsigned long long int)hy_unsignedLongLongAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的UIImage对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为UIImage类型，则返回指定默认值。
 *
 *  @return 数组index对应的UIImage对象
 */
- (UIImage *)hy_imageAtIndex:(NSUInteger)index defaultValue:(UIImage *)defaultValue;

/*!
 *  返回数组index对应的UIImage对象；如果对应index对象类型不为UIImage类型，则返回nil。
 *
 *  @param index        index
 *
 *  @return 数组index对应的UIImage对象
 */
- (UIImage *)hy_imageAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的UIColor对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为UIColor类型，则返回指定默认值。
 *
 *  @return 数组index对应的UIColor对象
 */
- (UIColor *)hy_colorAtIndex:(NSUInteger)index defaultValue:(UIColor *)defaultValue;

/*!
 *  返回数组index对应的UIColor对象；如果对应index对象类型不为UIColor类型，则返回whiteColor。
 *
 *  @param index        index
 *
 *  @return 数组index对应的UIColor对象
 */
- (UIColor *)hy_colorAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应对象的time_t值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成time_t，则返回指定默认值。
 *
 *  @return 数组index对应对象的time_t值
 */
- (time_t)hy_timeAtIndex:(NSUInteger)index defaultValue:(time_t)defaultValue;

/*!
 *  返回数组index对应对象的time_t值；如果对应index对象类型不能转换成time_t，则返回timeIntervalSince1970。
 *
 *  @param index        index
 *
 *  @return 数组index对应对象的time_t值
 */
- (time_t)hy_timeAtIndex:(NSUInteger)index;

/*!
 *  数组index对应对象转换成NSDate返回；如果不能转换成NSDate类型对象，则返回nil。
 *
 *  @param index        index
 *
 *  @return 数组index对应对象转换成NSDate
 */
- (NSDate *)hy_dateAtIndex:(NSUInteger)index;

/*!
 *  数组index对应对象转换成NSURL返回；如果不能转换成NSURL类型对象，则返回nil。
 *
 *  @param index        index
 *
 *  @return 数组index对应对象转换成NSDate
 */
- (NSURL *)hy_urlForKey:(NSUInteger)index;

/*!
 *  遍历数组中的对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block __attribute__((deprecated));

/*!
 *  遍历数组中的对象，执行block, 尽量使用指定类型的方法， 这个方法只用于特殊情况
 *
 *  @param block 数组对象要执行的block
 */

- (void)hy_enumerateUnknownObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的数组对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateArrayObjectsUsingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的字典对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateDictObjectsUsingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的NSString对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateStringObjectsUsingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的NSNumber对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateNumberObjectsUsingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的对象，执行block
 *
 *  @param block  数组对象要执行的block
 *  @param object 要遍历对象类型
 */
- (void)hy_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block classes:(id)object, ...;

/*!
 *  按照NSEnumerationOptions遍历数组对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block __attribute__((deprecated));

/*!
 *  按照NSEnumerationOptions遍历数组中的数组对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的字典对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的NSString对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的NSString对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)hy_enumerateNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block;

/**
 array转json

 @return json字符串
 */
- (NSString *)hy_toJSONStringWithSortedKeyAsc;

/*!
 *  返回数组中包含的所有字符串对象
 *
 *  @return 过滤的结果
 */
@property (nonatomic, copy, readonly) NSArray * hy_stringObjects;

@end

NS_ASSUME_NONNULL_END
