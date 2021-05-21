//
//  NSArray+HYTypeCast.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSArray+HYTypeCast.h"
#import "HYTypeCastUtil.h"

#define OAI [self hy_safeObjectAtIndex:index]

@implementation NSArray (HYTypeCast)
- (id)hy_safeObjectAtIndex:(NSUInteger)index
{
   return (index >= self.count) ? nil : [self objectAtIndex:index];
}

#pragma mark - NSObject

- (id)hy_objectAtIndex:(NSUInteger)index
{
   return OAI;
}

- (id)hy_unknownObjectAtIndex:(NSUInteger)index
{
   return OAI;
}

#pragma mark - NSNumber

- (NSNumber *)hy_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)defaultValue
{
   return hy_numberOfValue(OAI, defaultValue);
}

- (NSNumber *)hy_numberAtIndex:(NSUInteger)index
{
   return [self hy_numberAtIndex:index defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)hy_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)defaultValue;
{
   return hy_stringOfValue(OAI, defaultValue);
}

- (NSString *)hy_stringAtIndex:(NSUInteger)index;
{
   return [self hy_stringAtIndex:index defaultValue:nil];
}

- (NSString *)hy_validStringAtIndex:(NSUInteger)index
{
   NSString *string = [self hy_stringAtIndex:index];
   if (string.length) {
       return string;
   }
   return nil;
}

#pragma mark - NSArray of NSString

- (NSArray *)hy_stringArrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
   return hy_stringArrayOfValue(OAI, defaultValue);
}

- (NSArray *)hy_stringArrayAtIndex:(NSUInteger)index;
{
   return [self hy_stringArrayAtIndex:index defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)hy_dictAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)defaultValue
{
   return hy_dictOfValue(OAI, defaultValue);
}

- (NSDictionary *)hy_dictAtIndex:(NSUInteger)index
{
   return [self hy_dictAtIndex:index defaultValue:nil];
}

-(NSDictionary *)hy_validDictAtIndex:(NSUInteger)index
{
   NSDictionary *dictionary = [self hy_dictAtIndex:index];
   if (dictionary.count) {
       return dictionary;
   }
   return nil;
}

#pragma mark - NSArray

- (NSArray *)hy_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
   return hy_arrayOfValue(OAI, defaultValue);
}

- (NSArray *)hy_arrayAtIndex:(NSUInteger)index
{
   return [self hy_arrayAtIndex:index defaultValue:nil];
}

- (NSArray *)hy_validArrayAtIndex:(NSUInteger)index
{
   NSArray *array = [self hy_arrayAtIndex:index];
   if (array.count) {
       return array;
   }
   return nil;
}

#pragma mark - Float

- (float)hy_floatAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;
{
   return hy_floatOfValue(OAI, defaultValue);
}

- (float)hy_floatAtIndex:(NSUInteger)index;
{
   return [self hy_floatAtIndex:index defaultValue:0.0f];
}

#pragma mark - Double

- (double)hy_doubleAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;
{
   return hy_doubleOfValue(OAI, defaultValue);
}

- (double)hy_doubleAtIndex:(NSUInteger)index;
{
   return [self hy_doubleAtIndex:index defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)hy_pointAtIndex:(NSUInteger)index defaultValue:(CGPoint)defaultValue
{
   return hy_pointOfValue(OAI, defaultValue);
}

- (CGPoint)hy_pointAtIndex:(NSUInteger)index;
{
   return [self hy_pointAtIndex:index defaultValue:CGPointZero];
}

#pragma mark - CGSize

- (CGSize)hy_sizeAtIndex:(NSUInteger)index defaultValue:(CGSize)defaultValue;
{
   return hy_sizeOfValue(OAI, defaultValue);
}

- (CGSize)hy_sizeAtIndex:(NSUInteger)index;
{
   return [self hy_sizeAtIndex:index defaultValue:CGSizeZero];
}

#pragma mark - CGRect

- (CGRect)hy_rectAtIndex:(NSUInteger)index defaultValue:(CGRect)defaultValue;
{
   return hy_rectOfValue(OAI, defaultValue);
}

- (CGRect)hy_rectAtIndex:(NSUInteger)index;
{
   return [self hy_rectAtIndex:index defaultValue:CGRectZero];
}

#pragma mark - BOOL

- (BOOL)hy_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;
{
   return hy_boolOfValue(OAI, defaultValue);
}

- (BOOL)hy_boolAtIndex:(NSUInteger)index;
{
   return [self hy_boolAtIndex:index defaultValue:NO];
}

#pragma mark - Int

- (int)hy_intAtIndex:(NSUInteger)index defaultValue:(int)defaultValue;
{
   return hy_intOfValue(OAI, defaultValue);
}

- (int)hy_intAtIndex:(NSUInteger)index;
{
   return [self hy_intAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)hy_unsignedIntAtIndex:(NSUInteger)index defaultValue:(unsigned int)defaultValue;
{
   return hy_unsignedIntOfValue(OAI, defaultValue);
}

- (unsigned int)hy_unsignedIntAtIndex:(NSUInteger)index;
{
   return [self hy_unsignedIntAtIndex:index defaultValue:0];
}

#pragma mark - Long Long

- (long long int)hy_longLongAtIndex:(NSUInteger)index defaultValue:(long long int)defaultValue
{
   return hy_longLongOfValue(OAI, defaultValue);
}

- (long long int)hy_longLongAtIndex:(NSUInteger)index
{
   return [self hy_longLongAtIndex:index defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)hy_unsignedLongLongAtIndex:(NSUInteger)index defaultValue:(unsigned long long int)defaultValue;
{
   return hy_unsignedLongLongOfValue(OAI, defaultValue);
}

- (unsigned long long int)hy_unsignedLongLongAtIndex:(NSUInteger)index;
{
   return [self hy_unsignedLongLongAtIndex:index defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)hy_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;
{
   return hy_integerOfValue(OAI, defaultValue);
}

- (NSInteger)hy_integerAtIndex:(NSUInteger)index;
{
   return [self hy_integerAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)hy_unsignedIntegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue
{
   return hy_unsignedIntegerOfValue(OAI, defaultValue);
}

- (NSUInteger)hy_unsignedIntegerAtIndex:(NSUInteger)index
{
   return [self hy_unsignedIntegerAtIndex:index defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)hy_imageAtIndex:(NSUInteger)index defaultValue:(UIImage *)defaultValue
{
   return hy_imageOfValue(OAI, defaultValue);
}

- (UIImage *)hy_imageAtIndex:(NSUInteger)index
{
   return [self hy_imageAtIndex:index defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)hy_colorAtIndex:(NSUInteger)index defaultValue:(UIColor *)defaultValue
{
   return hy_colorOfValue(OAI, defaultValue);
}

- (UIColor *)hy_colorAtIndex:(NSUInteger)index
{
   return [self hy_colorAtIndex:index defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)hy_timeAtIndex:(NSUInteger)index defaultValue:(time_t)defaultValue
{
   return hy_timeOfValue(OAI, defaultValue);
}

- (time_t)hy_timeAtIndex:(NSUInteger)index
{
   time_t defaultValue = [[NSDate date] timeIntervalSince1970];
   return [self hy_timeAtIndex:index defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)hy_dateAtIndex:(NSUInteger)index
{
   return hy_dateOfValue(OAI);
}

#pragma mark - NSURL
- (NSURL *)hy_urlAtIndex:(NSUInteger)index defaultValue:(NSURL *)defaultValue
{
   return hy_urlOfValue(OAI, defaultValue);
}

- (NSURL *)hy_urlForKey:(NSUInteger)index
{
   return [self hy_urlAtIndex:index defaultValue:nil];
}

#pragma mark - Enumerate

- (void)hy_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
   [self enumerateObjectsUsingBlock:block];
}

- (void)hy_enumerateUnknownObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
   [self enumerateObjectsUsingBlock:block];
}

- (void)hy_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
   [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       id castedObj = castFunction(obj, nil);
       if (castedObj)
       {
           block(castedObj, idx, stop);
       }
   }];
}

- (void)hy_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block classes:(id)object, ...
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
   
   [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
           block(obj, idx, stop);
       }
   }];
}

- (void)hy_enumerateArrayObjectsUsingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsUsingBlock:block withCastFunction:hy_arrayOfValue];
}

- (void)hy_enumerateDictObjectsUsingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsUsingBlock:block withCastFunction:hy_dictOfValue];
}

- (void)hy_enumerateStringObjectsUsingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsUsingBlock:block withCastFunction:hy_stringOfValue];
}

- (void)hy_enumerateNumberObjectsUsingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsUsingBlock:block withCastFunction:hy_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)hy_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
   [self enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)hy_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
   [self enumerateObjectsWithOptions:opts usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       id castedObj = castFunction(obj, nil);
       if (castedObj)
       {
           block(castedObj, idx, stop);
       }
   }];
}

- (void)hy_enumerateArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:hy_arrayOfValue];
}

- (void)hy_enumerateDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:hy_dictOfValue];
}

- (void)hy_enumerateStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:hy_stringOfValue];
}

- (void)hy_enumerateNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
   [self hy_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:hy_numberOfValue];
}

- (NSArray *)hy_typeCastedObjectsWithCastFunction:(id (*)(id, id))castFunction
{
   NSMutableArray * result = [NSMutableArray array];
   [self hy_enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if (obj) {
           [result addObject:obj];
       }
   } withCastFunction:castFunction];
   return result;
}

- (NSArray *)hy_stringObjects
{
   return [self hy_typeCastedObjectsWithCastFunction:hy_stringOfValue];
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
