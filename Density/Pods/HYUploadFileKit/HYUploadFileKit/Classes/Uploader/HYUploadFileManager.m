//
//  HYUploadFileManager.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import "HYUploadFileManager.h"
#import "HYUploadModel.h"
#import "HYUploadSecretModel.h"
#import "HYUploadFileQueue.h"

#import "NSDictionary+HYTypeCast.h"

@interface HYUploadFileManager ()

@property (nonatomic, copy) HYUploadFileProgressHandle  progressHandle;
@property (nonatomic, copy) HYUploadFileSuccessHandle   successHandle;
@property (nonatomic, copy) HYUploadFileFailureHandle   failureHandle;
@property (nonatomic, copy) HYUploadFileCompleteHandle  completeHandle;

@property (nonatomic, strong)HYUploadFileQueue          *fileTempQueue;
@property (nonatomic, copy) dispatch_queue_t            uploadQueue;

@property (nonatomic, strong)HYUploadFileQueue          *fileQueue;// 管理数据存储
@property (nonatomic, strong)HYUploadFileQueue          *fileMaxTempQueue;// 最大一批的队列

@property (nonatomic, assign) BOOL  isAllCompleteFaile;

@end

@implementation HYUploadFileManager

- (instancetype)init {
    if (self = [super init]) {
        [self setDefaultConfig];
    }
    return self;
}

- (void)setDefaultConfig {

    self.isAllCompleteFaile = NO;
}

- (void)uploadFileModels:(NSArray<HYUploadFileModel *>*)models
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete
              tokenModel:(HYUploadSecretModel *)tokenModel {
    
    self.progressHandle = progress;
    self.successHandle = success;
    self.failureHandle = failure;
    self.completeHandle = complete;
    
    double currentDate = [[NSDate date] timeIntervalSince1970] * 1000;
    NSInteger _currentDate = roundf(currentDate);
    for (int i = 0; i < models.count; i++) {
        dispatch_async(self.uploadQueue, ^{
            HYUploadFileModel *model = models[i];
            NSString *path = nil;
            [self.fileTempQueue push:model];
            if (model.uploaderFileType == HYUploaderFileTypePicture) {
                path = [HYUploadFileCommonConfig saveImageToMDfile:model.image index:model.index time:_currentDate];
            }else if (model.uploaderFileType == HYUploaderFileTypeVideo){
                path = model.urlString;
            }else if (model.uploaderFileType == HYUploaderFileTypeAudio) {
                path = model.urlString;
            }
            NSLog(@"HYUploadFileManager uploadFile path:%@",path);
            [self uploadStartFilePath:path fileModel:model tokenModel:tokenModel];
        });
    }
}

- (void)uploadStartFilePath:(NSString *)filePath fileModel:(HYUploadFileModel *)fileModel tokenModel:(HYUploadSecretModel *)tokenModel {
    
    HYUploadFile *file = [[HYUploadFile alloc] init];
    [file uploadStartWithTokenModel:tokenModel filePath:filePath fileModel:fileModel];
    file.progressBlock = ^(double progress, HYUploadFileModel * _Nullable fileModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HYUploadFileManager handle index:%ld progress:%f",(long)fileModel.index,progress);
            if (self.progressHandle) {
                self.progressHandle(progress,fileModel);
            }
        });
    };
    file.successBlock = ^(HYUploadFileInfo * _Nullable fileInfo, HYUploadResult * _Nullable result, HYUploadFileModel * _Nullable fileModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.successHandle) {
                self.successHandle(fileInfo.object, tokenModel.cdn_host, fileModel);
            }
            NSLog(@"HYUploadFileManager handle index:%ld success:%@",(long)fileModel.index,fileInfo.object);
            BOOL bandExit_mdfile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (bandExit_mdfile) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
            [self.fileTempQueue pop];
            if (self.fileTempQueue.isEmpty) {
                if (self.completeHandle) {
                    self.completeHandle(nil);
                }
                NSLog(@"HYUploadFileManager handle complete");
            }
        });
    };
    file.failureBlock = ^(HYUploadFileInfo * _Nullable fileInfo, NSString * _Nullable code, NSString * _Nullable message, HYUploadFileModel * _Nullable fileModel) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:message code:code.integerValue userInfo:nil];
            if (self.failureHandle) {
                self.failureHandle(error,fileModel);
            }
            NSLog(@"HYUploadFileManager handle index:%ld failure:%@ code:%@ message:%@",(long)index,fileInfo.object,code,message);
            
            if (self.completeHandle && !self.isAllCompleteFaile) {
                self.completeHandle(error);
                self.isAllCompleteFaile = YES;
            }
            
        });
        
    };
}


- (HYUploadFileQueue *)fileTempQueue {
    if (!_fileTempQueue) {
        _fileTempQueue = [[HYUploadFileQueue alloc] initWithIsIntercept:NO maxQueuesSize:0 interceptRange:NSMakeRange(0, 0)];
    }
    return _fileTempQueue;
}

- (dispatch_queue_t)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = dispatch_queue_create("com.wheatear.uploadFileQueue", DISPATCH_QUEUE_SERIAL);//创建队列
    }
    return _uploadQueue;
}

- (HYUploadFileQueue *)fileQueue {
    if (!_fileQueue) {
        _fileQueue = [[HYUploadFileQueue alloc] initWithIsIntercept:NO maxQueuesSize:0 interceptRange:NSMakeRange(0, 0)];
    }
    return _fileQueue;
}

- (HYUploadFileQueue *)fileMaxTempQueue {
    if (!_fileMaxTempQueue) {
        _fileMaxTempQueue = [[HYUploadFileQueue alloc] initWithIsIntercept:NO maxQueuesSize:0 interceptRange:NSMakeRange(0, 0)];
    }
    return _fileMaxTempQueue;
}

@end
