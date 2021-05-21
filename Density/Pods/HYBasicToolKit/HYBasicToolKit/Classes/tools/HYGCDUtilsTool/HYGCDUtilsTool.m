//
//  HYGCDUtilsTool.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "HYGCDUtilsTool.h"

@implementation HYGCDUtilsTool
void hy_dispatch_main_async_safe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
void hy_dispatch_main_sync_safe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
void hy_dispatch_after_duration(double duration,dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}
void hy_dispatch_globle_async(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}

dispatch_source_t hy_dispatch_timer(double interval,dispatch_block_t eventHandler,dispatch_block_t cancelHandler)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC) , interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (eventHandler) {
            eventHandler();
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
        if (cancelHandler) {
            cancelHandler();
        }
    });
    dispatch_resume(timer);
    return timer;
}

@end
