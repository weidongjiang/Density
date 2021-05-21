//
//  HYUploadModel.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadModel : NSObject

@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSString *bucketName;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL     isPic;
@property (nonatomic, assign) BOOL     isWallpaper;
@property (nonatomic, assign) BOOL     isUploadUserAvatar;
@property (nonatomic, copy) NSString   *current_time;

/** 视频资源 */
@property (nonatomic, strong) PHAsset  *asset;
/** 压缩前的路径 */
@property (nonatomic, strong) NSString *nomalPath;
/** 压缩后的路径 */
@property (nonatomic, strong) NSString *compressPath;
/** oss路径 */
@property (nonatomic, strong) NSString *ossPath;

/** 文件大小 */
@property (nonatomic, assign) long totalSize;

/** 是否已经上传完成 */
@property (nonatomic, assign) BOOL isFinish;

#pragma mark --- 发布feed ---

/** 上传的图片 */
@property (nonatomic, strong)UIImage * upIMG;

/** size _ width */
@property (nonatomic, assign) NSInteger width;

/** size _ height */
@property (nonatomic, assign) NSInteger height;

/** 视频时长 */
@property (nonatomic, copy) NSString * duration;

/** 上传内容 */
@property (nonatomic, copy) NSString * content;

/** 上传完成的图片地址 */
@property (nonatomic, copy) NSString * pic_url;

/** 上传完成的视频地址 */
@property (nonatomic, copy) NSString * video_url;

@end

NS_ASSUME_NONNULL_END
