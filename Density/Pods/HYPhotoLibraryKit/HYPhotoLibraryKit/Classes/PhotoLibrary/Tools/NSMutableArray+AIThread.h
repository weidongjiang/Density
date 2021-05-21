//
//  NSMutableArray+AIThread.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (AIThread)

- (void)ai_addObject:(nonnull id)anObject;
- (void)ai_insertObject:(nonnull id)anObject atIndex:(NSUInteger)index;
- (void)ai_removeLastObject;
- (void)ai_removeObjectAtIndex:(NSUInteger)index;
- (void)ai_replaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)anObject;

- (void)ai_addObjectsFromArray:(NSArray<id> *)otherArray;
- (void)ai_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)ai_removeAllObjects;
- (void)ai_removeObject:(nonnull id)anObject inRange:(NSRange)range;
- (void)ai_removeObject:(nonnull id)anObject;
- (id)ai_objectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
