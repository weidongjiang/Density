//
//  HYPhotoTools.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/15.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//
#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define HYScreenWidth [UIScreen mainScreen].bounds.size.width
#import "HYPhotoTools.h"
#import "HYPhotoModel.h"
#import "UIView+HYFrame.h"
#import "MBProgressHUD+Add.h"
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
@implementation HYPhotoTools

+ (NSInteger)getAuthorizationStatus{
    NSInteger status = 0;
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
    } else {
        status = [PHPhotoLibrary authorizationStatus];
    }
    return status;
}

/// Return YES if Authorized 返回YES如果得到了授权
+ (void)authorizationStatusAuthorizedWithCompletion:(void (^)(PHAuthorizationStatus status))completion {
    NSInteger status = 0;
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
    } else {
        status = [PHPhotoLibrary authorizationStatus];
    }

    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        
        [self requestAlbumAuthorizationWithCompletion:^(PHAuthorizationStatus status) {
            if (completion) {
                completion(status);
            }
        }];
      
    }else{
        completion(status);
    }
}



#pragma mark ----- 请求相册权限                    (void(^)(PHAuthorizationStatus status))handler
+ (void)requestAlbumAuthorizationWithCompletion:(void (^)(PHAuthorizationStatus status))completion {
    void (^callCompletionBlock)(NSInteger status) = ^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(status);
            }
        });
    };
//
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (@available(iOS 14, *)) {
            PHAccessLevel level = PHAccessLevelReadWrite;
            [PHPhotoLibrary requestAuthorizationForAccessLevel:level handler:^(PHAuthorizationStatus status) {
                callCompletionBlock(status);
            }];
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                callCompletionBlock(status);
            }];
        }
    });
}

+ (PHImageRequestID)getAVAssetWithModel:(HYPhotoModel *)model startRequestIcloud:(void (^)(HYPhotoModel *model, PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler completion:(void(^)(HYPhotoModel *model, AVAsset *asset))completion failed:(void(^)(HYPhotoModel *model, NSDictionary *info))failed {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    PHImageRequestID requestId = 0;
    model.iCloudDownloading = YES;
    requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.iCloudDownloading = NO;
                model.isICloud = NO;
                
                if(([asset isKindOfClass:[AVComposition class]] && ((AVComposition *)asset).tracks.count == 2)) {
                    NSString* assetID = [model.asset.localIdentifier substringToIndex:(model.asset.localIdentifier.length - 7)];
                    NSURL* videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"assets-library://asset/asset.mov?id=%@&ext=mov", assetID]];
                    AVAsset *newAsset = [AVAsset assetWithURL:videoURL];
                    if (completion) {
                        completion(model,newAsset);
                    }
                }else{
                    if (completion) {
                        completion(model,asset);
                    }
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                model.isICloud = YES;
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HYDebugLog(@"%f",progress);
                        model.iCloudProgress = progress;
                        if (progressHandler) {
                            progressHandler(model,progress);
                        }
                    });
                };
                /** 下载icloud视频的时候给与提示 */
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showTipMessageInWindow:@"正在同步iCloud视频，请稍等"];
                });
                
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.iCloudDownloading = NO;
                            model.isICloud = NO;
                            /** 注释以防止回调出现问题 */
                            //                            if(([asset isKindOfClass:[AVComposition class]] && ((AVComposition *)asset).tracks.count == 2)) {
                            //                                NSString* assetID = [model.asset.localIdentifier substringToIndex:(model.asset.localIdentifier.length - 7)];
                            //                                NSURL* videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"assets-library://asset/asset.mov?id=%@&ext=mov", assetID]];
                            //                                AVAsset *newAsset = [AVAsset assetWithURL:videoURL];
                            //                                if (completion) {
                            //                                    completion(model,newAsset);
                            //                                }
                            //                            }else{
                            //                                if (completion) {
                            //                                    completion(model,asset);
                            //                                }
                            //                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                                model.iCloudDownloading = NO;
                            }
                            if (failed) {
                                failed(model,info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.iCloudRequestID = cloudRequestId;
                    if (startRequestIcloud) {
                        startRequestIcloud(model,cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                        model.iCloudDownloading = NO;
                    }
                    if (failed) {
                        failed(model,info);
                    }
                });
            }
        }
    }];
    model.iCloudRequestID = requestId;
    return requestId;
}
+ (PHImageRequestID)getLivePhotoWithModel:(HYPhotoModel *)model size:(CGSize)size startRequestICloud:(void (^)(HYPhotoModel *model, PHImageRequestID iCloudRequestId))startRequestICloud progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler completion:(void(^)(HYPhotoModel *model, PHLivePhoto *livePhoto))completion failed:(void(^)(HYPhotoModel *model, NSDictionary *info))failed {
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.networkAccessAllowed = NO;
    PHImageRequestID requestId = 0;
    model.iCloudDownloading = YES;
    requestId = [[PHImageManager defaultManager] requestLivePhotoForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && completion && livePhoto) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.isICloud = NO;
                model.iCloudDownloading = NO;
                completion(model,livePhoto);
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID iCloudRequestId = 0;
                PHLivePhotoRequestOptions *iCloudOption = [[PHLivePhotoRequestOptions alloc] init];
                iCloudOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                iCloudOption.networkAccessAllowed = YES;
                iCloudOption.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.iCloudProgress = progress;
                        if (progressHandler) {
                            progressHandler(model,progress);
                        }
                    });
                };
                iCloudRequestId = [[PHImageManager defaultManager] requestLivePhotoForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFill options:iCloudOption resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && livePhoto) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.isICloud = NO;
                            model.iCloudDownloading = NO;
                            if (completion) {
                                completion(model,livePhoto);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                                model.iCloudDownloading = NO;
                            }
                            if (failed) {
                                failed(model,info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.iCloudRequestID = requestId;
                    if (startRequestICloud) {
                        startRequestICloud(model,iCloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                        model.iCloudDownloading = NO;
                    }
                    if (failed) {
                        failed(model,info);
                    }
                });
            }
        }
    }];
    model.iCloudRequestID = requestId;
    return requestId;
}

+ (PHImageRequestID)getImageDataWithModel:(HYPhotoModel *)model startRequestIcloud:(void (^)(HYPhotoModel *model, PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(HYPhotoModel *model, double progress))progressHandler completion:(void(^)(HYPhotoModel *model, NSData *imageData, UIImageOrientation orientation))completion failed:(void(^)(HYPhotoModel *model, NSDictionary *info))failed {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    option.synchronous = NO;
    if (model.type == HYPhotoModelMediaTypePhotoGif) {
        option.version = PHImageRequestOptionsVersionOriginal;
    }
    
    model.iCloudDownloading = YES;
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.iCloudDownloading = NO;
                model.isICloud = NO;
                if (completion) {
                    completion(model,imageData, orientation);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.version = PHImageRequestOptionsVersionOriginal;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.iCloudProgress = progress;
                        if (progressHandler) {
                            progressHandler(model,progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.iCloudDownloading = NO;
                            model.isICloud = NO;
                            if (completion) {
                                completion(model,imageData, orientation);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                                model.iCloudDownloading = NO;
                            }
                            if (failed) {
                                failed(model,info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.iCloudRequestID = cloudRequestId;
                    if (startRequestIcloud) {
                        startRequestIcloud(model,cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                        model.iCloudDownloading = NO;
                    }
                    if (failed) {
                        failed(model,info);
                    }
                });
            }
        }
    }];
    model.iCloudRequestID = requestID;
    return requestID;
}

+ (PHContentEditingInputRequestID)getImagePathWithModel:(HYPhotoModel *)model startRequestIcloud:(void (^)(HYPhotoModel *, PHContentEditingInputRequestID))startRequestIcloud progressHandler:(void (^)(HYPhotoModel *, double))progressHandler completion:(void (^)(HYPhotoModel *, NSString *))completion failed:(void (^)(HYPhotoModel *, NSDictionary *))failed {
    
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    return [model.asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        BOOL downloadFinined = (![[info objectForKey:PHContentEditingInputCancelledKey] boolValue] && ![info objectForKey:PHContentEditingInputErrorKey]);
        
        if (downloadFinined && contentEditingInput.fullSizeImageURL.relativePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(model, contentEditingInput.fullSizeImageURL.relativePath);
                }
            });
        }else {
            
            if ([[info objectForKey:PHContentEditingInputResultIsInCloudKey] boolValue] && ![[info objectForKey:PHContentEditingInputCancelledKey] boolValue] && ![info objectForKey:PHContentEditingInputErrorKey]) {
                PHContentEditingInputRequestOptions *iCloudOptions = [[PHContentEditingInputRequestOptions alloc] init];
                iCloudOptions.networkAccessAllowed = YES;
                iCloudOptions.progressHandler = ^(double progress, BOOL * _Nonnull stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(model,progress);
                        }
                    });
                };
                
                PHContentEditingInputRequestID iCloudRequestID = [model.asset requestContentEditingInputWithOptions:iCloudOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
                    BOOL downloadFinined = (![[info objectForKey:PHContentEditingInputCancelledKey] boolValue] && ![info objectForKey:PHContentEditingInputErrorKey]);
                    
                    if (downloadFinined && contentEditingInput.fullSizeImageURL.relativePath) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(model, contentEditingInput.fullSizeImageURL.relativePath);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(model,info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(model,iCloudRequestID);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(model,info);
                    }
                });
            }
        }
    }];
}

+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && completion && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result,info);
            });
        }
    }];
}

+ (PHImageRequestID)getHighQualityFormatPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion error:(void(^)(NSDictionary *info))error {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(result,info);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                };
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(result,info);
                            }
                        });
                    }else {
                        
                    }
                }];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        error(info);
                    }
                });
            }
        }
    }];
    return requestID;
}

+ (PHImageRequestID)getImageWithAlbumModel:(HYAlbumModel *)model size:(CGSize)size completion:(void (^)(UIImage *image, HYAlbumModel *model))completion {
    @try {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            BOOL cancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
            if (!cancelled && result) {
                if (completion) completion(result,model);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                };
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData];
                    if (!resultImage && result) {
                        resultImage = result;
                    }
                    if (completion) completion(result,model);
                }];
            }
        }];
        return imageRequestID;
    } @catch (NSException *exception) {
        if (completion) completion(nil,model);
        return 0;
    }
}

+ (PHImageRequestID)getImageWithModel:(HYPhotoModel *)model completion:(void (^)(UIImage *image, HYPhotoModel *model))completion {
    @try {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:model.requestSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            BOOL cancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
            if (!cancelled && result) {
                if (completion) completion(result,model);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                };
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData];
                    if (!resultImage && result) {
                        resultImage = result;
                    }
                    if (completion) completion(result,model);
                }];
            }
        }];
        return imageRequestID;
    } @catch (NSException *exception) {
        if (completion) completion(nil,model);
        return 0;
    }
}

+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(UIImage *image, NSDictionary *info))completion failed:(void(^)(NSDictionary *info))failed {
    @try {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = NO;
        
        PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined && result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(result , info);
                    }
                });
            }else {
                if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue]) {
                    PHImageRequestID cloudRequestId = 0;
                    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    option.resizeMode = PHImageRequestOptionsResizeModeFast;
                    option.networkAccessAllowed = YES;
                    option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (progressHandler) {
                                progressHandler(progress);
                            }
                        });
                    };
                    cloudRequestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                        if (downloadFinined && result) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completion) {
                                    completion(result,info);
                                }
                            });
                        }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (failed) {
                                    failed(info);
                                }
                            });
                        }
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (startRequestIcloud) {
                            startRequestIcloud(cloudRequestId);
                        }
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failed) {
                            failed(info);
                        }
                    });
                }
            }
        }];
        return requestID;
    } @catch (NSException *exception) {
        if (failed) {
            failed(nil);
        }
        return 0;
    }
    
}



+ (PHImageRequestID)FetchLivePhotoForPHAsset:(PHAsset *)asset Size:(CGSize)size Completion:(void (^)(PHLivePhoto *, NSDictionary *))completion
{
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.networkAccessAllowed = NO;
    
    return [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHLivePhotoInfoCancelledKey] boolValue] && ![info objectForKey:PHLivePhotoInfoErrorKey]);
        if (downloadFinined && completion && livePhoto) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(livePhoto,info);
            });
        }
    }];
}

/**
 获取视频的时长
 */
+ (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"] ||
             [englishName isEqualToString:@"最後に追加した項目"] ||
             [englishName isEqualToString:@"최근 추가된 항목"] ){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"] ||
             [englishName isEqualToString:@"スクリーンショット"] ||
             [englishName isEqualToString:@"스크린샷"] ){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"] ||
             [englishName isEqualToString:@"カメラロール"] ||
             [englishName isEqualToString:@"카메라 롤"] ){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"] ||
             [englishName isEqualToString:@"셀카"] ){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"] ||
             [englishName isEqualToString:@"ビデオ"] ){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"] ||
             [englishName isEqualToString:@"すべての写真"] ||
             [englishName isEqualToString:@"비디오"] ){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"] ||
             [englishName isEqualToString:@"スローモーション"] ){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"] ||
             [englishName isEqualToString:@"最近削除した項目"] ){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"] ||
             [englishName isEqualToString:@"お気に入り"] ||
             [englishName isEqualToString:@"최근 삭제된 항목"] ){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"] ||
             [englishName isEqualToString:@"パノラマ"] ||
             [englishName isEqualToString:@"파노라마"] ){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}

+ (void)FetchPhotosBytes:(NSArray *)photos completion:(void (^)(NSString *))completion
{
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0 ; i < photos.count ; i++) {
            HYPhotoModel *model = photos[i];
            if (model.type == HYPhotoModelMediaTypeCameraPhoto) {
                NSData *imageData;
                if (UIImagePNGRepresentation(model.thumbPhoto)) {
                    //返回为png图像。
                    imageData = UIImagePNGRepresentation(model.thumbPhoto);
                }else {
                    //返回为JPEG图像。
                    imageData = UIImageJPEGRepresentation(model.thumbPhoto, 1.0);
                }
                dataLength += imageData.length;
                assetCount ++;
                if (assetCount >= photos.count) {
                    NSString *bytes = [self getBytesFromDataLength:dataLength];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion(bytes);
                    });
                }
            }else {
                [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    dataLength += imageData.length;
                    assetCount ++;
                    if (assetCount >= photos.count) {
                        NSString *bytes = [self getBytesFromDataLength:dataLength];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) completion(bytes);
                        });
                    }
                }];
            }
        }
    });
}

+ (void)getVideoEachFrameWithAsset:(AVAsset *)asset total:(NSInteger)total size:(CGSize)size complete:(void (^)(AVAsset *, NSArray<UIImage *> *))complete {
    long duration = round(asset.duration.value) / asset.duration.timescale;
    
    NSTimeInterval average = (CGFloat)duration / (CGFloat)total;
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.maximumSize = size;
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i <= total; i++) {
        CMTime time = CMTimeMake((i * average) * asset.duration.timescale, asset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [arr addObject:value];
    }
    NSMutableArray *arrImages = [NSMutableArray array];
    __block long count = 0;
    [generator generateCGImagesAsynchronouslyForTimes:arr completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorSucceeded:
                [arrImages addObject:[UIImage imageWithCGImage:image]];
                break;
            case AVAssetImageGeneratorFailed:
                
                break;
            case AVAssetImageGeneratorCancelled:
                
                break;
        }
        count++;
        if (count == arr.count && complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(asset, arrImages);
            });
        }
    }];
}
+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

+ (void)saveVideoToCustomAlbumWithName:(NSString *)albumName videoURL:(NSURL *)videoURL {
    if (!videoURL) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path])) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], nil, nil, nil);
                }
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:videoURL].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存失败");
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                HYDebugLog(@"保存自定义相册失败");
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存自定义相册失败");
            } else {
                HYDebugLog(@"保存成功");
            }
        });
    }];
}


+ (PHImageRequestID)getOriginalPhotoWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    if (progressHandler) {
        [option setProgressHandler:progressHandler];
    }
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL cancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
        if (!cancelled && imageData) {
            UIImage *result = [self fixOrientation:[UIImage imageWithData:imageData]];
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (completion) completion(result,info,isDegraded);
        }
    }];
}


+ (CGFloat)getTextWidth:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return newSize.width;
}
+ (CGFloat)getTextHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return newSize.height;
}



+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size succeed:(void (^)(UIImage *image))succeed failed:(void(^)(void))failed {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (succeed) {
                    succeed(result);
                }
            });
        }else {
            if (failed) {
                failed();
            }
        }
    }];
    return requestID;
}

+ (PHImageRequestID)getPlayerItemWithPHAsset:(PHAsset *)asset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVPlayerItem *playerItem))completion failed:(void(^)(NSDictionary *info))failed {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && playerItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(playerItem);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:cloudOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && playerItem) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(playerItem);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
}

+ (PHImageRequestID)getExportSessionWithPHAsset:(PHAsset *)phAsset deliveryMode:(PHVideoRequestOptionsDeliveryMode)deliveryMode presetName:(NSString *)presetName startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAssetExportSession * exportSession, NSDictionary *info))completion failed:(void(^)(NSDictionary *info))failed {
    //    AVAssetExportPresetHighestQuality
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = deliveryMode;
    options.networkAccessAllowed = NO;
    
    return [[PHImageManager defaultManager] requestExportSessionForVideo:phAsset options:options exportPreset:presetName resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        // 是否成功
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && exportSession) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(exportSession, info);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID iRequestId = 0;
                PHVideoRequestOptions *iOption = [[PHVideoRequestOptions alloc] init];
                iOption.deliveryMode = deliveryMode;
                iOption.networkAccessAllowed = YES;
                iOption.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                iRequestId = [[PHImageManager defaultManager] requestExportSessionForVideo:phAsset options:iOption exportPreset:presetName resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && exportSession) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(exportSession, info);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(iRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
}

+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)phAsset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion failed:(void(^)(NSDictionary *info))failed {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(asset);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(asset);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
}



+ (PHImageRequestID)getImageData:(PHAsset *)asset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(NSData *imageData, UIImageOrientation orientation))completion failed:(void(^)(NSDictionary *info))failed {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.networkAccessAllowed = NO;
    option.version = PHImageRequestOptionsVersionOriginal;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(imageData, orientation);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.version = PHImageRequestOptionsVersionOriginal;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(imageData, orientation);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
    return requestID;
}


+ (PHImageRequestID)getLivePhotoForAsset:(PHAsset *)asset size:(CGSize)size startRequestICloud:(void (^)(PHImageRequestID iCloudRequestId))startRequestICloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(PHLivePhoto *livePhoto))completion failed:(void(^)(void))failed {
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.networkAccessAllowed = NO;
    
    return [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && completion && livePhoto) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(livePhoto);
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]) {
                PHImageRequestID iCloudRequestId = 0;
                PHLivePhotoRequestOptions *iCloudOption = [[PHLivePhotoRequestOptions alloc] init];
                iCloudOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                iCloudOption.networkAccessAllowed = YES;
                iCloudOption.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                iCloudRequestId = [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:iCloudOption resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && livePhoto) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(livePhoto);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed();
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestICloud) {
                        startRequestICloud(iCloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed();
                    }
                });
            }
        }
    }];
}


/********************分割线*********************/

+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj pathFile:(NSString *)pathFile progress:(void (^)(float progress))progress success:(void (^)(void))success failure:(void (^)(void))failure {
    AVAsset *avAsset;
    if ([obj isKindOfClass:[AVAsset class]]) {
        avAsset = (AVAsset *)obj;
    }else if ([obj isKindOfClass:[NSURL class]]){
        avAsset = [AVURLAsset URLAssetWithURL:(NSURL *)obj options:nil];
    }else {
        if (failure) {
            failure();
        }
        return nil;
    }
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:pathFile];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                if (success) {
                    success();
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusFailed){
                if (failure) {
                    failure();
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusCancelled) {
                if (failure) {
                    failure();
                }
            }
        }];
        return exportSession;
    }else {
        if (failure) {
            failure();
        }
        
        return nil;
    }
}



#pragma mark  ----新的保存方法----
+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo complete:(void (^)(BOOL))complete{
    if (!photo) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存失败");
                if (complete) {
                    complete(NO);
                }
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                HYDebugLog(@"保存自定义相册失败");
                if (complete) {
                    complete(NO);
                }
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存自定义相册失败");
                if (complete) {
                    complete(NO);
                }
            } else {
                HYDebugLog(@"保存成功");
                if (complete) {
                    complete(YES);
                }
            }
        });
    }];
}

+ (void)saveVideoToCustomAlbumWithName:(NSString *)albumName videoURL:(NSURL *)videoURL complete:(void (^)(BOOL))complete{
    if (!videoURL) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized){
            if (complete) {
                complete(NO);
            }
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path])) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], nil, nil, nil);
                }
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:videoURL].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存失败");
                if (complete) {
                    complete(NO);
                }
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                HYDebugLog(@"保存自定义相册失败");
                if (complete) {
                    complete(NO);
                }
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存自定义相册失败");
                if (complete) {
                    complete(NO);
                }
            } else {
                HYDebugLog(@"保存成功");
                if (complete) {
                    complete(YES);
                }
            }
        });
    }];
}

/// 修正图片转向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/** 创建相册相关 */
+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo {
    if (!photo) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!iOS9_Later) {
                UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存失败");
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self createCollection:albumName];
            if (collection == nil) {
                HYDebugLog(@"保存自定义相册失败");
                return;
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                HYDebugLog(@"保存自定义相册失败");
            } else {
                HYDebugLog(@"保存成功");
            }
        });
    }];
}
// 创建自己要创建的自定义相册
+ (PHAssetCollection * )createCollection:(NSString *)albumName {
    NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil;
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
            HYDebugLog(@"创建相册失败...");
            return nil;
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}
@end
