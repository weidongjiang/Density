//
//  NSArray+HYBlocksKit.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSArray+HYBlocksKit.h"

@implementation NSArray (HYBlocksKit)
- (void)hy_each:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);

     [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)hy_apply:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (id)hy_match:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);

    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    if (index == NSNotFound)
        return nil;

    return self[index];
}

- (NSArray *)hy_select:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }]];
}

- (NSArray *)hy_reject:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);
    return [self hy_select:^BOOL(id obj) {
        return !block(obj);
    }];
}

- (NSArray *)hy_map:(id (^)(id obj))block
{
    NSParameterAssert(block != nil);

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
    }];

    return result;
}

- (id)hy_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block
{
    NSParameterAssert(block != nil);

    __block id result = initial;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];

    return result;
}

- (NSInteger)hy_reduceInteger:(NSInteger)initial withBlock:(NSInteger (^)(NSInteger, id))block
{
    NSParameterAssert(block != nil);

    __block NSInteger result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (CGFloat)hy_reduceFloat:(CGFloat)inital withBlock:(CGFloat (^)(CGFloat, id))block
{
    NSParameterAssert(block != nil);
    
    __block CGFloat result = inital;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (BOOL)hy_any:(BOOL (^)(id obj))block
{
    return [self hy_match:block] != nil;
}

- (BOOL)hy_none:(BOOL (^)(id obj))block
{
    return [self hy_match:block] == nil;
}

- (BOOL)hy_all:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}

- (BOOL)hy_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = NO;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < list.count) {
            id obj2 = list[idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        *stop = !result;
    }];

    return result;
}

@end
