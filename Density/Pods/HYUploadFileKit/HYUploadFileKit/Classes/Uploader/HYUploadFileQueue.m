//
//  HYUploadFileQueue.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import "HYUploadFileQueue.h"

@interface HYUploadFileQueue ()
@property (nonatomic,strong) NSMutableArray      *queues; //!< 队列
@property (nonatomic,assign,readonly) NSInteger  size;//!< 队列大小
@property (nonatomic,assign) BOOL                isIntercept;//!< 是否需要丢到数据，需要设置下面的 maxQueuesSize  interceptRange
@property (nonatomic,assign) CGFloat             maxQueuesSize;//!< 队列最大容积
@property (nonatomic,assign) NSRange             interceptRange;//!< 队列容积超过最大容积时，需要截取丢掉的

@end

@implementation HYUploadFileQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isIntercept = NO;
        self.maxQueuesSize = 0;
        self.interceptRange = NSMakeRange(0, 0);
    }
    return self;
}

- (instancetype)initWithIsIntercept:(BOOL)isIntercept maxQueuesSize:(CGFloat)maxQueuesSize  interceptRange:(NSRange)interceptRange
{
    self = [super init];
    if (self) {
        self.isIntercept = isIntercept;
        self.maxQueuesSize = maxQueuesSize;
        self.interceptRange = interceptRange;
    }
    return self;
}

- (id)firstObject {
    if (![self isEmpty]) {
        return self.queues[0];
    } else {
        return nil;
    }
}
- (void)clean {
    [self.queues removeAllObjects];
}
- (BOOL)isEmpty {
    return self.queues.count == 0;
}
- (NSInteger)size {
    return self.queues.count;
}

- (void)pop {
    if (self.size > 0) {
        @synchronized (self) {
            [self.queues removeObjectAtIndex:0];
        }
    }
}

- (void)push:(id)object {
    @synchronized (self) {
        if (object == nil) {
            return;//暂时这样处理
        }
        [self.queues addObject:object];
        
        if (self.isIntercept) {
            [self keepQueuesSize];
        }
    }
}
- (void)pushFront:(id)object {
    @synchronized (self) {
        if (![self isEmpty]) {
            if (object == nil) {
                return;
            }
            [self.queues insertObject:object atIndex:1];
        }
    }
}

- (void)keepQueuesSize {
    if ([self size] > self.maxQueuesSize) {
        [self.queues removeObjectsInRange:self.interceptRange];
    }
}


- (NSMutableArray *)queues {
    if (!_queues) {
        _queues = [NSMutableArray array];
    }
    return _queues;
}


@end
