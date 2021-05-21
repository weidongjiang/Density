
//
//  HYPhotoModel.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/9/28.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoModel.h"
#import "HYPhotoTools.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"

#define hyTopMargin (HYISIPhoneX ? 44 : 0)
#define hyBottomMargin (HYISIPhoneX ? 34 : 0)

@implementation HYPhotoModel
- (NSURL *)fileURL {
    if (self.type == HYPhotoModelMediaTypeCameraVideo && !_fileURL) {
        _fileURL = self.videoURL;
    }
    if (self.type != HYPhotoModelMediaTypeCameraPhoto) {
        if (self.asset && !_fileURL) {
            _fileURL = [self.asset valueForKey:@"mainFileURL"];
        }
    }
    return _fileURL;
}

- (NSDate *)creationDate {
    if (self.type == HYPhotoModelMediaTypeCameraPhoto || self.type == HYPhotoModelMediaTypeCameraVideo) {
        return _creationDate ?: [NSDate date];
    }
    if (!_creationDate) {
        _creationDate = [self.asset valueForKey:@"creationDate"];
    }
    return _creationDate;
}

- (NSDate *)modificationDate {
    if (self.type == HYPhotoModelMediaTypeCameraPhoto || self.type == HYPhotoModelMediaTypeCameraVideo) {
        if (!_modificationDate) {
            _modificationDate = [NSDate date];
        }
    }
    if (!_modificationDate) {
        _modificationDate = [self.asset valueForKey:@"modificationDate"];
    }
    return _modificationDate;
}


- (NSString *)localIdentifier {
    if (self.asset) {
        return self.asset.localIdentifier;
    }
    return _localIdentifier;
}

+ (instancetype)photoModelWithPHAsset:(PHAsset *)asset {
    return [[self alloc] initWithPHAsset:asset];
}

+ (instancetype)photoModelWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

+ (instancetype)photoModelWithImageURL:(NSURL *)imageURL {
    return [[self alloc] initWithImageURL:imageURL];
}

+ (instancetype)photoModelWithVideoURL:(NSURL *)videoURL videoTime:(NSTimeInterval)videoTime {
    return [[self alloc] initWithVideoURL:videoURL videoTime:videoTime];
}

+ (instancetype)photoModelWithVideoURL:(NSURL *)videoURL {
    return [[self alloc] initWithVideoURL:videoURL];
}

- (instancetype)initWithImageURL:(NSURL *)imageURL {
    if (self = [super init]) {
        self.type = HYPhotoModelMediaTypeCameraPhoto;
        self.subType = HYPhotoModelMediaSubTypePhoto;
//        self.thumbPhoto = [HYPhotoTools hx_imageNamed:@"hx_qz_photolist_picture_fail@2x.png"];
        self.previewPhoto = self.thumbPhoto;
        self.imageSize = self.thumbPhoto.size;
        self.networkPhotoUrl = imageURL;
    }
    return self;
}

- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if (self = [super init]) {
        self.asset = asset;
        self.type = HYPhotoModelMediaTypePhoto;
        self.subType = HYPhotoModelMediaSubTypePhoto;
    }
    return self;
}

- (void)setPhotoManager:(HYPhotoLibraryManager *)photoManager {
    _photoManager = photoManager;
    if (self.asset.mediaType == PHAssetMediaTypeImage) {
        self.subType = HYPhotoModelMediaSubTypePhoto;
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            if (photoManager.configuration.singleSelected) {
                self.type = HYPhotoModelMediaTypePhoto;
            }else {
                self.type = photoManager.configuration.lookGifPhoto ? HYPhotoModelMediaTypePhotoGif : HYPhotoModelMediaTypePhoto;
            }
        }else if (self.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || self.asset.mediaSubtypes == 10){
            if (KHYISIOS9) {
                if (!photoManager.configuration.singleSelected) {
                    self.type = photoManager.configuration.lookLivePhoto ? HYPhotoModelMediaTypeLivePhoto : HYPhotoModelMediaTypePhoto;

                }else {
                    self.type = HYPhotoModelMediaTypePhoto;
                }
            }else {
                self.type = HYPhotoModelMediaTypePhoto;
            }
        }else {
            self.type = HYPhotoModelMediaTypePhoto;
        }
    }else if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        self.type = HYPhotoModelMediaTypeVideo;
        self.subType = HYPhotoModelMediaSubTypeVideo;
    }
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    if (self = [super init]) {
        self.type = HYPhotoModelMediaTypeCameraVideo;
        self.subType = HYPhotoModelMediaSubTypeVideo;
        self.videoURL = videoURL;
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL] ;
        player.shouldAutoplay = NO;
        UIImage  *image = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        
        NSString *time = [HYPhotoTools getNewTimeFromDurationSecond:second];
        self.videoDuration = second;
        self.videoURL = videoURL;
        self.videoTime = time;
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = self.thumbPhoto.size;
    }
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL videoTime:(NSTimeInterval)videoTime {
    if (self = [super init]) {
        self.type = HYPhotoModelMediaTypeCameraVideo;
        self.subType = HYPhotoModelMediaSubTypeVideo;
        self.videoURL = videoURL;
        if (videoTime <= 0) {
            videoTime = 1;
        }
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL] ;
        player.shouldAutoplay = NO;
        UIImage  *image = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
        NSString *time = [HYPhotoTools getNewTimeFromDurationSecond:videoTime];
        self.videoDuration = videoTime;
        self.videoURL = videoURL;
        self.videoTime = time;
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = self.thumbPhoto.size;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.type = HYPhotoModelMediaTypeCameraPhoto;
        self.subType = HYPhotoModelMediaSubTypePhoto;
//        if (image.imageOrientation != UIImageOrientationUp) {
//            image = [image normalizedImage];
//        }
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = image.size;
    }
    return self;
}

- (CGSize)imageSize
{
    if (_imageSize.width == 0 || _imageSize.height == 0) {
        if (self.asset) {
            if (self.asset.pixelWidth == 0 || self.asset.pixelHeight == 0) {
                _imageSize = CGSizeMake(200, 200);
            }else {
                _imageSize = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
            }
        }else {
            _imageSize = self.thumbPhoto.size;
        }
    }
    return _imageSize;
}
- (NSString *)videoTime {
    if (!_videoTime) {
        NSString *timeLength = [NSString stringWithFormat:@"%0.0f",self.asset.duration];
        _videoTime = [HYPhotoTools getNewTimeFromDurationSecond:timeLength.integerValue];
    }
    return _videoTime;
}
- (CGSize)endImageSize
{
    if (_endImageSize.width == 0 || _endImageSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - KHYHiddenStatusNavbarHeight;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / self.imageSize.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        _endImageSize = CGSizeMake(w, h);
    }
    return _endImageSize;
}
- (CGSize)previewViewSize {
    if (_previewViewSize.width == 0 || _previewViewSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        
        if (imgWidth > width) {
            h = width / self.imageSize.width * imgHeight;
            w = width;
        }else {
            w = width;
            h = width / imgWidth * imgHeight;
        }
        if (h > height + 20) {
            h = height;
        }
        _previewViewSize = CGSizeMake(w, h);
    }
    return _previewViewSize;
}
- (CGSize)endDateImageSize {
    if (_endDateImageSize.width == 0 || _endDateImageSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;

        CGFloat height = [UIScreen mainScreen].bounds.size.height - KHYHiddenStatusNavbarHeight - 20;
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
//            if (HYISIPhoneX) {
//                height = [UIScreen mainScreen].bounds.size.height - hyTopMargin - 21;
//            }
//        }
        
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / self.imageSize.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        _endDateImageSize = CGSizeMake(w, h);
    }
    return _endDateImageSize;
}
- (CGSize)requestSize {
    return CGSizeMake((KHYScreenWidth - 3) / 4 * self.clarityScale,(KHYScreenWidth - 3) / self.rowCount * self.clarityScale);
}
- (CGSize)dateBottomImageSize {
    if (_dateBottomImageSize.width == 0 || _dateBottomImageSize.height == 0) {
        CGFloat width = 0;
        CGFloat height = 50;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        if (imgHeight > height) {
            width = imgWidth * (height / imgHeight);
        }else {
            width = imgWidth * (imgHeight / height);
        }
        if (width < 50 / 16 * 9) {
            width = 50 / 16 * 9;
        }
        _dateBottomImageSize = CGSizeMake(width, height);
    }
    return _dateBottomImageSize;
}

- (void)dealloc {
    if (self.iCloudRequestID) {
        if (self.iCloudDownloading) {
            [[PHImageManager defaultManager] cancelImageRequest:self.iCloudRequestID];
        }
    }
    //    [self cancelImageRequest];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.thumbPhoto = [aDecoder decodeObjectForKey:@"thumbPhoto"];
        self.previewPhoto = [aDecoder decodeObjectForKey:@"previewPhoto"];
        self.localIdentifier = [aDecoder decodeObjectForKey:@"localIdentifier"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.subType = [aDecoder decodeIntegerForKey:@"subType"];
        self.videoDuration = [aDecoder decodeFloatForKey:@"videoDuration"];
        self.selected = [aDecoder decodeBoolForKey:@"selected"];
        self.videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
        self.networkPhotoUrl = [aDecoder decodeObjectForKey:@"networkPhotoUrl"];
        self.creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
        self.modificationDate = [aDecoder decodeObjectForKey:@"modificationDate"];
        self.videoTime = [aDecoder decodeObjectForKey:@"videoTime"];
        self.selectIndexStr = [aDecoder decodeObjectForKey:@"videoTime"];
        self.cameraIdentifier = [aDecoder decodeObjectForKey:@"cameraIdentifier"];
        self.fileURL = [aDecoder decodeObjectForKey:@"fileURL"];
        self.gifImageData = [aDecoder decodeObjectForKey:@"gifImageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbPhoto forKey:@"thumbPhoto"];
    [aCoder encodeObject:self.previewPhoto forKey:@"previewPhoto"];
    [aCoder encodeObject:self.localIdentifier forKey:@"localIdentifier"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeInteger:self.subType forKey:@"subType"];
    [aCoder encodeFloat:self.videoDuration forKey:@"videoDuration"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
    [aCoder encodeObject:self.networkPhotoUrl forKey:@"networkPhotoUrl"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.modificationDate forKey:@"modificationDate"];
    [aCoder encodeObject:self.videoTime forKey:@"videoTime"];
    [aCoder encodeObject:self.selectIndexStr forKey:@"selectIndexStr"];
    [aCoder encodeObject:self.cameraIdentifier forKey:@"cameraIdentifier"];
    [aCoder encodeObject:self.fileURL forKey:@"fileURL"];
    [aCoder encodeObject:self.gifImageData forKey:@"gifImageData"];
}

@end


