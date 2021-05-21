//
//  NSArray+HYUtilities.m
//  FBSnapshotTestCase
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSFileManager+HYUtilities.h"
#import <time.h>
#import <stdarg.h>

#pragma mark StringExtensions

@implementation NSArray (HYStringExtensions)

- (NSArray *)hy_arrayBySortingStrings
{
    NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
    for (id eachitem in self)
        if (![eachitem isKindOfClass:[NSString class]])    [sort removeObject:eachitem];
    return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *)hyStringValue
{
    return [self componentsJoinedByString:@" "];
}

@end

#pragma mark UtilityExtensions

@implementation NSArray (HYUtilityExtensions)

- (NSArray *)hy_uniqueMembers
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
    for (id object in self)
    {
        [copy removeObjectIdenticalTo:object];
        [copy addObject:object];
    }
    return copy;
}

- (NSArray *)hy_unionWithArray:(NSArray *) anArray
{
    if (!anArray) return self;
    return [[self arrayByAddingObjectsFromArray:anArray] hy_uniqueMembers];
}

- (NSArray *)hy_intersectionWithArray:(NSArray *)anArray {
    NSMutableArray *copy = [self mutableCopy];// autorelease];
    for (id object in self)
        if (![anArray containsObject:object])
            [copy removeObjectIdenticalTo:object];
    return [copy hy_uniqueMembers];
}

- (NSArray *)hy_intersectionWithSet:(NSSet *)anSet
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
    for (id object in self)
        if (![anSet containsObject:object])
            [copy removeObjectIdenticalTo:object];
    return [copy hy_uniqueMembers];
}

// http://en.wikipedia.org/wiki/Complement_(set_theory)
- (NSArray *)hy_complementWithArray:(NSArray *)anArray
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
    for (id object in self)
        if ([anArray containsObject:object])
            [copy removeObjectIdenticalTo:object];
    return [copy hy_uniqueMembers];
}

- (NSArray *)hy_complementWithSet:(NSSet *)anSet
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
    for (id object in self)
        if ([anSet containsObject:object])
            [copy removeObjectIdenticalTo:object];
    return [copy hy_uniqueMembers];
}

@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (HYUtilityExtensions)
- (void)hy_addSafeObject:(id)obj
{
    if (obj)
    {
        [self addObject:obj];
    }
}

- (void)hy_insertSafeObject:(id)obj atIndex:(NSUInteger)index
{
    if (obj && index<= self.count)
    {
        [self insertObject:obj atIndex:index];
    }
}

+ (NSMutableArray*) hy_arrayWithSet:(NSSet*)set
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[set count]];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [array addObject:obj];
    }];
    return array;
}

- (void)hy_addObjectIfAbsent:(id)object
{
    if (object == nil || [self containsObject:object])
    {
        return;
    }
    
    [self addObject:object];
}

- (NSMutableArray *) hy_reverse
{
    for (int i=0; i<(floor([self count]/2.0)); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
    return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *) hy_scramble
{
    for (int i=0; i<([self count]-2); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:(i+(random()%([self count]-i)))];
    return self;
}

- (NSMutableArray *) hy_removeFirstObject
{
    [self hy_removeObjectAtIndex:0];
    return self;
}

- (void)hy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)hy_removeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

@end


#pragma mark StackAndQueueExtensions

@implementation NSMutableArray (HYStackAndQueueExtensions)

- (id) hy_popObject
{
    if ([self count] == 0) return nil;
    
    id lastObject = [self lastObject];// retain] autorelease];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) hy_pushObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
    return self;
}

- (NSMutableArray *) hy_pushObjects:(id)object,...
{
    if (!object) return self;
    id obj = object;
    va_list objects;
    va_start(objects, object);
    do
    {
        [self addObject:obj];
        obj = va_arg(objects, id);
    } while (obj);
    va_end(objects);
    return self;
}

- (id) hy_pullObject
{
    if ([self count] == 0) return nil;
    
    id firstObject = [self objectAtIndex:0];// retain] autorelease];
    [self removeObjectAtIndex:0];
    return firstObject;
}

- (NSMutableArray *)hy_push:(id)object
{
    return [self hy_pushObject:object];
}

- (id) hy_pop
{
    return [self hy_popObject];
}

- (id) hy_pull
{
    return [self hy_pullObject];
}

- (void)hy_enqueueObjects:(NSArray *)objects
{
    for (id object in [objects reverseObjectEnumerator]) {
        [self insertObject:object atIndex:0];
    }
}

@end


@implementation NSArray (HYPSLib)

- (id)hy_objectUsingPredicate:(NSPredicate *)predicate {
    NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
    if (filteredArray) {
        return [filteredArray firstObject];
    }
    return nil;
}

- (BOOL)hy_isEmpty
{
    return [self count] == 0 ? YES : NO;
}

@end

@implementation NSArray (HYExtendedArray)

- (BOOL)hy_saveToDocumentsPathFile:(NSString *)path
{
    if (path)
    {
        return [self writeToFile:hy_DocumentFileWithName(path) atomically:NO];
    }
    return NO;
}

+ (NSArray *)hy_loadArrayFromDocumentsPath:(NSString *)path
{
    if (path)
    {
        return [NSArray arrayWithContentsOfFile:hy_DocumentFileWithName(path)];
    }
    return nil;
}

@end
