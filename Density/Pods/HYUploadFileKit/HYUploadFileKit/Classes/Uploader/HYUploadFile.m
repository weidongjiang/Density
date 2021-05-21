//
//  HYUploadFile.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import "HYUploadFile.h"
#import "HYUploadFileClient.h"
#import "HYUploadModel.h"


@interface HYUploadFile ()

@property (nonatomic, strong) HYUploadSecretModel *tokenModel;
@property (nonatomic, copy) NSString              *filePath;
@property (nonatomic, strong) HYUploadFileModel   *fileModel;
@property (nonatomic, strong) UploadFileInfo      *fileInfo;

@property (nonatomic, assign) NSInteger           retryNum;
@property (nonatomic, assign) NSInteger           timeOut;//超时时间
@property (nonatomic, assign) BOOL                isSuccessLoader;// 成功
@property (nonatomic, strong) HYUploadFileClient  *loader;


@end


@implementation HYUploadFile

- (void)uploadStartWithTokenModel:(HYUploadSecretModel *)tokenModel
                         filePath:(NSString *)filePath
                        fileModel:(HYUploadFileModel *)fileModel {
    self.tokenModel = tokenModel;
    self.filePath = filePath;
    self.fileModel = fileModel;
    self.retryNum = 0;
    self.timeOut = HYUploadFileTimeOut;
    [self _uploadStartWithTokenModel:tokenModel filePath:filePath fileModel:fileModel];
}

- (void)_uploadStartWithTokenModel:(HYUploadSecretModel *)tokenModel
                         filePath:(NSString *)filePath
                         fileModel:(HYUploadFileModel *)fileModel{
    
    HYUploadModel *coverUploadModel = [[HYUploadModel alloc] init];
    coverUploadModel.videoFilePath = filePath;
    coverUploadModel.index = fileModel.index;
    
    HYUploadFileClient *loader = [[HYUploadFileClient alloc] initWithListener:[self creatListener] withSecretModel:tokenModel];
    self.loader = loader;
    loader.uploaderFileType = fileModel.uploaderFileType;
    [loader addFileWithUploadModel:coverUploadModel];
    [loader start];
    
    [self updateSuccessLoader];
}

- (void)updateSuccessLoader {
    self.isSuccessLoader = NO;
    NSLog(@"HYUploadFile uploadFileClient 1 currentTime:%f retryNum:%ld index:%ld successLoader:%d",[[NSDate date] timeIntervalSince1970],(long)self.retryNum,(long)self.fileModel.index,self.isSuccessLoader?1:0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isSuccessLoader) {
            if (self.retryNum < HYUploadFileMaxRetryCount) {
                NSLog(@"HYUploadFile uploadFileClient failure reUpload  currentTime:%f retryNum:%ld index:%ld successLoader:%d url:%@",[[NSDate date] timeIntervalSince1970],(long)self.retryNum,(long)self.fileModel.index,self.isSuccessLoader?1:0,self.fileModel.urlString);
                self.retryNum++;
            }else {
                [self _failureBlock:[HYUploadFileInfo creatUploadFileInfo:self.fileInfo] code:@"-1" message:@"time out" fileModel:self.fileModel];
                NSLog(@"HYUploadFile uploadFileClient failure  currentTime:%f retryNum:%ld index:%ld successLoader:%d url:%@",[[NSDate date] timeIntervalSince1970],(long)self.retryNum,(long)self.fileModel.index,self.isSuccessLoader?1:0,self.fileModel.urlString);

            }
        }
    });
}

- (void)_failureBlock:(HYUploadFileInfo * _Nullable)fileInfo code:(NSString * _Nullable)code message:(NSString * _Nullable)message fileModel:(HYUploadFileModel * _Nullable)fileModel   {
    
    if (self.failureBlock) {
        self.failureBlock(fileInfo,code,message,fileModel);
    }
    [self.loader stop];
    self.loader = nil;
    self.tokenModel = nil;
    self.filePath = nil;
    self.fileModel = nil;
}

- (VODUploadListener *)creatListener {
    OnUploadFinishedListener finishCallBack = ^(UploadFileInfo *fileInfo, VodUploadResult* result){
        NSLog(@"HYUploadFile finishCallBack inidex:%ld filePath:%@",(long)self.fileModel.index,self.filePath);
        self.fileInfo = fileInfo;
        if (self.successBlock) {
            self.successBlock([HYUploadFileInfo creatUploadFileInfo:fileInfo],[HYUploadResult creatUploadResult:result],self.fileModel);
        }
        self.isSuccessLoader = YES;
        NSLog(@"HYUploadFile finishCallBack successLoader:%d",self.isSuccessLoader?1:0);
    };
    
    OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString *message){
        NSLog(@"HYUploadFile testFailedCallbackFunc");
        self.fileInfo = fileInfo;
        if (self.retryNum < HYUploadFileMaxRetryCount) {//重试3次直接返回失败
            self.retryNum++;
            NSLog(@"HYUploadFile testFailedCallbackFunc retryNum：%d",self.retryNum);
            [self _uploadStartWithTokenModel:self.tokenModel filePath:self.filePath fileModel:self.fileModel];
        }else {
            [self _failureBlock:[HYUploadFileInfo creatUploadFileInfo:fileInfo] code:code message:message fileModel:self.fileModel];
            NSLog(@"HYUploadFile testFailedCallbackFunc loader stop");
        }
    };
    
    OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
        self.fileInfo = fileInfo;
        CGFloat uploaded = (CGFloat)uploadedSize;
        CGFloat total = (CGFloat)totalSize;
        CGFloat progress = uploaded / total;
        if (self.progressBlock) {
            self.progressBlock(progress,self.fileModel);
        };
    };
    
    OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
        NSLog(@"HYUploadFile token expired.");
    };
    OnUploadRertyListener testRetryCallbackFunc = ^{
        NSLog(@"HYUploadFile testRetryCallbackFunc: retry begin.");
        [self updateSuccessLoader];
    };
    OnUploadRertyResumeListener testRetryResumeCallbackFunc = ^{
        NSLog(@"HYUploadFile testRetryResumeCallbackFunc: retry begin.");
    };
    OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
        NSLog(@"HYUploadFile started successLoader:%d index:%ld currentTime:%f",self.isSuccessLoader?1:0,(long)self.fileModel.index,[[NSDate date] timeIntervalSince1970]);

    };
    
    VODUploadListener *listener = [[VODUploadListener alloc] init];
    listener.finish = finishCallBack;
    listener.failure = testFailedCallbackFunc;
    listener.progress = testProgressCallbackFunc;
    listener.expire = testTokenExpiredCallbackFunc;
    listener.retry = testRetryCallbackFunc;
    listener.retryResume = testRetryResumeCallbackFunc;
    listener.started = testUploadStartedCallbackFunc;
    return listener;
}


@end
