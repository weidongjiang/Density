//
//  HYPhotoTools.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/15.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPhotoModel.h"
#import "HYAlbumModel.h"

@interface HYPhotoTools : NSObject

+ (NSInteger)getAuthorizationStatus;

+ (void)authorizationStatusAuthorizedWithCompletion:(void (^)(PHAuthorizationStatus status))completion ;


/**
 根据PHAsset对象获取照片信息   此方法会回调多次
 */
+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset
                                  size:(CGSize)size
                            completion:(void(^)(UIImage *image,NSDictionary *info))completion;
/**
 根据PHAsset对象获取照片信息   此方法只会回调一次
 */
+ (PHImageRequestID)getHighQualityFormatPhotoForPHAsset:(PHAsset *)asset
                                                   size:(CGSize)size
                                             completion:(void (^)(UIImage *image,NSDictionary *info))completion
                                                  error:(void (^)(NSDictionary *info))error;

/**
 根据模型获取image
 
 @param model 模型
 @param completion 完成后的block
 @return 请求id
 */
+ (PHImageRequestID)getImageWithModel:(HYPhotoModel *)model
                           completion:(void (^)(UIImage *image, HYPhotoModel *model))completion;

/**
 根据模型获取指定大小的image
 成功回调可能会执行多次
 
 @param model 模型
 @param size 大小
 @param completion 完成后的block
 @return 请求id
 */
+ (PHImageRequestID)getImageWithAlbumModel:(HYAlbumModel *)model
                                      size:(CGSize)size
                                completion:(void (^)(UIImage *image, HYAlbumModel *model))completion;



/**
 根据PHAsset对象获取 AVPlayerItem
 如果为iCloud上的会自动下载
 
 @param asset PHAsset
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getPlayerItemWithPHAsset:(PHAsset *)asset
                          startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud
                             progressHandler:(void (^)(double progress))progressHandler
                                  completion:(void (^)(AVPlayerItem *playerItem))completion
                                      failed:(void (^)(NSDictionary *info))failed;

/**
 根据PHAsset对象获取 AVAsset
 如果为iCloud上的会自动下载
 
 @param phAsset PHAsset
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)phAsset
                       startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud
                          progressHandler:(void (^)(double progress))progressHandler
                               completion:(void (^)(AVAsset *asset))completion
                                   failed:(void (^)(NSDictionary *info))failed;

/**
 获取 AVAssetExportSession
 
 @param phAsset PHAsset对象
 @param deliveryMode PHVideoRequestOptionsDeliveryMode
 @param presetName 质量
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getExportSessionWithPHAsset:(PHAsset *)phAsset
                                   deliveryMode:(PHVideoRequestOptionsDeliveryMode)deliveryMode
                                     presetName:(NSString *)presetName
                             startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud
                                progressHandler:(void (^)(double progress))progressHandler
                                     completion:(void (^)(AVAssetExportSession * exportSession, NSDictionary *info))completion
                                         failed:(void (^)(NSDictionary *info))failed;

/**
 根据PHAsset对象获取指定大小的图片
 成功回调只会执行一次
 
 @param asset PHAsset
 @param size 大小
 @param succeed 成功后的回调
 @param failed 失败后的回调
 @return 请求id
 */
+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset
                                         size:(CGSize)size
                                      succeed:(void (^)(UIImage *image))succeed
                                       failed:(void (^)(void))failed;

/**
 根据PHAsset对象获取指定大小的图片
 成功回调只会执行一次
 
 @param asset PHAsset对象
 @param size 大小
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset
                                         size:(CGSize)size
                           startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud
                              progressHandler:(void (^)(double progress))progressHandler
                                   completion:(void (^)(UIImage *image,NSDictionary *info))completion
                                       failed:(void (^)(NSDictionary *info))failed;

/**
 根据PHAsset获取指定大小的LivePhoto图片
 
 @param asset PHAsset
 @param size 大小
 @param startRequestICloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getLivePhotoForAsset:(PHAsset *)asset
                                    size:(CGSize)size
                      startRequestICloud:(void (^)(PHImageRequestID iCloudRequestId))startRequestICloud
                         progressHandler:(void (^)(double progress))progressHandler
                              completion:(void (^)(PHLivePhoto *livePhoto))completion
                                  failed:(void (^)(void))failed;

/**
 根据PHAsset获取imageData
 
 @param asset PHAsset
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getImageData:(PHAsset *)asset
              startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud
                 progressHandler:(void (^)(double progress))progressHandler
                      completion:(void (^)(NSData *imageData, UIImageOrientation orientation))completion
                          failed:(void (^)(NSDictionary *info))failed;

/**  通过模型去获取AVAsset  */
+ (PHImageRequestID)getAVAssetWithModel:(HYPhotoModel *)model
                     startRequestIcloud:(void (^)(HYPhotoModel *model, PHImageRequestID cloudRequestId))startRequestIcloud
                        progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler
                             completion:(void (^)(HYPhotoModel *model, AVAsset *asset))completion
                                 failed:(void (^)(HYPhotoModel *model, NSDictionary *info))failed;
/**  通过模型去获取PHLivePhoto  */
+ (PHImageRequestID)getLivePhotoWithModel:(HYPhotoModel *)model
                                     size:(CGSize)size
                       startRequestICloud:(void (^)(HYPhotoModel *model, PHImageRequestID iCloudRequestId))startRequestICloud
                          progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler
                               completion:(void (^)(HYPhotoModel *model, PHLivePhoto *livePhoto))completion
                                   failed:(void (^)(HYPhotoModel *model, NSDictionary *info))failed;
/**  通过模型去获取imageData  */
+ (PHImageRequestID)getImageDataWithModel:(HYPhotoModel *)model
                       startRequestIcloud:(void (^)(HYPhotoModel *model, PHImageRequestID cloudRequestId))startRequestIcloud
                          progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler
                               completion:(void (^)(HYPhotoModel *model, NSData *imageData, UIImageOrientation orientation))completion
                                   failed:(void (^)(HYPhotoModel *model, NSDictionary *info))failed;

+ (PHContentEditingInputRequestID)getImagePathWithModel:(HYPhotoModel *)model
                                     startRequestIcloud:(void (^)(HYPhotoModel *model, PHContentEditingInputRequestID cloudRequestId))startRequestIcloud
                                        progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler
                                             completion:(void (^)(HYPhotoModel *model, NSString *path))completion
                                                 failed:(void (^)(HYPhotoModel *model, NSDictionary *info))failed;

/**  通过asset获取原图  */
+ (PHImageRequestID)getOriginalPhotoWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;


/**  -------  */

/**
 根据AVAsset对象获取指定数量和大小的图片
 (会根据视频时长平分)
 
 @param asset AVAsset
 @param total 总数
 @param size 图片大小
 @param complete 完成后的block
 */
+ (void)getVideoEachFrameWithAsset:(AVAsset *)asset
                             total:(NSInteger)total
                              size:(CGSize)size
                          complete:(void (^)(AVAsset *asset, NSArray<UIImage *> *images))complete;

/**
 获取视频的时长
 */
+ (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration;

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName;

/**
 获取数组里面图片的大小
 */
+ (void)FetchPhotosBytes:(NSArray *)photos
              completion:(void (^)(NSString *totalBytes))completion;

/**
 获取指定字符串的宽度
 
 @param text 需要计算的字符串
 @param height 高度大小
 @param fontSize 字体大小
 @return 宽度大小
 */
+ (CGFloat)getTextWidth:(NSString *)text
                 height:(CGFloat)height
               fontSize:(CGFloat)fontSize;
+ (CGFloat)getTextHeight:(NSString *)text
                   width:(CGFloat)width
                fontSize:(CGFloat)fontSize;


/**********************************/

/**
 保存视频到相册
 
 @param albumName 相册名称
 @param videoURL 视频地址
 */
+ (void)saveVideoToCustomAlbumWithName:(NSString *)albumName videoURL:(NSURL *)videoURL
                              complete:(void (^)(BOOL))complete;


/**
 保存图片到相册
 
 @param albumName 相册name
 @param photo 图片
 @param complete 完成状态
 */
+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo complete:(void (^)(BOOL))complete;


@end



