//
//  HYUploadFileManager.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import "HYUploadFileCommonConfig.h"
#import "HYUploadFile.h"

typedef void(^HYUploadFileProgressHandle)(double progress,HYUploadFileModel * _Nullable fileModel);
typedef void(^HYUploadFileSuccessHandle)(NSString * _Nullable url,NSString * _Nullable cdnHost,HYUploadFileModel * _Nullable fileModel);
typedef void(^HYUploadFileFailureHandle)(NSError * _Nullable error,HYUploadFileModel * _Nullable fileModel);
typedef void(^HYUploadFileCompleteHandle)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadFileManager : NSObject

- (void)uploadFileModels:(NSArray<HYUploadFileModel *>*)models
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete
              tokenModel:(HYUploadSecretModel *)tokenModel;
@end

NS_ASSUME_NONNULL_END
