//
//  HYUploadFileClient.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/15.
//

#import "HYUploadFileClient.h"
#import "NSFileManager+HYUtilities.h"
#import "NSDateFormatter+HYUtilities.h"


static NSString * const endpoint = @"http://oss-cn-beijing.aliyuncs.com";
static NSString * const bucketName = @"medolife";

@interface HYUploadFileClient ()

@property(nonatomic, strong) VODUploadClient *uploader;

@end


@implementation HYUploadFileClient
- (instancetype)initWithListener:(VODUploadListener *)listener withSecretModel:(HYUploadSecretModel *)secretModel {
    if (self = [super init]) {
        [self creatFileClient:listener withSecretModel:secretModel];
    }
    return self;
}

- (void)creatFileClient:(VODUploadListener *)listener withSecretModel:(HYUploadSecretModel *)secretModel {

    self.uploader = [[VODUploadClient alloc] init];
    self.uploader.maxRetryCount = HYUploadFileMaxRetryCount;
    self.uploader.timeoutIntervalForRequest = HYUploadFileTimeOut;
    if (secretModel.secret_key && secretModel.security_token && secretModel.expiration) {
        [self.uploader setKeyId:secretModel.secret_id
                accessKeySecret:secretModel.secret_key
                    secretToken:secretModel.security_token
                     expireTime:secretModel.expiration
                       listener:listener];
    }
}

- (void)addFileWithUploadModel:(HYUploadModel *)uploadModel {
        
    NSString *filePath = uploadModel.videoFilePath;
    NSString *ossObject;
    NSString *bucketName = @"ai-old-photo";
    VodInfo *vodInfo = [[VodInfo alloc] init];

    if (self.uploaderFileType == HYUploaderFileTypePicture) {
        ossObject = [self getImageFilePath:filePath uploadModel:uploadModel];
        vodInfo.desc = @"pic";
    }else if (self.uploaderFileType == HYUploaderFileTypeVideo){
        ossObject = [self getVideoFilePath:filePath];
    }else if (self.uploaderFileType == HYUploaderFileTypeAudio){
        ossObject = [self getAuidoFilePath:filePath];
    }
    
    NSLog(@"HYUploadFileClient 上传路径完整地址: %@",[@"http://vcdnb.huoying666.com" stringByAppendingString:ossObject]);
    vodInfo.tags = @(uploadModel.index).stringValue;
    [self.uploader addFile:filePath
                  endpoint:endpoint
                    bucket:bucketName
                    object:ossObject
                   vodInfo:vodInfo];
}

#pragma mark - uploader
/**
 开始上传
 */
- (BOOL)start {
    return [self.uploader start];
}

/**
 停止上传
 */
- (BOOL)stop {
    return [self.uploader stop];
}

/**
 暂停上传
 */
- (BOOL)pause {
    return [self.uploader pause];
}

/**
 恢复上传
 */
- (BOOL)resume {
    return [self.uploader resume];
}


#pragma mark - common
- (NSString *)getMD5WithFilePath:(NSString *)filePath {
    NSString *md5Str = [NSFileManager hy_fileMD5HashCreateWithPath:filePath];
    return md5Str;
}

- (NSString *)getImageFilePath:(NSString *)filePath uploadModel:(HYUploadModel *)uploadModel {
    NSString *imagePath;
    NSString *md5 = [self getMD5WithFilePath:filePath];
    NSString *md5Sub = [md5 substringToIndex:10];
    NSString *nowtime = [self getCurrentTime];
    NSString *basePath = @"images";
    imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@.jpg",basePath,nowtime,md5,md5Sub];
    if (uploadModel.isWallpaper) {
        imagePath = [NSString stringWithFormat:@"wp/%@/%@.jpg",nowtime,md5];
    }
    return imagePath;
}

- (NSString *)getVideoFilePath:(NSString *)filePath {
    NSString *md5 = [self getMD5WithFilePath:filePath];
    NSString *md5Sub = [md5 substringToIndex:10];
    NSString *nowtime = [self getCurrentTime];
    NSString *basePath = @"videos";
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@.mp4",basePath,nowtime,md5,md5Sub];
    return imagePath;
}

- (NSString *)getAuidoFilePath:(NSString *)filePath {
    NSString *md5 = [self getMD5WithFilePath:filePath];
    NSString *md5Sub = [md5 substringToIndex:10];
    NSString *nowtime = [self getCurrentTime];
    NSString *basePath = @"videos";
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@.mp3",basePath,nowtime,md5,md5Sub];
    return imagePath;
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [NSDateFormatter hy_dateFormateterForCurrentThread];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
@end
