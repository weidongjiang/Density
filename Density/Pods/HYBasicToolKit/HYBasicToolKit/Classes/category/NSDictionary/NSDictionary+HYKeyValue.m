//
//  NSDictionary+HYKeyValue.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSDictionary+HYKeyValue.h"
#import "NSFileManager+HYUtilities.h"

@implementation NSDictionary (HYUtilities)

- (NSDictionary *)hy_dictionaryBySettingObject:(id)value forKey:(id<NSCopying>)key
{
    if (!key) {
        return self;
    }
    NSMutableDictionary *new = [NSMutableDictionary dictionaryWithDictionary:self];
    if (value) {
        [new setObject:value forKey:key];
    }else{
        [new removeObjectForKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:new];
}

- (NSDictionary *)hy_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return self;
    }
    NSMutableDictionary *new = [NSMutableDictionary dictionaryWithDictionary:self];
    [new addEntriesFromDictionary:dictionary];
    return [NSDictionary dictionaryWithDictionary:new];
}

- (NSDictionary *)hy_dictionaryByRemovingNullValues
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    NSNull * null = [NSNull null];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == null) {
            return;
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [result setObject:[obj hy_dictionaryByRemovingNullValues] forKey:key];
        } else {
            [result setObject:obj forKey:key];
        }
    }];
    
    return result;
}

@end

@implementation NSMutableDictionary (HYSetValue)

- (void)hy_removeObjectForKey:(id)aKey
{
    if (aKey == nil)
    {
        return;
    }
    
    [self removeObjectForKey:aKey];
}

- (void)hy_setSafeObject:(id)obj forKey:(id<NSCopying>)key
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]] || key == nil)
        return;
    
    [self setObject:obj forKey:key];
}

- (void)hy_setSafeObject:(id)obj forKey:(id<NSCopying>)key defaultObj:(id)defaultObj {
    if (key == nil || (obj == nil && defaultObj == nil)) {
        return;
    }
    
    if ([obj isKindOfClass:[NSNull class]] || [defaultObj isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if (obj == nil && defaultObj) {
        [self setObject:defaultObj forKey:key];
        return;
    }
    
    [self setObject:obj forKey:key];
}

- (void)hy_setObject:(id)obj forKey:(NSString*)key
{
    if (key == nil)
    {
        return;
    }
    if (!obj)
    {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:obj forKey:key];
}
@end


@implementation NSDictionary (HYExtendedDictionary)

- (BOOL)hy_saveToDocumentsPathFile:(NSString *)path
{
    if (path)
    {
        return [self writeToFile:hy_DocumentFileWithName(path) atomically:NO];
    }
    return NO;
}

+ (NSDictionary *)hy_loadDictioanryFromDocumentsPath:(NSString *)path
{
    if (path)
    {
        return [NSDictionary dictionaryWithContentsOfFile:hy_DocumentFileWithName(path)];
    }
    return nil;
}

@end
