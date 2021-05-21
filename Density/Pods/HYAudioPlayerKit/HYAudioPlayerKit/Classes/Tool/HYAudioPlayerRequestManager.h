//
//  HYAudioPlayerRequestManager.h
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYAudioPlayerRequestDelegate <NSObject>

/**
 得到服务器响应
 
 @param statusCode 状态码
 */
- (void)requestManagerDidReceiveResponseWithStatusCode:(NSInteger)statusCode;

/**
 从服务器接收到数据
 */
- (void)requestManagerDidReceiveData;

/**
 缓存结果

 @param isCached 是否完成了缓存
 */
- (void)requestManagerIsCached:(BOOL)isCached;

/**
 接收数据完成

 @param errorCode 错误码
 */
- (void)requestManagerDidCompleteWithError:(NSInteger)errorCode;

@end

@interface HYAudioPlayerRequestManager : NSObject

+ (instancetype)requestWithUrl:(NSURL *)url;

- (instancetype)initWithUrl:(NSURL *)url;

@property (nonatomic, weak) id<HYAudioPlayerRequestDelegate> delegate;

@property (nonatomic, assign) NSInteger requestOffset;//请求起始位置

@property (nonatomic, assign) NSInteger fileLength;//文件长度

@property (nonatomic, assign) NSInteger cacheLength;//缓冲长度

@property (nonatomic, assign) BOOL cancel;//是否取消请求

@property (nonatomic, assign) BOOL isHaveCache;//是否有缓存

@property (nonatomic, assign) BOOL isObserveFileModifiedTime;//是否观察修改时间

- (void)requestStart;

@end


