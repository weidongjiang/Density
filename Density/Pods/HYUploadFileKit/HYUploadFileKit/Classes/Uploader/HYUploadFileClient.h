//
//  HYUploadFileClient.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/15.
//

#import <Foundation/Foundation.h>
#import "HYUploadSecretModel.h"
#import <VODUpload/VODUploadClient.h>
#import "HYUploadModel.h"
#import "HYUploadFileCommonConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadFileClient : NSObject

@property (nonatomic , assign) HYUploaderFileType uploaderFileType;

- (instancetype)initWithListener:(VODUploadListener *)listener withSecretModel:(HYUploadSecretModel *)secretModel;

- (void)addFileWithUploadModel:(HYUploadModel *)uploadModel;

/**
 开始上传
 */
- (BOOL)start;

/**
 停止上传
 */
- (BOOL)stop;

/**
 暂停上传
 */
- (BOOL)pause;

/**
 恢复上传
 */
- (BOOL)resume;

@end

NS_ASSUME_NONNULL_END
