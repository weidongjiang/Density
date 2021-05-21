//
//  HYAudioDataLoader.h
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYAudioPlayerRequestManager.h"
#import <AVFoundation/AVFoundation.h>


#define MimeType @"video/mp4"
@class HYAudioDataLoader;

@protocol HYAudioDataLoaderDelegate <NSObject>

- (void)loader:(HYAudioDataLoader *)loader isCached:(BOOL)isCached;

- (void)loader:(HYAudioDataLoader *)loader requestError:(NSInteger)errorCode;

@end

@interface HYAudioDataLoader : NSObject<AVAssetResourceLoaderDelegate,HYAudioPlayerRequestDelegate>

@property (nonatomic, weak) id<HYAudioDataLoaderDelegate> delegate;

@property (nonatomic, copy) void(^checkStatusBlock)(NSInteger statusCode);

@property (nonatomic, assign) BOOL isCached;// 是否有缓存

@property (nonatomic, assign) BOOL isObserveFileModifiedTime;// 是否观察修改时间

- (void)stopDownload; // 停止下载
@end


