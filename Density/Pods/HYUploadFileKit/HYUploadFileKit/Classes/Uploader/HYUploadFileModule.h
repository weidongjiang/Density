//
//  HYUploadFileModule.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/16.
//

#import <Foundation/Foundation.h>
#import "HYUploadFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadFileModule : NSObject

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
             allComplete:(HYUploadFileCompleteHandle)complete;

/// 批量上传 视频
/// @param videos 需要上传的 视频数组<本地相对路径地址>,可以包含音频 视频
/// @param progress 批量上传时 对应index单个视频的上传 进度
/// @param success 批量上传时 对应index单个视频的上传 成功回调
/// @param failure 批量上传时 对应index单个视频的上传 失败回调
/// @param complete 批量上传时 所有视频上传成功后的回调
- (void)uploadFileVideos:(NSArray<NSString *>*)videos
              tokenModel:(HYUploadSecretModel *)tokenModel
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete;


/// 批量上传 视频 音频 图片
/// @param models 对应不同类型的上传文件
/// @param progress 批量上传时 对应index单个文件的上传 进度
/// @param success 批量上传时 对应index单个文件的上传 成功回调
/// @param failure 批量上传时 对应index单个文件的上传 失败回调
/// @param complete 批量上传时 所有文件上传成功后的回调
- (void)uploadFileModels:(NSArray<HYUploadFileModel *>*)models
              tokenModel:(HYUploadSecretModel *)tokenModel
                progress:(HYUploadFileProgressHandle)progress
                 success:(HYUploadFileSuccessHandle)success
                 failure:(HYUploadFileFailureHandle)failure
             allComplete:(HYUploadFileCompleteHandle)complete;

@end

NS_ASSUME_NONNULL_END
