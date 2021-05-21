//
//  HYToolsManager.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/25.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import "HYToolsManager.h"
#import "UIImage+HYCompress.h"
#import <SDWebImage/NSData+ImageContentType.h>
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
#import <SDWebImage/SDWebImageDownloader.h>

@interface HYToolsManager()
@property (copy, nonatomic) HYPhotoToolManagerWriteSuccessHandler successHandler;
@property (copy, nonatomic) HYPhotoToolManagerWriteFailedHandler failedHandler;

@property (copy, nonatomic) HYPhotoToolManagerGetImageListSuccessHandler imageSuccessHandler;
@property (copy, nonatomic) HYPhotoToolManagerGetImageListFailedHandler imageFailedHandler;
@property (assign, nonatomic) BOOL writing;
@property (strong, nonatomic) NSMutableArray *downloadTokenArray;

@property (assign, nonatomic) BOOL gettingImage;
@property (assign, nonatomic) BOOL cancelGetImage;

@property (assign, nonatomic) PHImageRequestID currentImageRequestID;
@property (strong, nonatomic) NSMutableArray *allImageModelArray;
@property (strong, nonatomic) NSMutableArray *waitImageModelArray;
@property (strong, nonatomic) NSMutableArray *currentImageModelArray;
@property (strong, nonatomic) NSMutableArray *imageArray;



@property (nonatomic,strong) NSMutableArray *allURLString;
@property (nonatomic,strong) NSMutableArray *photoURLString;
@property (nonatomic,strong) NSMutableArray *videoURLString;
@property (strong, nonatomic) NSMutableArray *waitArray;
@property (strong, nonatomic) NSMutableArray *allArray;
@property (strong, nonatomic) NSMutableArray *writeArray;
@property (strong, nonatomic) NSMutableArray *writeImageArray;



@property (assign, nonatomic) HYPhotoToolManagerRequestType requestType;




@end
@implementation HYToolsManager
- (instancetype)init {
    if (self = [super init]) {
        self.requestType = HYPhotoToolManagerRequestTypeHD;
    }
    return self;
}
#pragma mark ----- 获取imageList
- (void)getSelectedImageList:(NSArray<HYPhotoModel *> *)modelList requestType:(HYPhotoToolManagerRequestType)requestType success:(HYPhotoToolManagerGetImageListSuccessHandler)success failed:(HYPhotoToolManagerGetImageListFailedHandler)failed {
    if (self.gettingImage) {
        HYDebugLog(@"已有任务,请等待");
        return;
    }
    self.requestType = requestType;
    self.cancelGetImage = NO;
    self.gettingImage = YES;
    self.imageSuccessHandler = success;
    self.imageFailedHandler = failed;
    
    [self.imageArray removeAllObjects];
    [self.currentImageModelArray removeAllObjects];
    
    self.allImageModelArray = [NSMutableArray array];
    for (HYPhotoModel *model in modelList) {
        [self.allImageModelArray insertObject:model atIndex:0];
    }
    
    self.waitImageModelArray = [NSMutableArray arrayWithArray:self.allImageModelArray];
    [self getCurrentModelImage];
}

- (void)getCurrentModelImage {
    if (self.cancelGetImage) {
        self.cancelGetImage = NO;
        self.gettingImage = NO;
        [self.downloadTokenArray removeAllObjects];
        HYDebugLog(@"取消了");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.imageFailedHandler) {
                self.imageFailedHandler();
            }
            if (self.imageArray.count) {
                self.imageArray = nil;
            }
        });
        return;
    }
    if (self.waitImageModelArray.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.downloadTokenArray removeAllObjects];
            self.gettingImage = NO;
            self.cancelGetImage = NO;
            if (self.imageSuccessHandler) {
                self.imageSuccessHandler(self.imageArray);
            }
            if (self.imageArray.count) {
                self.imageArray = nil;
            }
            
        });
        return;
    }
    self.currentImageModelArray = [NSMutableArray arrayWithObjects:self.waitImageModelArray.lastObject, nil];
    [self.waitImageModelArray removeLastObject];
    
    HYPhotoModel *model = self.currentImageModelArray.firstObject;
    
    if (model.asset) {
        __weak typeof(self) weakSelf = self;
        CGFloat imgWidth = model.imageSize.width;
        CGFloat imgHeight = model.imageSize.height;
        CGSize size;
        if (self.requestType == HYPhotoToolManagerRequestTypeHD) {
            if (imgHeight > imgWidth / 9 * 17) {
                size = [UIScreen mainScreen].bounds.size;
            }else {
                size = CGSizeMake(model.endImageSize.width * 2.0, model.endImageSize.height * 2.0);
            }
        }else {
            size = PHImageManagerMaximumSize;
        }
        
        self.currentImageRequestID = [HYPhotoTools getHighQualityFormatPhoto:model.asset size:size startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            weakSelf.currentImageRequestID = cloudRequestId;
        } progressHandler:^(double progress) {
            
        } completion:^(UIImage *image,NSDictionary *info) {
            [weakSelf.imageArray addObject:image];
            [weakSelf.allImageModelArray removeObject:weakSelf.currentImageModelArray.firstObject];
            [weakSelf getCurrentModelImage];
        } failed:^(NSDictionary *info) {
            if ([[info objectForKey:PHImageCancelledKey] boolValue]) {
                weakSelf.gettingImage = NO;
                weakSelf.cancelGetImage = NO;
                HYDebugLog(@"取消了请求");
                if (weakSelf.imageFailedHandler) {
                    weakSelf.imageFailedHandler();
                }
                return;
            }
            HYPhotoModel *model = weakSelf.currentImageModelArray.firstObject;
            
            if (self.requestType == HYPhotoToolManagerRequestTypeHD) {
                if (model.thumbPhoto) {
                    [weakSelf.imageArray addObject:model.thumbPhoto];
                    [weakSelf.allImageModelArray removeObject:weakSelf.currentImageModelArray.firstObject];
                    [weakSelf getCurrentModelImage];
                }else {
                    weakSelf.gettingImage = NO;
                    if (weakSelf.imageFailedHandler) {
                        weakSelf.imageFailedHandler();
                    }
                }
            }else{
                // 原图的时候保证每张都是大图
                weakSelf.gettingImage = NO;
                if (weakSelf.imageFailedHandler) {
                    weakSelf.imageFailedHandler();
                }
            }
        }];
    }else {
        if (model.networkPhotoUrl) {
            __weak typeof(self) weakSelf = self;
            if (model.downloadError) {
                SDWebImageDownloadToken *token = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:model.networkPhotoUrl options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (!error && image) {
                        model.thumbPhoto = image;
                        model.previewPhoto = image;
                        [weakSelf.imageArray addObject:model.thumbPhoto];
                        [weakSelf.allImageModelArray removeObject:weakSelf.currentImageModelArray.firstObject];
                        [weakSelf getCurrentModelImage];
                    }else {
                        [weakSelf.downloadTokenArray removeAllObjects];
                        weakSelf.gettingImage = NO;
                        if (weakSelf.imageFailedHandler) {
                            weakSelf.imageFailedHandler();
                        }
                    }
                }];
                [self.downloadTokenArray addObject:token];
                return;
            }
            
            if (!model.downloadComplete) {
                SDWebImageDownloadToken *token = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:model.networkPhotoUrl options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (!error && image) {
                        model.thumbPhoto = image;
                        model.previewPhoto = image;
                        [weakSelf.imageArray addObject:model.thumbPhoto];
                        [weakSelf.allImageModelArray removeObject:weakSelf.currentImageModelArray.firstObject];
                        [weakSelf getCurrentModelImage];
                    }else {
                        [weakSelf.downloadTokenArray removeAllObjects];
                        weakSelf.gettingImage = NO;
                        if (weakSelf.imageFailedHandler) {
                            weakSelf.imageFailedHandler();
                        }
                    }
                }];
                [self.downloadTokenArray addObject:token];
                return;
            }
            [self.imageArray addObject:model.thumbPhoto];
            [self.allImageModelArray removeObject:self.currentImageModelArray.firstObject];
            [self getCurrentModelImage];
        }else {
            if (model.thumbPhoto) {
                [self.imageArray addObject:model.thumbPhoto];
                [self.allImageModelArray removeObject:self.currentImageModelArray.firstObject];
                [self getCurrentModelImage];
            }else {
                self.gettingImage = NO;
                if (self.imageFailedHandler) {
                    self.imageFailedHandler();
                }
            }
        }
    }
}


- (void)cancelGetImageList {
    self.cancelGetImage = YES;
    for (id obj in self.downloadTokenArray) {
        if ([obj isKindOfClass:NSClassFromString(@"SDWebImageDownloadToken")]) {
            [(SDWebImageDownloadToken *)obj cancel];
        }
        [self.downloadTokenArray removeAllObjects];
        if (self.currentImageRequestID) {
            [[PHImageManager defaultManager] cancelImageRequest:self.currentImageRequestID];
            self.currentImageRequestID = 0;
        }
    }
}


#pragma mark ----- 获取图片并写入到bundle中
- (void)writeSelectModelListToTempPathWithList:(NSArray<HYPhotoModel *> *)modelList requestType:(HYPhotoToolManagerRequestType)requestType success:(HYPhotoToolManagerWriteSuccessHandler)success failed:(HYPhotoToolManagerWriteFailedHandler)failed {
    if (self.writing) {
        HYDebugLog(@"已有写入任务,请等待");
        return;
    }
    self.writing = YES;
    self.successHandler = success;
    self.failedHandler = failed;
    self.requestType = requestType;
    
    /** 清空数组 */
    [self.allURLString removeAllObjects];
    [self.photoURLString removeAllObjects];
    [self.videoURLString removeAllObjects];
    [self.writeImageArray removeAllObjects];
    
    
    self.allArray = [NSMutableArray arrayWithArray:modelList];
    
    self.waitArray = [NSMutableArray arrayWithArray:self.allArray];
    [self writeModelToTempPath];
}

#pragma mark ----- 清空数组
- (void)cleanWriteList {
    self.writing = NO;
    self.successHandler = nil;
    self.failedHandler = nil;
    
    [self.allURLString removeAllObjects];
    [self.photoURLString removeAllObjects];
    [self.videoURLString removeAllObjects];
    [self.writeImageArray removeAllObjects];
    
    [self.allArray removeAllObjects];
}

#pragma mark ----- 写入到path中
- (void)writeModelToTempPath {
    if (self.waitArray.count == 0) {
        HYDebugLog(@"全部压缩成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.writing = NO;
            if (self.successHandler) {
                self.successHandler(self.allURLString, self.photoURLString, self.videoURLString,self.writeImageArray);
            }
        });
        return;
    }
    
    self.writeArray = [NSMutableArray arrayWithObjects:self.waitArray.firstObject, nil];
    [self.waitArray removeObjectAtIndex:0];
    
    HYPhotoModel *model = self.writeArray.firstObject;
    
    __weak typeof(self) weakSelf = self;
    if (model.asset) {
        
        [HYPhotoTools getImageData:model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(double progress) {
            
        } completion:^(NSData *imageData, UIImageOrientation orientation) {
            if (imageData) {
                NSString *suffix ;
                
                UIImage *tempImage = [UIImage imageWithData:imageData];
                
                SDImageFormat format = [NSData sd_imageFormatForImageData:imageData];
                
                if (format == SDImageFormatHEIF || format == SDImageFormatHEIC) {
                    suffix = @"jpeg";
                    tempImage = [self fixOrientation:tempImage];
                    imageData = UIImageJPEGRepresentation(tempImage, 0.8);
                }else if(format == SDImageFormatPNG){
                    suffix = @"png";
                    if (tempImage.imageOrientation != UIImageOrientationUp) {
                        tempImage = [self fixOrientation:tempImage];
                        imageData = UIImagePNGRepresentation(tempImage);
                    }
                }else{
                    suffix = @"jpeg";
                    if (tempImage.imageOrientation != UIImageOrientationUp) {
                        tempImage = [self fixOrientation:tempImage];
                        imageData = UIImageJPEGRepresentation(tempImage, 0.8);
                    }
                }
                
                NSString *fileName = [[weakSelf uploadFileName] stringByAppendingString:[NSString stringWithFormat:@".%@",suffix]];
                
                NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                
                if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                    [weakSelf.allArray removeObject:weakSelf.writeArray.firstObject];
                    [weakSelf.allURLString addObject:fullPathToFile];
                    [weakSelf.photoURLString addObject:fullPathToFile];
                    [weakSelf.writeImageArray addObject:tempImage];
                    [weakSelf writeModelToTempPath];
                }else {
                    if (weakSelf.failedHandler) {
                        weakSelf.failedHandler();
                    }
                    [weakSelf cleanWriteList];
                }
            }else{
                /** 如果返回data等于空抛出failed */
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
                [weakSelf cleanWriteList];
            }
            
            
        } failed:^(NSDictionary *info) {
            HYDebugLog(@"%@============",[NSThread currentThread]);
            if (weakSelf.failedHandler) {
                weakSelf.failedHandler();
            }
            [weakSelf cleanWriteList];
        }];
        
     
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGFloat scale;
            if (self.requestType == HYPhotoToolManagerRequestTypeHD) {
                scale = 0.8f;
            }else {
                scale = 1.0f;
            }
            NSData *imageData = UIImageJPEGRepresentation(model.thumbPhoto, scale);
            NSString *fileName = [[self uploadFileName] stringByAppendingString:[NSString stringWithFormat:@".jpeg"]];
            
            NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            
            if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                [self.allArray removeObject:weakSelf.writeArray.firstObject];
                [self.allURLString addObject:fullPathToFile];
                [self.photoURLString addObject:fullPathToFile];
                [self writeModelToTempPath];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.failedHandler) {
                        self.failedHandler();
                    }
                    [self cleanWriteList];
                });
            }
        });
    }
}

#pragma mark ----- 旋转图片的方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
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

// 上传的文件名字
- (NSString *)uploadFileName {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    fileName = [fileName stringByAppendingString:@"hx"];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    
    return [NSString stringWithFormat:@"%@%@",name,fileName];
}
#pragma mark ----- 懒加载

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)currentImageModelArray {
    if (!_currentImageModelArray) {
        _currentImageModelArray = [NSMutableArray array];
    }
    return _currentImageModelArray;
}
- (NSMutableArray *)waitImageModelArray {
    if (!_waitImageModelArray) {
        _waitImageModelArray = [NSMutableArray array];
    }
    return _waitImageModelArray;
}
- (NSMutableArray *)allImageModelArray {
    if (!_allImageModelArray) {
        _allImageModelArray = [NSMutableArray array];
    }
    return _allImageModelArray;
}
- (NSMutableArray *)downloadTokenArray {
    if (!_downloadTokenArray) {
        _downloadTokenArray = [NSMutableArray array];
    }
    return _downloadTokenArray;
}
- (NSMutableArray *)allURLString {
    if (!_allURLString) {
        _allURLString = [NSMutableArray array];
    }
    return _allURLString;
}
- (NSMutableArray *)photoURLString {
    if (!_photoURLString) {
        _photoURLString = [NSMutableArray array];
    }
    return _photoURLString;
}
- (NSMutableArray *)videoURLString {
    if (!_videoURLString) {
        _videoURLString = [NSMutableArray array];
    }
    return _videoURLString;
}

- (NSMutableArray *)writeImageArray {
    if (!_writeImageArray) {
        _writeImageArray = [NSMutableArray array];
    }
    return _writeImageArray;
}

@end
