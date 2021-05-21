//
//  HYVideoSampleDataProvider.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/7.
//

#import "HYVideoSampleDataProvider.h"
#import <AVFoundation/AVFoundation.h>
#import "HYUtilsMacro.h"


@interface HYVideoSampleDataProvider ()

@property (nonatomic, strong)AVAssetReader *assetVideoReader;
@property (nonatomic, strong)AVAssetWriter *assetWriter;
@property (nonatomic, strong)AVAssetReaderTrackOutput *readerVideoTrackOutput;
@property (nonatomic, strong)AVAssetWriterInput *assetVideoWriterInput;


@property (nonatomic, strong)AVAssetReader *assetAudioReader;
@property (nonatomic, strong)AVAssetReaderTrackOutput *readerAudioTrackOutput;
@property (nonatomic, strong)AVAssetWriterInput *assetAudioWriterInput;

@end

@implementation HYVideoSampleDataProvider

- (instancetype)init {
    if (self = [super init]) {
        _videoAverageBitRate = 5000*1000;
        _videoExpectedSourceFrameRate = 30;
    }
    return self;
}

- (void)dealloc {
    HYDebugLog(@"%s",__func__);
}

- (void)creatNewVideoUrl:(NSURL *)videoUrl
               outPutUrl:(NSURL *)outPutUrl
                progress:(void(^)(float progress))progressHandle
   captureVideoWithRange:(AiWditVideoTimeRange)videoRange
              completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle {
    if (!videoUrl.absoluteString) {
        return;
    }
    if (!outPutUrl.absoluteString) {
        return;
    }
    
    kWeakSelf
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    if (!asset) {
        return;
    }
    
    //创建AVAssetReader对象用来读取asset数据
    NSError *assetVideoReaderError = nil;
    self.assetVideoReader = [AVAssetReader assetReaderWithAsset:asset error:&assetVideoReaderError];
    if (assetVideoReaderError) {
        if (completionHandle) {
            completionHandle(nil,assetVideoReaderError);
        }
        return;
    }
    NSError *assetWriterError = nil;
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:outPutUrl fileType:AVFileTypeQuickTimeMovie error:&assetWriterError];
    if (assetWriterError) {
        if (completionHandle) {
            completionHandle(nil,assetWriterError);
        }
        return;
    }
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
   
    // readerVideoTrackOutput init
    self.readerVideoTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:[self _getReaderVideoTrackOutputSetting]];
    if ([self.assetVideoReader canAddOutput:self.readerVideoTrackOutput]) {
        [self.assetVideoReader addOutput:self.readerVideoTrackOutput];
    }
    
    // assetVideoWriterInput init
    self.assetVideoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self _getVideoWriterInputSetting:videoTrack]];
    self.assetVideoWriterInput.expectsMediaDataInRealTime = YES;
    self.assetVideoWriterInput.transform = videoTrack.preferredTransform;
    if ([self.assetWriter canAddInput:self.assetVideoWriterInput]) {
        [self.assetWriter addInput:self.assetVideoWriterInput];
    }
    
    //assetAudioReader init
    NSError *assetAudioReaderError = nil;
    self.assetAudioReader = [AVAssetReader assetReaderWithAsset:asset error:&assetAudioReaderError];
    if (assetAudioReaderError) {
        if (completionHandle) {
            completionHandle(nil,assetAudioReaderError);
        }
        return;
    }
    
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (audioTrack) {
        self.readerAudioTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:[self _getAudioOutputSettings]];
        if ([self.assetAudioReader canAddOutput:self.readerAudioTrackOutput]) {
            [self.assetAudioReader addOutput:self.readerAudioTrackOutput];
        }
        
        //assetAudioWriterInput init
        self.assetAudioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:[audioTrack mediaType] outputSettings:[self _getSssetAudioWriterInputSettings]];
        self.assetAudioWriterInput.expectsMediaDataInRealTime = YES;
        if ([self.assetWriter canAddInput:self.assetAudioWriterInput]) {
            [self.assetWriter addInput:self.assetAudioWriterInput];
        }
    }
    
    //开始读
    [self.assetVideoReader startReading];
    
    //开始写
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, asset.duration.timescale);
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:startTime];

    CMTime length = CMTimeMakeWithSeconds(videoRange.length, asset.duration.timescale);
    __block CMTime lastSamplePresentationTime;
    __block CGFloat duration;
    dispatch_queue_t videoWriterQueue = dispatch_queue_create("com.wheatear.jiang.videoWriter", 0);
    [self.assetVideoWriterInput requestMediaDataWhenReadyOnQueue:videoWriterQueue usingBlock:^{
        while (weakSelf.assetVideoWriterInput.isReadyForMoreMediaData) {
            if (self.assetVideoReader.status == AVAssetReaderStatusReading) {
                //每次读取一个buffer
                CMSampleBufferRef buffer = [weakSelf.readerVideoTrackOutput copyNextSampleBuffer];
                if (buffer) {
                    lastSamplePresentationTime = CMSampleBufferGetPresentationTimeStamp(buffer);
                    lastSamplePresentationTime = CMTimeSubtract(lastSamplePresentationTime, startTime);
                    CGFloat progress = duration == 0 ? 1 : CMTimeGetSeconds(lastSamplePresentationTime) / CMTimeGetSeconds(length);
                    progress = progress*0.5;
                    if (progress > 0.5) {
                        progress = 0.5;
                    }
                    HYDebugLog(@"HYEditVideo progress 1  %f",progress);
                    
                    if (progressHandle) {
                        progressHandle(progress);
                    }
                    //将读来的buffer加入到写对象中开始写
                    [weakSelf.assetVideoWriterInput appendSampleBuffer:buffer];
                    CMSampleBufferInvalidate(buffer);
                    CFRelease(buffer);
                    buffer = NULL;
                }
            }else if (weakSelf.assetVideoReader.status == AVAssetReaderStatusFailed || weakSelf.assetVideoReader.status == AVAssetReaderStatusUnknown)
            {
                if (weakSelf.assetVideoReader) {
                    [weakSelf.assetVideoReader cancelReading];
                }
                
                if (weakSelf.assetWriter) {
                    [weakSelf.assetWriter cancelWriting];
                }
                
                NSError *_error = weakSelf.assetVideoReader.error;
                if (_error) {
                    HYDebugLog(@"HYEditVideo cannot assetReader: %@",_error);
                } else {
                    HYDebugLog(@"HYEditVideo finish assetReader.");
                }
                if (completionHandle) {
                    completionHandle(nil,_error);
                }
                HYDebugLog(@"HYEditVideo AVAssetReaderStatusFailed error:%@",_error);
                return;
            }else if (weakSelf.assetVideoReader.status == AVAssetReaderStatusCompleted) {
                HYDebugLog(@"HYEditVideo Video Reader not completed");
                
                [weakSelf.assetVideoWriterInput markAsFinished];
                if (asset.tracks.count > 1) {
                    [weakSelf assetAudioWriterInputAsset:asset progress:progressHandle captureVideoWithRange:videoRange completion:completionHandle];
                }else {
                    [weakSelf finshCompletionHandle:completionHandle];
                }
            }
        }
    }];
}

- (void)assetAudioWriterInputAsset:(AVAsset *)asset
                          progress:(void(^)(float progress))progressHandle
             captureVideoWithRange:(AiWditVideoTimeRange)videoRange
                        completion:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle {
    
    kWeakSelf
    [self.assetAudioReader startReading];
    
    //开始写
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, asset.duration.timescale);
    [self.assetWriter startSessionAtSourceTime:startTime];
    
    
    CMTime length = CMTimeMakeWithSeconds(videoRange.length, asset.duration.timescale);
    __block CMTime lastSamplePresentationTime;
    __block CGFloat duration;
    
    __strong typeof(weakSelf) strongSelf = weakSelf;
    dispatch_queue_t audioWriterQueue = dispatch_queue_create("com.wheatear.jiang.audioWriter", 0);
    [self.assetAudioWriterInput requestMediaDataWhenReadyOnQueue:audioWriterQueue usingBlock:^{
        while (strongSelf.assetAudioWriterInput.isReadyForMoreMediaData) {
            if (strongSelf.assetAudioReader.status == AVAssetReaderStatusReading) {
                CMSampleBufferRef buffer = [weakSelf.readerAudioTrackOutput copyNextSampleBuffer];
                if (buffer) {
                    lastSamplePresentationTime = CMSampleBufferGetPresentationTimeStamp(buffer);
                    lastSamplePresentationTime = CMTimeSubtract(lastSamplePresentationTime, startTime);
                    CGFloat progress = duration == 0 ? 1 : CMTimeGetSeconds(lastSamplePresentationTime) / CMTimeGetSeconds(length);
                    progress = progress*0.5 + 0.5;
                    if (progress < 0.5) {
                        progress = 0.5;
                    }
                    if (progress > 1) {
                        progress = 1;
                    }
                    HYDebugLog(@"progress 2  %f",progress);
                    
                    if (progressHandle) {
                        progressHandle(progress);
                    }
                    
                    [strongSelf.assetAudioWriterInput appendSampleBuffer:buffer];
                    CFRelease(buffer);
                    buffer = NULL;
                }
                
            }else if (strongSelf.assetAudioReader.status == AVAssetReaderStatusUnknown || strongSelf.assetAudioReader.status == AVAssetReaderStatusFailed) {
                
                if (strongSelf.assetAudioReader) {
                    [strongSelf.assetAudioReader cancelReading];
                }
                
                if (strongSelf.assetWriter) {
                    [strongSelf.assetWriter cancelWriting];
                }
                NSError *_error = weakSelf.assetAudioReader.error;
                if (_error) {
                    HYDebugLog(@"HYEditVideo cannot assetReader: %@",_error);
                } else {
                    HYDebugLog(@"HYEditVideo finish assetReader.");
                }
                if (completionHandle) {
                    completionHandle(nil,_error);
                }
                return;
                
            }else {
                
                [strongSelf.assetAudioWriterInput markAsFinished];
                CMTime endTime = CMTimeMakeWithSeconds(videoRange.location + videoRange.length, asset.duration.timescale);
                if (videoRange.length <= videoRange.location) {
                    endTime = CMTimeMakeWithSeconds(asset.duration.value, asset.duration.timescale);
                }
                [strongSelf.assetWriter endSessionAtSourceTime:endTime];
                [strongSelf finshCompletionHandle:completionHandle];
            }
        }
    }];
}

- (void)finshCompletionHandle:(void (^)(NSURL * outPutUrl,NSError *error))completionHandle {
    kWeakSelf
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [self.assetWriter finishWritingWithCompletionHandler:^{
        NSError *assetWriterError = strongSelf.assetWriter.error;
        NSURL *url = strongSelf.assetWriter.outputURL;
        if (completionHandle) {
            completionHandle(url,assetWriterError);
        }
        if (assetWriterError) {
            HYDebugLog(@"HYEditVideo cannot write: %@",assetWriterError);
        } else {
            HYDebugLog(@"HYEditVideo finish writing.");
        }
    }];
}

// 读 视频资源参数
- (NSDictionary *)_getReaderVideoTrackOutputSetting {
    NSMutableDictionary * videoSetting = [[NSMutableDictionary alloc] init];
    [videoSetting setObject:@(kCVPixelFormatType_32BGRA) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    return [videoSetting copy];
}
// 写 视频资源参数
- (NSDictionary *)_getVideoWriterInputSetting:(AVAssetTrack *)videoTrack {
    if (!videoTrack) {
        return nil;
    }
    if (_videoWidth <= 0) {
        _videoWidth = videoTrack.naturalSize.width;
    }
    if (_videoHeight <= 0) {
        _videoWidth = videoTrack.naturalSize.height;
    }
    
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey         : @(_videoAverageBitRate),
                                             AVVideoExpectedSourceFrameRateKey: @(_videoExpectedSourceFrameRate),
                                             AVVideoProfileLevelKey           : AVVideoProfileLevelH264High40
                                             
    };
    
    NSDictionary *compressionVideoSetting = nil;
    if (@available(iOS 11.0, *)) {
        compressionVideoSetting = @{
            AVVideoCodecKey                   : AVVideoCodecTypeH264,
            AVVideoWidthKey                   : @(_videoWidth),
            AVVideoHeightKey                  : @(_videoHeight),
            AVVideoCompressionPropertiesKey   : compressionProperties
        };
    } else {
        // Fallback on earlier versions
        compressionVideoSetting = @{
            AVVideoCodecKey                   : AVVideoCodecH264,
            AVVideoWidthKey                   : @(_videoWidth),
            AVVideoHeightKey                  : @(_videoHeight),
            AVVideoCompressionPropertiesKey   : compressionProperties
        };
    }
    return compressionVideoSetting;
}
//写 声音资源参数
- (NSDictionary *)_getSssetAudioWriterInputSettings {
    NSMutableDictionary *audioOutputSettings = [[NSMutableDictionary alloc] init];
        [audioOutputSettings setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
        [audioOutputSettings setObject:@(44100) forKey:AVSampleRateKey];
        [audioOutputSettings setObject:@(1) forKey:AVNumberOfChannelsKey];
        [audioOutputSettings setObject:@(64000) forKey:AVEncoderBitRateKey];
    
    return audioOutputSettings;
}

//读声音资源参数
- (NSDictionary *)_getAudioOutputSettings {
    NSMutableDictionary *audioOutputSettings = [[NSMutableDictionary alloc] init];
    [audioOutputSettings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [audioOutputSettings setObject:@(44100) forKey:AVSampleRateKey];
    [audioOutputSettings setObject:@(2) forKey:AVNumberOfChannelsKey];
    [audioOutputSettings setObject:@(32) forKey:AVLinearPCMBitDepthKey];
    [audioOutputSettings setObject:@(YES) forKey:AVLinearPCMIsFloatKey];

    return [audioOutputSettings copy];
}


@end
