//
//  NSMutableArray+AIThread.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/21.
//

#import "NSMutableArray+AIThread.h"

@implementation NSMutableArray (AIThread)
- (void)ai_addObject:(nonnull id)anObject {
    @synchronized (self) {
        [self addObject:anObject];
    }
}

- (void)ai_insertObject:(nonnull id)anObject atIndex:(NSUInteger)index {
    @synchronized (self) {
        if (index < self.count) {
            [self insertObject:anObject atIndex:index];
        }
    }
}

- (void)ai_removeLastObject {
    @synchronized (self) {
        [self removeLastObject];
    }
}

- (void)ai_removeObjectAtIndex:(NSUInteger)index {
    @synchronized (self) {
        if (index < self.count) {
            [self removeObjectAtIndex:index];
        }
    }
}

- (void)ai_replaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)anObject {
    @synchronized (self) {
        if (index < self.count) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }
    }
}


- (void)ai_addObjectsFromArray:(NSArray<id> *)otherArray {
    @synchronized (self) {
        [self addObjectsFromArray:otherArray];
    }
}
- (void)ai_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    @synchronized (self) {
        if (idx1 < self.count && idx2 < self.count) {
            [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    }
}
- (void)ai_removeAllObjects {
    @synchronized (self) {
        [self removeAllObjects];
    }
}
- (void)ai_removeObject:(nonnull id)anObject inRange:(NSRange)range {
    @synchronized (self) {
        [self removeObject:anObject inRange:range];
    }
}
- (void)ai_removeObject:(nonnull id)anObject {
    @synchronized (self) {
        [self removeObject:anObject];
    }
}

- (id)ai_objectAtIndex:(NSUInteger)index {
    @synchronized (self) {
        if (index < self.count) {
            return [self objectAtIndex:index];
        }
        return nil;
    }
}

@end
