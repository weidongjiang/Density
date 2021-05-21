//
//  HYUploadFileQueue.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadFileQueue : NSObject

@property (nonatomic,strong,readonly) id         firstObject;

/**
   创建队列

 @param isIntercept 是否需要丢到数据，需要设置下面的 maxQueuesSize  interceptRange 默认NO
 @param maxQueuesSize 队列最大容积   默认0不设置
 @param interceptRange 队列容积超过最大容积时，需要截取丢掉的 默认不需要截取
 @return return value description
 */
- (instancetype)initWithIsIntercept:(BOOL)isIntercept maxQueuesSize:(CGFloat)maxQueuesSize  interceptRange:(NSRange)interceptRange;

/**
 清理队列
 */
- (void)clean;

/**
 是否为空
 @return yes 队列为空  no 不为空
 */
- (BOOL)isEmpty;

/// 当前队列的大小
- (NSInteger)size;
/**
 入队
 @param object 对象
 */
- (void)push:(id)object;

/**
 出队
 */
- (void)pop;

@end

NS_ASSUME_NONNULL_END
