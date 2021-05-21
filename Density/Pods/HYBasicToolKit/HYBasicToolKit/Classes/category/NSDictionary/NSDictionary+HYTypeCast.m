//
//  NSDictionary+HYTypeCast.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSDictionary+HYTypeCast.h"
#import "NSString+HYSimpleMatching.h"
#import "HYTypeCastUtil.h"

/**
 *  返回根据所给key值在当前字典对象上对应的值.
 */
#define OFK [self objectForKey:key]

@implementation NSDictionary (HYTypeCast)


- (BOOL)hy_hasKey:(NSString *)key
{
    return (OFK != nil);
}

#pragma mark - NSObject

- (id)hy_objectForKey:(NSString *)key
{
    return OFK;
}

- (id)hy_unknownObjectForKey:(NSString*)key
{
    return OFK;
}


- (id)hy_objectForKey:(NSString *)key class:(Class)clazz
{
    id obj = OFK;
    if ([obj isKindOfClass:clazz])
    {
        return obj;
    }
    
    return nil;
}

#pragma mark - NSNumber

- (NSNumber *)hy_numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    return hy_numberOfValue(OFK, defaultValue);
}

- (NSNumber *)hy_numberForKey:(NSString *)key
{
    return [self hy_numberForKey:key defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)hy_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    return hy_stringOfValue(OFK, defaultValue);
}

- (NSString *)hy_stringForKey:(NSString *)key;
{
    return [self hy_stringForKey:key defaultValue:nil];
}


- (NSString *)hy_validStringForKey:(NSString *)key
{
    NSString *stringValue = [self hy_stringForKey:key];
    if (stringValue.length) {
        return stringValue;
    }
    return nil;
}

#pragma mark - NSArray of NSString

- (NSArray *)hy_stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return hy_stringArrayOfValue(OFK, defaultValue);
}

- (NSArray *)hy_stringArrayForKey:(NSString *)key;
{
    return [self hy_stringArrayForKey:key defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)hy_dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    return hy_dictOfValue(OFK, defaultValue);
}

- (NSDictionary *)hy_dictForKey:(NSString *)key
{
    return [self hy_dictForKey:key defaultValue:nil];
}

- (NSDictionary *)hy_validDictForKey:(NSString *)key
{
    NSDictionary *dictionary = [self hy_dictForKey:key];
    if (dictionary.count) {
        return dictionary;
    }
    return nil;
}

- (NSDictionary *)hy_dictionaryWithValuesForKeys:(NSArray *)keys
{
    return [self dictionaryWithValuesForKeys:keys];
}

#pragma mark - NSArray

- (NSArray *)hy_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return hy_arrayOfValue(OFK, defaultValue);
}

- (NSArray *)hy_arrayForKey:(NSString *)key
{
    return [self hy_arrayForKey:key defaultValue:nil];
}

-(NSArray *)hy_validArrayForKey:(NSString *)key
{
    NSArray *array = [self hy_arrayForKey:key];
    if (array.count) {
        return array;
    }
    return nil;
}

#pragma mark - Float

- (float)hy_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
{
    return hy_floatOfValue(OFK, defaultValue);
}

- (float)hy_floatForKey:(NSString *)key;
{
    return [self hy_floatForKey:key defaultValue:0.0f];
}

#pragma mark - Double

- (double)hy_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
{
    return hy_doubleOfValue(OFK, defaultValue);
}

- (double)hy_doubleForKey:(NSString *)key;
{
    return [self hy_doubleForKey:key defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)hy_pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue
{
    return hy_pointOfValue(OFK, defaultValue);
}

- (CGPoint)hy_pointForKey:(NSString *)key;
{
    return [self hy_pointForKey:key defaultValue:CGPointZero];
}

#pragma mark - CGSize

- (CGSize)hy_sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
{
    return hy_sizeOfValue(OFK, defaultValue);
}

- (CGSize)hy_sizeForKey:(NSString *)key;
{
    return [self hy_sizeForKey:key defaultValue:CGSizeZero];
}

#pragma mark - CGRect

- (CGRect)hy_rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
{
    return hy_rectOfValue(OFK, defaultValue);
}

- (CGRect)hy_rectForKey:(NSString *)key;
{
    return [self hy_rectForKey:key defaultValue:CGRectZero];
}

#pragma mark - BOOL

- (BOOL)hy_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
{
    return hy_boolOfValue(OFK, defaultValue);
}

- (BOOL)hy_boolForKey:(NSString *)key;
{
    return [self hy_boolForKey:key defaultValue:NO];
}

#pragma mark - Int

- (int)hy_intForKey:(NSString *)key defaultValue:(int)defaultValue;
{
    return hy_intOfValue(OFK, defaultValue);
}

- (int)hy_intForKey:(NSString *)key;
{
    return [self hy_intForKey:key defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)hy_unsignedIntForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;
{
    return hy_unsignedIntOfValue(OFK, defaultValue);
}

- (unsigned int)hy_unsignedIntForKey:(NSString *)key;
{
    return [self hy_unsignedIntForKey:key defaultValue:0];
}

#pragma mark - Long Long

- (long long int)hy_longLongForKey:(NSString *)key defaultValue:(long long int)defaultValue
{
    return hy_longLongOfValue(OFK, defaultValue);
}

- (long long int)hy_longLongForKey:(NSString *)key;
{
    return [self hy_longLongForKey:key defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)hy_unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
{
    return hy_unsignedLongLongOfValue(OFK, defaultValue);
}

- (unsigned long long int)hy_unsignedLongLongForKey:(NSString *)key;
{
    return [self hy_unsignedLongLongForKey:key defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)hy_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
{
    return hy_integerOfValue(OFK, defaultValue);
}

- (NSInteger)hy_integerForKey:(NSString *)key;
{
    return [self hy_integerForKey:key defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)hy_unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
    return hy_unsignedIntegerOfValue(OFK, defaultValue);
}

- (NSUInteger)hy_unsignedIntegerForKey:(NSString *)key
{
    return [self hy_unsignedIntegerForKey:key defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)hy_imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue
{
    return hy_imageOfValue(OFK, defaultValue);
}

- (UIImage *)hy_imageForKey:(NSString *)key
{
    return [self hy_imageForKey:key defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)hy_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue
{
    return hy_colorOfValue(OFK, defaultValue);
}

- (UIColor *)hy_colorForKey:(NSString *)key
{
    return [self hy_colorForKey:key defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)hy_timeForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    return hy_timeOfValue(OFK, defaultValue);
}

- (time_t)hy_timeForKey:(NSString *)key
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self hy_timeForKey:key defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)hy_dateForKey:(NSString *)key
{
    return hy_dateOfValue(OFK);
}

#pragma mark - NSURL
- (NSURL *)hy_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue
{
    return hy_urlOfValue(OFK, defaultValue);
}

- (NSURL *)hy_urlForKey:(NSString *)key
{
    return [self hy_urlForKey:key defaultValue:nil];
}

#pragma mark - Enumerate

- (void)hy_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)hy_enumerateKeysAndUnknownObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)hy_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)hy_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block classes:(id)object, ...
{
    if (!object) return;
    NSMutableArray* classesArray = [NSMutableArray array];
    id paraObj = object;
    va_list objects;
    va_start(objects, object);
    do
    {
        [classesArray addObject:paraObj];
        paraObj = va_arg(objects, id);
    } while (paraObj);
    va_end(objects);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL allowBlock = NO;
        for (int i = 0; i < classesArray.count; i++)
        {
            if ([obj isKindOfClass:[classesArray objectAtIndex:i]])
            {
                allowBlock = YES;
                break;
            }
        }
        if (allowBlock)
        {
            block(key, obj, stop);
        }
    }];
}

- (void)hy_enumerateKeysAndArrayObjectsUsingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsUsingBlock:block withCastFunction:hy_arrayOfValue];
}

- (void)hy_enumerateKeysAndDictObjectsUsingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsUsingBlock:block withCastFunction:hy_dictOfValue];
}

- (void)hy_enumerateKeysAndStringObjectsUsingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsUsingBlock:block withCastFunction:hy_stringOfValue];
}

- (void)hy_enumerateKeysAndNumberObjectsUsingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsUsingBlock:block withCastFunction:hy_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)hy_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
}

- (void)hy_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)hy_enumerateKeysAndArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:hy_arrayOfValue];
}

- (void)hy_enumerateKeysAndDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:hy_dictOfValue];
}

- (void)hy_enumerateKeysAndStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:hy_stringOfValue];
}

- (void)hy_enumerateKeysAndNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self hy_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:hy_numberOfValue];
}

- (NSString *)hy_toJSONStringWithSortedKeyAsc
{
    __block NSString *jsonString = nil;
    NSError *error = nil;
    NSData *httpData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    jsonString = [[NSString alloc] initWithData:httpData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSMutableDictionary (HYTypeCast)

- (void)hy_addEntriesFromDictionary:(NSDictionary *)dictionary classes:(id)object, ...
{
    if (!dictionary.count || !object) return;
    
    NSMutableArray* classesArray = [NSMutableArray array];
    id paraObj = object;
    va_list objects;
    va_start(objects, object);
    do
    {
        [classesArray addObject:paraObj];
        paraObj = va_arg(objects, id);
    } while (paraObj);
    va_end(objects);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [dictionary hy_enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *dictionaryStop) {
        [classesArray enumerateObjectsUsingBlock:^(id clazz, NSUInteger idx, BOOL *classStop) {
            if ([obj isKindOfClass:clazz]) {
                [self setObject:obj forKey:key];
                *classStop = YES;
            }
        }];
    }];
#pragma clang diagnostic pop
}

@end

