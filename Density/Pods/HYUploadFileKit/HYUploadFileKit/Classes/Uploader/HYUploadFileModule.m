//
//  HYUploadFileModule.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/16.
//

#import "HYUploadFileModule.h"
#import "HYUploadFileQueue.h"
#import "HYUploadFileCommonConfig.h"
#import "ZYNetworking.h"

#define K_UploadFileQueue_maxNum 4

@interface HYUploadFileModule ()

@property (nonatomic, strong) HYUploadFileManager  *uploadFileManager;
@property (nonatomic, strong) HYUploadFileQueue    *allFileQueue;
@property (nonatomic, strong) HYUploadSecretModel  *tokenModel;

@end

@implementation HYUploadFileModule

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

/// 批量上传 图片
/// @param images 需要上传的 图片数组<image 本地相对路径地址>
/// @param progress 批量上传时 对应index单张图片的上传进度
/// @param success 批量上传时 对应index单张图片的上传 成功回调
/// @param failure 批量上传时 对应index单张图片的上传 失败回调
/// @param complete 批量上传时 所有图片上传成功后的回调
- (void)uploadFileImages:(NSArray<UIImage *>*)images
              tokenModel:(HYUploadSecretModel *)tokenModel
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete {
    
    
    for (int i = 0; i < images.count; i++) {
        HYUploadFileModel *fileModel = [[HYUploadFileModel alloc] init];
        fileModel.image = images[i];
        fileModel.index = i;
        fileModel.uploaderFileType = HYUploaderFileTypePicture;
        [self.allFileQueue push:fileModel];
    }
    if (self.allFileQueue.isEmpty) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:@"images is empty" code:-1 userInfo:nil];
            complete(error);
        }
        return;
    }
    // 触发
    [self startUploadFileTokenModel:tokenModel completeHandle:complete progress:progress success:success failure:failure allComplete:complete];

}

- (void)uploadFileVideos:(NSArray<NSString *>*)videos
              tokenModel:(HYUploadSecretModel *)tokenModel
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete {
    
    for (int i = 0; i < videos.count; i++) {
        HYUploadFileModel *fileModel = [[HYUploadFileModel alloc] init];
        fileModel.urlString = videos[i];
        fileModel.index = i;
        fileModel.uploaderFileType = HYUploaderFileTypeVideo;
        [self.allFileQueue push:fileModel];
    }
    if (self.allFileQueue.isEmpty) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:@"videos is empty" code:-1 userInfo:nil];
            complete(error);
        }
        return;
    }
    // 触发
    [self startUploadFileTokenModel:tokenModel completeHandle:complete progress:progress success:success failure:failure allComplete:complete];
}


- (void)uploadFileModels:(NSArray<HYUploadFileModel *>*)models
              tokenModel:(HYUploadSecretModel *)tokenModel
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete {
    
    for (int i = 0; i < models.count; i++) {
        HYUploadFileModel *model = models[i];
        [self.allFileQueue push:model];
    }
    if (self.allFileQueue.isEmpty) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:@"models is empty" code:-1 userInfo:nil];
            complete(error);
        }
        return;
    }
    // 触发
    [self startUploadFileTokenModel:tokenModel completeHandle:complete progress:progress success:success failure:failure allComplete:complete];
}



- (void)startUploadFileTokenModel:(HYUploadSecretModel *)tokenModel
                   completeHandle:(HYUploadFileCompleteHandle)completeHandle
                             progress:(HYUploadFileProgressHandle)progress
                              success:(HYUploadFileSuccessHandle)success
                              failure:(HYUploadFileFailureHandle)failure
                          allComplete:(HYUploadFileCompleteHandle)complete {
    
    NetworkStatus status = [[ZYNetworking sharedZYNetworking] networkStats];
    if (status == StatusNotReachable) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"NetworkStatus StatusNotReachable" code:-2 userInfo:nil];
            HYUploadFileModel *fileModel = [[HYUploadFileModel alloc] init];
            failure(error,fileModel);
            return;
        }
    }
    if (self.allFileQueue.isEmpty) {
        if (complete) {
            complete(nil);
        }
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger count = self.allFileQueue.size;
    if (self.allFileQueue.size > K_UploadFileQueue_maxNum) {
        count = K_UploadFileQueue_maxNum;
    }
    for (int i = 0; i < count; i++ ) {
        HYUploadFileModel *fileModel = self.allFileQueue.firstObject;
        [tempArray addObject:fileModel];
        [self.allFileQueue pop];
    }
    NSLog(@"HYUploadFileManager tempArray count:%ld",(long)count);
    [self startUploadFileModels:tempArray tokenModel:tokenModel progress:progress success:success failure:failure completeHandle:^(NSError * _Nullable error) {
        [self startUploadFileTokenModel:tokenModel completeHandle:^(NSError * _Nullable error) {
            
        } progress:progress success:success failure:failure allComplete:complete];
    }];


}


- (void)startUploadFileModels:(NSArray<HYUploadFileModel *>*)models
                   tokenModel:(HYUploadSecretModel *)tokenModel
                     progress:(HYUploadFileProgressHandle)progress
                      success:(HYUploadFileSuccessHandle)success
                      failure:(HYUploadFileFailureHandle)failure
               completeHandle:(HYUploadFileCompleteHandle)completeHandle {
    
    [self.uploadFileManager uploadFileModels:models
                                    progress:progress
                                     success:success
                                     failure:failure
                                 allComplete:completeHandle
                                  tokenModel:tokenModel];
}

- (HYUploadFileManager *)uploadFileManager {
    if (!_uploadFileManager) {
        _uploadFileManager = [[HYUploadFileManager alloc] init];
    }
    return _uploadFileManager;
}

- (HYUploadFileQueue *)allFileQueue {
    if (!_allFileQueue) {
        _allFileQueue = [[HYUploadFileQueue alloc] init];
    }
    return _allFileQueue;
}


@end
