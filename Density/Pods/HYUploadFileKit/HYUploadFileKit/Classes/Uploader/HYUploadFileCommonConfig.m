//
//  HYUploadFileCommonConfig.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import "HYUploadFileCommonConfig.h"

static NSString *saveImageToMDfileName = @"/mdfile/test.jpg";

@implementation HYUploadFileModel
@end


@implementation AiInfo
@end

@implementation HYUploadFileInfo
+ (HYUploadFileInfo *)creatUploadFileInfo:(UploadFileInfo *)fileInfo {
    HYUploadFileInfo *info = [[HYUploadFileInfo alloc] init];
    info.filePath = fileInfo.filePath;
    info.endpoint = fileInfo.endpoint;
    info.bucket = fileInfo.bucket;
    info.object = fileInfo.object;
    info.vodInfo = [HYUploadFileInfo creatAiInfo:fileInfo.vodInfo];
    info.state = [HYUploadFileInfo creatHYUploadFileStatus:fileInfo.state];
    return info;
}

+ (AiInfo *)creatAiInfo:(VodInfo *)info {
    AiInfo *_info = [[AiInfo alloc] init];
    _info.title = info.title;
    _info.tags = info.tags;
    _info.desc = info.desc;
    _info.cateId = info.cateId;
    _info.coverUrl = info.coverUrl;
    _info.userData = info.userData;
    _info.isProcess = info.isProcess;
    _info.isShowWaterMark = info.isShowWaterMark;
    _info.priority = info.priority;
    _info.storageLocation = info.storageLocation;
    _info.templateGroupId = info.templateGroupId;
    return _info;
}

+ (HYUploadFileStatus)creatHYUploadFileStatus:(VODUploadFileStatus)status {
    HYUploadFileStatus _status = HYUploadFileStatusReady;
    switch (status) {
        case VODUploadFileStatusReady:
            _status = HYUploadFileStatusReady;
        case VODUploadFileStatusUploading:
            _status = HYUploadFileStatusUploading;
        case VODUploadFileStatusCanceled:
            _status = HYUploadFileStatusCanceled;
        case VODUploadFileStatusPaused:
            _status = HYUploadFileStatusPaused;
        case VODUploadFileStatusSuccess:
            _status = HYUploadFileStatusSuccess;
        case VODUploadFileStatusFailure:
            _status = HYUploadFileStatusFailure;
        default:
            break;
    }
    return _status;
}

@end

@implementation HYUploadResult
+ (HYUploadResult *)creatUploadResult:(VodUploadResult *)result {
    
    HYUploadResult *_result = [[HYUploadResult alloc] init];
    _result.videoId = result.videoId;
    _result.imageUrl = result.imageUrl;
    _result.bucket = result.bucket;
    _result.endpoint = result.endpoint;
    return _result;
}
@end


@implementation HYUploadFileCommonConfig

//创建一个文件用于存放本地文件
+ (NSString *)creatFile {
    NSString *mdfile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/mdfile"];
    BOOL exit_mdfile = [[NSFileManager defaultManager] fileExistsAtPath:mdfile];
    if (!exit_mdfile) {
       [[NSFileManager defaultManager] createDirectoryAtPath:mdfile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mdfile;
}

//存储本地文件
+ (NSString *)saveImageToMDfile:(UIImage *)image index:(NSInteger)index time:(double)time {
    
    [HYUploadFileCommonConfig creatFile];
    
    UIImage *compressImage = [self compressImage:image toByte:3 * 1024 * 1024];
    NSData *imgData = UIImageJPEGRepresentation(compressImage, 1.0);
    NSString *path = [NSString stringWithFormat:@"/mdfile/test_%f_%ld.jpg",time,(long)index];
    NSString *imgPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:path];
    BOOL bandExit_mdfile = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (bandExit_mdfile) {
       [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
    }
    
    if ([imgData writeToFile:imgPath atomically:YES]) {
       NSLog(@"saveimg - suc");
    }
    return imgPath;
}

//存储本地文件
+ (NSString *)saveImageToMDfile:(UIImage *)image {
    
    [HYUploadFileCommonConfig creatFile];
    
    UIImage *compressImage = [self compressImage:image toByte:3 * 1024 * 1024];
    NSData *imgData = UIImageJPEGRepresentation(compressImage, 1.0);

    NSString *imgPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/mdfile/test.jpg"];
    BOOL bandExit_mdfile = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (bandExit_mdfile) {
       [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
    }
    
    if ([imgData writeToFile:imgPath atomically:YES]) {
       NSLog(@"saveimg - suc");
    }
    return imgPath;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
       return image;
    }

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
       return resultImage;
    }

    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
       lastDataLength = data.length;
       CGFloat ratio = (CGFloat)maxLength / data.length;
       CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                         (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
       UIGraphicsBeginImageContext(size);
       [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
       resultImage = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}


@end



NSString * _Nullable const HYUploadOSSCdnHostKey = @"HYUploadOSSCdnHostKey";
NSInteger const HYUploadFileTimeOut = 9;
int const HYUploadFileMaxRetryCount = 2;
