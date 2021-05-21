//
//  HYAudioDataLoader.m
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import "HYAudioDataLoader.h"
#import "HYAudioFileManager.h"
#import <CoreServices/CoreServices.h>


@interface HYAudioDataLoader ()

@property (nonatomic, strong) NSMutableArray<AVAssetResourceLoadingRequest *> *requestList;
@property (nonatomic, strong) HYAudioPlayerRequestManager *requestManager;

@end

@implementation HYAudioDataLoader
- (instancetype)init {
    if (self = [super init]) {
        if (_requestList.count >= 0) {
            [_requestList removeAllObjects];
        }
    }
    return self;
}

- (NSMutableArray<AVAssetResourceLoadingRequest *> *)requestList{
    if (!_requestList) {
        _requestList = [NSMutableArray array];
    }
    return _requestList;
}

- (void)stopDownload{
    if (self.requestManager) {
        self.requestManager.cancel = YES;
    }
}

#pragma mark - RequestTaskDelegate
- (void)requestManagerDidReceiveResponseWithStatusCode:(NSInteger)statusCode{
    if (self.checkStatusBlock) {
        self.checkStatusBlock(statusCode);
    }
}
- (void)requestManagerDidReceiveData {
    [self processRequestList];
}
- (void)requestManagerIsCached:(BOOL)isCached{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loader:isCached:)]) {
        [self.delegate loader:self isCached:isCached];
    }
}
- (void)requestManagerDidCompleteWithError:(NSInteger)errorCode{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loader:requestError:)]) {
        [self.delegate loader:self requestError:errorCode];
    }
}
#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self addLoadingRequest:loadingRequest];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    [self.requestList removeObject:loadingRequest];
}

#pragma mark - 处理LoadingRequest
- (void)addLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self.requestList addObject:loadingRequest];

    @synchronized(self) {
        if (self.requestManager) {
            long long offset = loadingRequest.dataRequest.requestedOffset;
            if (offset >= 0 && offset <= self.requestManager.cacheLength) {
                //数据已经缓存，则直接完
                [self processRequestList];

            }else {

                //数据还没缓存，则等待数据下载；如果是Seek操作，则重新请求
                [self newTaskWithLoadingRequest:loadingRequest cache:NO];
            }
        }else {

            [self newTaskWithLoadingRequest:loadingRequest cache:YES];
        }
    }
}

- (void)newTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest cache:(BOOL)cache {
    
    NSUInteger fileLength = 0;
    if (self.requestManager) {
        fileLength = self.requestManager.fileLength;
        self.requestManager.cancel = YES;
    }
    self.requestManager = [[HYAudioPlayerRequestManager alloc] initWithUrl:loadingRequest.request.URL];
    if (fileLength > 0) {
        self.requestManager.fileLength = fileLength;
    }
    self.requestManager.delegate = self;
    
    self.requestManager.isHaveCache = self.isCached;
    self.requestManager.isObserveFileModifiedTime = self.isObserveFileModifiedTime;
    
    [self.requestManager requestStart];
}


- (void)processRequestList {
    NSMutableArray * finishRequestList = [NSMutableArray array];
    NSMutableArray *tempRequestListArray = self.requestList.mutableCopy;

    for (AVAssetResourceLoadingRequest * loadingRequest in tempRequestListArray) {
        if ([self finishLoadingWithLoadingRequest:loadingRequest]) {
            [finishRequestList addObject:loadingRequest];
        }
    }
    
    [tempRequestListArray removeObjectsInArray:finishRequestList];
    self.requestList = tempRequestListArray;
}

- (BOOL)finishLoadingWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //填充信息
    if (@available(iOS 14.0, *)) {
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(UTTagClassMIMEType, (__bridge CFStringRef)(MimeType), NULL);
        loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    } else {
        // Fallback on earlier versions
    }
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentLength = self.requestManager.fileLength;
    
    //读文件，填充数据
    NSUInteger cacheLength = self.requestManager.cacheLength;//已经缓存的数据长度
    NSUInteger requestedOffset = (long)loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {//如果当前下载长度不为0
        requestedOffset = (long)loadingRequest.dataRequest.currentOffset;
    }
    
    //当前下载长度-要请求的长度
    NSUInteger canReadLength = cacheLength - requestedOffset;
    NSUInteger respondLength = MIN(canReadLength, loadingRequest.dataRequest.requestedLength);
    
    [loadingRequest.dataRequest respondWithData:[HYAudioFileManager hy_readTempFileDataWithOffset:requestedOffset length:respondLength]];
    
    //如果完全响应了所需要的数据，则完成
    NSUInteger nowendOffset = requestedOffset + canReadLength;
    NSUInteger reqEndOffset =  (long)loadingRequest.dataRequest.requestedOffset + (long)loadingRequest.dataRequest.requestedLength;
    if (nowendOffset >= reqEndOffset) {
        [loadingRequest finishLoading];
        return YES;
    }
    return NO;
}

@end
