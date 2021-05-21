//
//  AFmanager.h
//  HyWallPaper
//
//  Created by cano on 2019/3/7.
//  Copyright © 2019年 朱玉HyWallPaper. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFmanager : AFHTTPSessionManager

+(AFHTTPSessionManager *)shareManager;

@end

NS_ASSUME_NONNULL_END
