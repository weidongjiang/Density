//
//  NSDictionary+HYBlocksKit.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSDictionary+HYBlocksKit.h"

@implementation NSDictionary (HYBlocksKit)

- (void)hy_each:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (void)hy_apply:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (id)hy_match:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    return self[[[self keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) {
            *stop = YES;
            return YES;
        }

        return NO;
    }] anyObject]];
}

- (NSDictionary *)hy_select:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSArray *keys = [[self keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }] allObjects];

    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)hy_reject:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);
    return [self hy_select:^BOOL(id key, id obj) {
        return !block(key, obj);
    }];
}

- (NSDictionary *)hy_map:(id (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self hy_each:^(id key, id obj) {
        id value = block(key, obj) ?: [NSNull null];
        result[key] = value;
    }];

    return result;
}

- (BOOL)hy_any:(BOOL (^)(id key, id obj))block
{
    return [self hy_match:block] != nil;
}

- (BOOL)hy_none:(BOOL (^)(id key, id obj))block
{
    return [self hy_match:block] == nil;
}

- (BOOL)hy_all:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!block(key, obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}
@end
