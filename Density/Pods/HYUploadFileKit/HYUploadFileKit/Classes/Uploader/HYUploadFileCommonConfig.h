//
//  HYUploadFileCommonConfig.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadClient.h>

UIKIT_EXTERN NSString * _Nullable const HYUploadOSSCdnHostKey;
UIKIT_EXTERN NSInteger const HYUploadFileTimeOut;// 超时时间
UIKIT_EXTERN int const HYUploadFileMaxRetryCount;// 重试次数


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HYUploaderFileType) {
    HYUploaderFileTypeUnKnow = 0, // 上传类型为 未知
    HYUploaderFileTypePicture = 1, // 上传类型为 图片
    HYUploaderFileTypeVideo = 2, // 上传类型为 视频
    HYUploaderFileTypeAudio = 3, // 上传类型为 音频
};

typedef NS_ENUM(NSInteger, HYUploadFileStatus) {
    HYUploadFileStatusReady,
    HYUploadFileStatusUploading,
    HYUploadFileStatusCanceled,
    HYUploadFileStatusPaused,
    HYUploadFileStatusSuccess,
    HYUploadFileStatusFailure
};


@interface HYUploadFileModel : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImage *image;//图片image
@property (nonatomic, copy) NSString  *urlString;
@property (nonatomic, assign) HYUploaderFileType uploaderFileType;

@end


@interface AiInfo : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString* title;

/**
 标签
 */
@property (nonatomic, copy) NSString* tags;

/**
 描述
 */
@property (nonatomic, copy) NSString* desc;

/**
 分类id
 */
@property (nonatomic, strong) NSNumber* cateId;

/**
 封面url
 */
@property (nonatomic, copy) NSString* coverUrl;

/**
 设置自定义数据
 */
@property (nonatomic, copy) NSString* userData;

/**
 isProcess
 */
@property (nonatomic, assign) BOOL isProcess;

/**
 是否显示水印
 */
@property (nonatomic, assign) BOOL isShowWaterMark;

/**
 优先级
 */
@property (nonatomic, strong) NSNumber* priority;

/**
 设置存储区域
 */
@property (nonatomic, copy) NSString* storageLocation;

/**
 设置转码模板id
 */
@property (nonatomic, copy) NSString* templateGroupId;


@end


@interface HYUploadFileInfo : NSObject

@property (nonatomic, copy) NSString   *filePath;


@property (nonatomic, copy) NSString   *endpoint;
@property (nonatomic, copy) NSString   *bucket;
@property (nonatomic, copy) NSString   *object;
@property (nonatomic, strong) AiInfo   *vodInfo;
@property (nonatomic, assign)HYUploadFileStatus  state;
+ (HYUploadFileInfo *)creatUploadFileInfo:(UploadFileInfo *)fileInfo;

@end


@interface HYUploadResult: NSObject

@property (nonatomic, copy) NSString   *videoId;
@property (nonatomic, copy) NSString   *imageUrl;
@property (nonatomic, copy) NSString   *bucket;
@property (nonatomic, copy) NSString   *endpoint;
+ (HYUploadResult *)creatUploadResult:(VodUploadResult *)result;

@end


@interface HYUploadFileCommonConfig : NSObject


/// 存储本地文件
/// @param image 需要存储的图片
/// @param index 批量图片的索引
/// @param time 存入这一批时的时间戳
+ (NSString *)saveImageToMDfile:(UIImage *)image index:(NSInteger)index time:(double)time;


/// 压缩后的图片
/// @param image 需要压缩的图片
/// @param maxLength 压缩时最大的图片大小
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
