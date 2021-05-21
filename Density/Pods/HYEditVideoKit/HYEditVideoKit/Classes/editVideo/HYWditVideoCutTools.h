//
//  HYWditVideoCutTools.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import "HYVideoSampleDataProvider.h"

NS_ASSUME_NONNULL_BEGIN



@interface HYWditVideoCutTools : NSObject

@property (nonatomic, assign) CGFloat videoAverageBitRate;//码率 默认2000*1000
@property (nonatomic, assign) CGFloat videoExpectedSourceFrameRate;//帧率 默认30
@property (nonatomic, assign) CGFloat videoMAXSide; // 最大宽度 1280



+ (instancetype)sharedManager;

- (void)creatNewVideoUrl:(NSURL *)videoUrl
                progress:(void(^)(float progress))progressHandle
   captureVideoWithRange:(AiWditVideoTimeRange)videoRange
              completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle;

/**
 获取多媒体时长
 */
+ (CGFloat)getMediaDurationWithMediaUrl:(NSString *)mediaUrlStr;

/**
 获取合并后的多媒体文件路径
 */
+ (NSString *)getMediaFilePath;
/**
 获取传入时间节点的帧图片（可控制是否为关键帧）
 */
+ (UIImage *)getCoverImage:(NSURL *)outMovieURL
                    atTime:(CGFloat)time
                isKeyImage:(BOOL)isKeyImage;

//根据url获取时长 获取视频时长
+ (CGFloat)getVideoTimeWithURL:(NSURL *)videoURL;

- (NSString *)creatEditVideoOutPutPath;

@end

NS_ASSUME_NONNULL_END
