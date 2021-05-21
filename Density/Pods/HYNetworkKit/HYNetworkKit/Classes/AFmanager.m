//
//  AFmanager.m
//  HyWallPaper
//
//  Created by cano on 2019/3/7.
//  Copyright © 2019年 朱玉HyWallPaper. All rights reserved.
//

#import "AFmanager.h"

@implementation AFmanager

+(AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            manager = [AFHTTPSessionManager manager];
        //设置请求数据为json
            manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            manager.requestSerializer.timeoutInterval = 9.0f;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
    });
    return manager;
    
}

@end
