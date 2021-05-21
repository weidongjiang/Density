//
//  HYUploadFile.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import "HYUploadSecretModel.h"
#import "HYUploadFileCommonConfig.h"

typedef void(^HYUploadFileProgressBlock)(double progress,HYUploadFileModel * _Nullable fileModel);
typedef void(^HYUploadFileSuccessBlock)(HYUploadFileInfo * _Nullable fileInfo, HYUploadResult * _Nullable result,HYUploadFileModel * _Nullable fileModel);
typedef void(^HYUploadFileFailureBlock)(HYUploadFileInfo * _Nullable fileInfo, NSString * _Nullable code, NSString * _Nullable message,HYUploadFileModel * _Nullable fileModel);


NS_ASSUME_NONNULL_BEGIN

@interface HYUploadFile : NSObject

@property (nonatomic, copy) HYUploadFileProgressBlock progressBlock;
@property (nonatomic, copy) HYUploadFileSuccessBlock  successBlock;
@property (nonatomic, copy) HYUploadFileFailureBlock  failureBlock;


- (void)uploadStartWithTokenModel:(HYUploadSecretModel *)tokenModel
                         filePath:(NSString *)filePath
                        fileModel:(HYUploadFileModel *)fileModel;

@end

NS_ASSUME_NONNULL_END
