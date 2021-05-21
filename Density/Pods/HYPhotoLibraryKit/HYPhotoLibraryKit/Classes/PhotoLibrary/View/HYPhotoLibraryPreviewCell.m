//
//  HYPhotoLibraryPreviewCell.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/22.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryPreviewCell.h"
#import "HYCircleProgressView.h"
#import "HYPhotoModel.h"
#import "UIImageView+HYExtension.h"
#import "HYPhotoTools.h"
#import "HYUtilsDeviceMacro.h"


@interface HYPhotoLibraryPreviewCell()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic ,readwrite) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifImage;
@property (strong, nonatomic) UIImage *gifFirstFrame;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (strong, nonatomic) HYCircleProgressView *progressView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation HYPhotoLibraryPreviewCell

#pragma mark ----- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestID = -1;
        [self setup];
    }
    return self;
}

#pragma mark ----- 设置
- (void)setup {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.loadingView];
}

#pragma mark ----- 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    self.progressView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.loadingView.center = self.progressView.center;
}


#pragma mark ----- 设置scrollViewScale
- (void)resetScale {
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)againAddImageView {
    [self refreshImageSize];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark ----- 设置model
- (void)setModel:(HYPhotoModel *)model {
    _model = model;
    [self cancelRequest];
    self.progressView.hidden = YES;
    [self.loadingView stopAnimating];
    self.progressView.progress = 0;
    [self resetScale];
    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
    self.imageView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    if (model.type == HYPhotoModelMediaTypeLivePhoto) {
        if (model.tempImage) {
            self.imageView.image = model.tempImage;
            model.tempImage = nil;
        }else {
            self.requestID = [HYPhotoTools getPhotoForPHAsset:model.asset size:CGSizeMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5) completion:^(UIImage *image, NSDictionary *info) {
                weakSelf.imageView.image = image;
            }];
        }
    }else {
        if (model.previewPhoto) {
            self.imageView.image = model.previewPhoto;
            model.tempImage = nil;
        }else {
            if (model.tempImage) {
                self.imageView.image = model.tempImage;
                model.tempImage = nil;
            }else {
                PHImageRequestID requestID;
                if (imgHeight > imgWidth / 9 * 17) {
                    requestID = [HYPhotoTools getPhotoForPHAsset:model.asset size:CGSizeMake(self.bounds.size.width * 0.6, self.bounds.size.height * 0.6) completion:^(UIImage *image, NSDictionary *info) {
                        weakSelf.imageView.image = image;
                    }];
                }else {
                    requestID = [HYPhotoTools getPhotoForPHAsset:model.asset size:CGSizeMake(model.endImageSize.width * 0.8, model.endImageSize.height * 0.8) completion:^(UIImage *image, NSDictionary *info) {
                        weakSelf.imageView.image = image;
                    }];
                }
                self.requestID = requestID;
            }
        }
    }
}

#pragma mark ----- 刷新ImageSize
- (void)refreshImageSize {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }

    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
}

#pragma mark ----- 请求HDImage
- (void)requestHDImage {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    
    CGSize size;
    __weak typeof(self) weakSelf = self;
    CGFloat scale;
    if (KHYISIPhoneX) {
        scale = 3.0f;
    }else if ([UIScreen mainScreen].bounds.size.width == 320) {
        scale = 2.0;
    }else if ([UIScreen mainScreen].bounds.size.width == 375) {
        scale = 2.5;
    }else {
        scale = 3.0;
    }
    
    if (imgHeight > imgWidth / 9 * 17) {
        size = CGSizeMake(width * 1.5, height * 1.5);
    }else {
        size = CGSizeMake(self.model.endImageSize.width * scale, self.model.endImageSize.height * scale);
    }
    
    /** 请求原题 */
    self.requestID = [HYPhotoTools getHighQualityFormatPhoto:self.model.asset size:size startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        if (weakSelf.model.isICloud) {
            weakSelf.progressView.hidden = NO;
        }
        weakSelf.requestID = cloudRequestId;
    } progressHandler:^(double progress) {
        if (weakSelf.model.isICloud) {
            weakSelf.progressView.hidden = NO;
        }
        weakSelf.progressView.progress = progress;
    } completion:^(UIImage *image,NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf downloadICloudAssetComplete];
            weakSelf.progressView.hidden = YES;
            weakSelf.imageView.image = image;
        });
    } failed:^(NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.hidden = YES;
        });
    }];
}

#pragma mark ----- 下载icloud完成
- (void)downloadICloudAssetComplete {
    self.progressView.hidden = YES;
    [self.loadingView stopAnimating];
    if (self.model.isICloud) {
        self.model.iCloudDownloading = NO;
        self.model.isICloud = NO;
        if (self.cellDownloadICloudAssetComplete) {
            self.cellDownloadICloudAssetComplete(self);
        }
    }
}

#pragma mark ----- 取消下载
- (void)cancelRequest {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
}

#pragma mark ----- 双击
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGPoint touchPoint;
        touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.cellTapClick) {
        self.cellTapClick();
    }
}

#pragma mark ----- scrollView代理方法
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark ----- 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_scrollView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [_scrollView addGestureRecognizer:tap2];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (HYCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HYCircleProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_loadingView stopAnimating];
    }
    return _loadingView;
}

- (void)dealloc {
    [self cancelRequest];
}

@end
