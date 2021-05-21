//
//  HYVideoSampleDataProvider.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/7.
//
typedef struct AiWditVideoTimeRange {
    double location;
    double length;
}AiWditVideoTimeRange;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYVideoSampleDataProvider : NSObject

@property (nonatomic, assign) CGFloat videoAverageBitRate;//码率 默认5000*1000
@property (nonatomic, assign) CGFloat videoExpectedSourceFrameRate;//帧率 默认30
@property (nonatomic, assign) CGFloat videoWidth; // 宽度 没有设置的话保持原视频 宽度
@property (nonatomic, assign) CGFloat videoHeight;// 高度 没有设置的话保持原视频 高度

/// 压缩和剪辑视频
/// @param videoUrl 原视频地址
/// @param outPutUrl 压缩剪辑后 存储视频的地址
/// @param progressHandle 压缩剪辑进度
/// @param videoRange 剪辑视频的范围
/// @param completionHandle 压缩剪辑的结果回调，outPutUrl 非空且error为空 表示压缩剪辑成功。反之失败
- (void)creatNewVideoUrl:(NSURL *)videoUrl
               outPutUrl:(NSURL *)outPutUrl
                progress:(void(^)(float progress))progressHandle
   captureVideoWithRange:(AiWditVideoTimeRange)videoRange
              completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle;

@end

NS_ASSUME_NONNULL_END
