//
//  HYGCDUtilsTool.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYGCDUtilsTool : NSObject
void hy_dispatch_main_async_safe (dispatch_block_t block);
void hy_dispatch_main_sync_safe(dispatch_block_t block);
void hy_dispatch_after_duration(double duration,dispatch_block_t block);
void hy_dispatch_globle_async(dispatch_block_t block);
dispatch_source_t hy_dispatch_timer(double interval,dispatch_block_t eventHandler,dispatch_block_t cancelHandler);
@end

NS_ASSUME_NONNULL_END
