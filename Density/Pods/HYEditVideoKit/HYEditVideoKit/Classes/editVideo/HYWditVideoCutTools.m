//
//  HYWditVideoCutTools.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/31.
//

#import "HYWditVideoCutTools.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SDAVAssetExportSession.h"
#import "HYVideoSampleDataProvider.h"

#define KcutVideoPath @"cutDoneVideo.mp4"   //剪切的视频文件名

@interface HYWditVideoCutTools ()

@property (nonatomic, strong) AVAssetReader *assetReader;
@property (nonatomic, strong) AVAssetReaderTrackOutput *readerVideoTrackOutput;
@property (nonatomic, strong) AVAssetReaderTrackOutput *readerAudioTrackOutput;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *assetVideoWriterInput;
@property (nonatomic, strong) AVAssetWriterInput *assetAudioWriterInput;

@property (nonatomic, copy) void(^progressHandle)(float progress);

@property (nonatomic, strong) HYVideoSampleDataProvider *sampleDataProvider;

@end

@implementation HYWditVideoCutTools

+ (instancetype)sharedManager {
    static HYWditVideoCutTools *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HYWditVideoCutTools alloc] init];
    });
    return _manager;
}
- (instancetype)init {
    if (self = [super init]) {
        _videoAverageBitRate = 2000*1000;
        _videoExpectedSourceFrameRate = 30;
        _videoMAXSide = 1280;
    }
    return self;
}

- (void)creatNewVideoUrl:(NSURL *)videoUrl
                progress:(void(^)(float progress))progressHandle
   captureVideoWithRange:(AiWditVideoTimeRange)videoRange
              completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle {
    
    if (!videoUrl.absoluteString) {
        return;
    }
    
    self.progressHandle = progressHandle;
    
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];

    CGFloat estimatedDataRate = videoTrack.estimatedDataRate;//比特率
    CGFloat nominalFrameRate = videoTrack.nominalFrameRate;//帧率
    CGFloat width = videoTrack.naturalSize.width;
    CGFloat height = videoTrack.naturalSize.height;
    
    CGFloat videoWidth = width;
    CGFloat videoHeight = height;
    
    // 以下条件同时满足时，不做压缩
    if (!(estimatedDataRate < _videoAverageBitRate && nominalFrameRate < _videoExpectedSourceFrameRate && width < _videoMAXSide && height < _videoMAXSide)) {
        if (estimatedDataRate > _videoAverageBitRate) {
            estimatedDataRate = _videoAverageBitRate;
        }
        
        if (nominalFrameRate > _videoExpectedSourceFrameRate) {
            nominalFrameRate = _videoExpectedSourceFrameRate;
        }
        
        
        if (width > _videoMAXSide || height > _videoMAXSide) {// 有一边超过最大阀值
            NSInteger rate = width - height;//
            if (rate > 0) {// 宽度 是最大边
                videoWidth = _videoMAXSide;
                videoHeight = (_videoMAXSide * height)/width;
            }else { // 高度 是最大边
                videoHeight = _videoMAXSide;
                videoWidth = (_videoMAXSide * width)/height;
            }
        }
        
    }
    
    
    NSString *outPutPath = [[self creatEditVideoOutPutPath] stringByAppendingPathComponent:KcutVideoPath];
    NSURL *writerUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    
    
//    // 第一种
//    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:asset];
//    encoder.outputFileType = AVFileTypeMPEG4;
//    encoder.outputURL = writerUrl;
//    encoder.videoSettings = @
//    {
//        AVVideoCodecKey: AVVideoCodecTypeH264,
//        AVVideoWidthKey: @(videoWidth),
//        AVVideoHeightKey: @(videoHeight),
//        AVVideoCompressionPropertiesKey: @
//        {
//            AVVideoAverageBitRateKey: @(estimatedDataRate),
//            AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
//        },
//    };
//    encoder.audioSettings = @
//    {
//        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
//        AVNumberOfChannelsKey: @2,
//        AVSampleRateKey: @44100,
//        AVEncoderBitRateKey: @128000,
//    };
//
//    [encoder exportAsynchronouslyWithCompletionHandler:^
//    {
//        if (encoder.status == AVAssetExportSessionStatusCompleted)
//        {
//            NSLog(@"Video export succeeded");
//            if (completionHandle) {
//                completionHandle(writerUrl,nil);
//            }
//        }
//        else if (encoder.status == AVAssetExportSessionStatusCancelled)
//        {
//            NSLog(@"Video export cancelled");
//        }
//        else
//        {
//            NSLog(@"Video export failed with error: %@ (%d)", encoder.error.localizedDescription, encoder.error.code);
//        }
//    }];
//
    
    
    // 第二种
    self.sampleDataProvider = [[HYVideoSampleDataProvider alloc] init];
    self.sampleDataProvider.videoWidth = videoWidth;
    self.sampleDataProvider.videoHeight = videoHeight;
    self.sampleDataProvider.videoAverageBitRate = estimatedDataRate;
    self.sampleDataProvider.videoExpectedSourceFrameRate = nominalFrameRate;

    [self.sampleDataProvider creatNewVideoUrl:videoUrl
                               outPutUrl:writerUrl
                                progress:progressHandle
                   captureVideoWithRange:videoRange
                              completion:completionHandle];

    
    // 第三种
//    [self creatNewVideoUrl:videoUrl audioUrl:nil outputFileUrl:writerUrl captureVideoWithRange:videoRange completion:completionHandle];
    
    
}

- (NSString *)creatEditVideoOutPutPath {
    
    NSString *editVideo = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/editVideo"];
    BOOL exit_editVideo = [[NSFileManager defaultManager] fileExistsAtPath:editVideo];
    if (!exit_editVideo) {
        [[NSFileManager defaultManager] createDirectoryAtPath:editVideo withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return editVideo;
}


- (void)creatNewVideoUrl:(NSURL *)videoUrl audioUrl:(NSURL *)audioUrl outputFileUrl:(NSURL *)outputFileUrl captureVideoWithRange:(AiWditVideoTimeRange)videoRange completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle {
    
    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];

    //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
    AVMutableComposition* mixComposition = [AVMutableComposition composition];

    //开始位置startTime
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
    //截取长度videoDuration
    CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);

    //视频采集compositionVideoTrack
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

    //TimeRange截取的范围长度
    //ofTrack来源
    //atTime插放在视频的时间位置
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count > 0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];

    //下面3行代码用于保证后面输出的视频方向跟原视频方向一致
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [compositionVideoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
    NSLog(@"帧率：%f，比特率：%f", assetVideoTrack.nominalFrameRate,assetVideoTrack.estimatedDataRate);

    //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
    AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];

    //外部音频采集，最后合成到原视频，与原视频的音频不冲突
    //声音长度截取范围==视频长度
    CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);

    if (audioUrl) {
        //音频采集compositionCommentaryTrack
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
    }

    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:KcutVideoPath];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }

    //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    //输出视频格式 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie...
    assetExportSession.outputFileType = AVFileTypeMPEG4;
    assetExportSession.outputURL = outPutUrl;
    //输出文件是否网络优化
    assetExportSession.shouldOptimizeForNetworkUse = YES;

    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        completionHandle(outPutUrl,nil);
    }];
}


+ (CGFloat)getMediaDurationWithMediaUrl:(NSString *)mediaUrlStr {
    if (!mediaUrlStr) {
        return 0;
    }
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlStr];
    AVURLAsset *mediaAsset = [[AVURLAsset alloc] initWithURL:mediaUrl options:nil];
    CMTime duration = mediaAsset.duration;
    
    return duration.value / duration.timescale;
}

+ (NSString *)getMediaFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:KcutVideoPath];
}

#pragma 获取想要时间的帧视频图片
+(UIImage *)getCoverImage:(NSURL *)outMovieURL atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage{
    if (!outMovieURL) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outMovieURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    //tips:下面7行代码控制取图的时间点是否为关键帧，系统为了性能是默认取关键帧图片的
    CMTime myTime = CMTimeMake(time, 1);
    if (!isKeyImage) {
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
//        CMTime duration = asset.duration;
        myTime = CMTimeMake(time*30,30);
    }
    
    NSError *thumbnailImageGenerationError = nil;
    CGImageRef thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:myTime actualTime:NULL error:&thumbnailImageGenerationError];
    if (thumbnailImageGenerationError){
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
    
}


+ (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url {
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

//获取视频时长
+ (CGFloat)getVideoTimeWithURL:(NSURL *)videoURL {
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    CGFloat totalSecond = urlAsset.duration.value*1.0f / urlAsset.duration.timescale;
    return totalSecond;
}

@end
