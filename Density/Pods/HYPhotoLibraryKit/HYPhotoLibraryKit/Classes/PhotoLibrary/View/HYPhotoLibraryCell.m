//
//  HYPhotoLibraryCell.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/17.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryCell.h"
#import "HYPhotoDownloadProgressView.h"
#import "HYCircleProgressView.h"
#import "HYPhotoModel.h"
#import "UIImageView+HYExtension.h"
#import "HYPhotoTools.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIView+HYFrame.h"
#import "SDWebImage.h"
#import "UIImage+HYBundleImage.h"

@interface HYPhotoLibraryCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *maskView;
@property (copy, nonatomic) NSString *localIdentifier;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (assign, nonatomic) PHImageRequestID iCloudRequestID;
@property (strong, nonatomic) UIImageView *iCloudIcon;
@property (nonatomic,strong) UIImageView *selectBackgroundImageView;
@property (strong, nonatomic) CALayer *iCloudMaskLayer;
@property (strong, nonatomic) CAGradientLayer *bottomMaskLayer;
// 标识的label
@property (nonatomic,strong) UILabel *stateLabel;
@property (strong, nonatomic) HYPhotoDownloadProgressView *downloadView;
@property (strong, nonatomic) HYCircleProgressView *progressView;
@end
@implementation HYPhotoLibraryCell

#pragma mark ----- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark ----- 设置UI
- (void)setupUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.downloadView];
    [self.contentView addSubview:self.progressView];
}

#pragma mark ----- 视图布局时
- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectMaskLayer.frame = self.bounds;
    self.iCloudMaskLayer.frame = self.bounds;
    self.bottomMaskLayer.frame = CGRectMake(0, self.bounds.size.height - 25, self.bounds.size.width, 25);
}

#pragma mark ----- 转场使用
- (void)bottomViewPrepareAnimation {
    self.maskView.alpha = 0;
}

- (void)bottomViewStartAnimation {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 1;
    } completion:nil];
}

#pragma mark ----- 设置单选
- (void)setSingleSelected:(BOOL)singleSelected {
    _singleSelected = singleSelected;
    if (singleSelected) {
        [self.selectBtn removeFromSuperview];
        [self.selectBackgroundImageView removeFromSuperview];
    }
}

#pragma mark ----- 设置数据
- (void)setModel:(HYPhotoModel *)model {
    _model = model;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    __weak typeof(self) weakSelf = self;
    if (model.type == HYPhotoModelMediaTypeCameraPhoto || model.type == HYPhotoModelMediaTypeCameraVideo) {
        if (model.networkPhotoUrl) {
            self.progressView.hidden = model.downloadComplete;
            CGFloat progress = (CGFloat)model.receivedSize / model.expectedSize;
            self.progressView.progress = progress;
            [self.imageView hy_setImageWithModel:model progress:^(CGFloat progress, HYPhotoModel *model) {
                if (weakSelf.model == model) {
                    weakSelf.progressView.progress = progress;
                }
            } completed:^(UIImage *image, NSError *error, HYPhotoModel *model) {
                if (weakSelf.model == model) {
                    if (error != nil) {
                        [weakSelf.progressView showError];
                    }else {
                        if (image) {
                            weakSelf.progressView.progress = 1;
                            weakSelf.progressView.hidden = YES;
                            weakSelf.imageView.image = image;
                        }
                    }
                }
            }];
        }else {
            self.imageView.image = model.thumbPhoto;
        }
    }else {
        if (!self.imageView.image) {
            self.imageView.hidden = YES;
            self.imageView.alpha = 0;
            self.maskView.hidden = YES;
            self.maskView.alpha = 0;
        }
        self.imageView.image = nil;
        PHImageRequestID requestID = [HYPhotoTools getImageWithModel:model completion:^(UIImage *image, HYPhotoModel *model) {
            if (weakSelf.model == model) {
                weakSelf.imageView.image = image;
                if (weakSelf.maskView.hidden) {
                    weakSelf.imageView.hidden = NO;
                    weakSelf.maskView.hidden = NO;
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.maskView.alpha = 1;
                        weakSelf.imageView.alpha = 1;
                    }];
                }
            }
        }];
        self.requestID = requestID;
    }
    if (model.type == HYPhotoModelMediaTypePhotoGif) {
        self.stateLabel.text = @"GIF";
        self.stateLabel.hidden = NO;
        self.bottomMaskLayer.hidden = NO;
    }else if (model.type == HYPhotoModelMediaTypeLivePhoto) {
//        self.stateLabel.text = @"Live";
//        self.stateLabel.hidden = NO;
    }else {
        if (model.subType == HYPhotoModelMediaSubTypeVideo) {
            self.stateLabel.text = model.videoTime;
            self.stateLabel.hidden = NO;
        }else {
            if (model.networkPhotoUrl) {
                if ([[model.networkPhotoUrl.absoluteString substringFromIndex:model.networkPhotoUrl.absoluteString.length - 3] isEqualToString:@"gif"]) {
                    self.stateLabel.text = @"GIF";
                    self.stateLabel.hidden = NO;
                    self.bottomMaskLayer.hidden = NO;
                }else {
                    self.stateLabel.hidden = YES;
                    self.bottomMaskLayer.hidden = YES;
                }
            }else {
                self.stateLabel.hidden = YES;
                self.bottomMaskLayer.hidden = YES;
            }
        }
    }
    self.selectMaskLayer.hidden = !model.selected;
    self.selectBtn.selected = model.selected;
    [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
    self.selectBtn.backgroundColor = model.selected ? self.selectBgColor :nil;
    self.iCloudIcon.hidden = !model.isICloud;
    self.iCloudMaskLayer.hidden = !model.isICloud;
    
    // 当前是否需要隐藏选择按钮
    if (model.needHideSelectBtn) {
        self.selectBackgroundImageView.hidden = YES;
        self.selectBtn.hidden = YES;
        self.selectBtn.userInteractionEnabled = NO;
    }else {
        self.selectBackgroundImageView.hidden = model.isICloud;
        self.selectBtn.hidden = model.isICloud;
        self.selectBtn.userInteractionEnabled = !model.isICloud;
    }
    
    if (model.isICloud) {
        self.userInteractionEnabled = YES;
    }
    
    if (model.iCloudDownloading) {
        if (model.isICloud) {
            self.downloadView.progress = model.iCloudProgress;
            [self startRequestICloudAsset];
        }else {
            model.iCloudDownloading = NO;
            self.downloadView.hidden = YES;
        }
    }else {
        self.downloadView.hidden = YES;
    }
}

#pragma mark ----- 请求icloud数据
- (void)startRequestICloudAsset {
    self.downloadView.hidden = NO;
    self.downloadView.alpha = 1.0f;
    [self.downloadView startAnima];
    self.iCloudIcon.hidden = YES;
    self.iCloudMaskLayer.hidden = YES;
    __weak typeof(self) weakSelf = self;
    if (self.model.type == HYPhotoModelMediaTypeVideo) {
        self.iCloudRequestID = [HYPhotoTools getAVAssetWithModel:self.model startRequestIcloud:^(HYPhotoModel *model, PHImageRequestID cloudRequestId) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.iCloudRequestID = cloudRequestId;
            }
        } progressHandler:^(HYPhotoModel *model, double progress) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.downloadView.progress = progress;
            }
        } completion:^(HYPhotoModel *model, AVAsset *asset) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.progress = 1;
                if ([weakSelf.delegate respondsToSelector:@selector(photoLibraryCellRequestICloudAssetComplete:)]) {
                    [weakSelf.delegate photoLibraryCellRequestICloudAssetComplete:weakSelf];
                }
            }
        } failed:^(HYPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model == model) {
                [weakSelf downloadError:info];
            }
        }];
    }else if (self.model.type == HYPhotoModelMediaTypeLivePhoto){
        self.iCloudRequestID = [HYPhotoTools getLivePhotoWithModel:self.model size:CGSizeMake(self.model.previewViewSize.width * 1.5, self.model.previewViewSize.height * 1.5) startRequestICloud:^(HYPhotoModel *model, PHImageRequestID iCloudRequestId) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.iCloudRequestID = iCloudRequestId;
            }
        } progressHandler:^(HYPhotoModel *model, double progress) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.downloadView.progress = progress;
            }
        } completion:^(HYPhotoModel *model, PHLivePhoto *livePhoto) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.progress = 1;
                if ([weakSelf.delegate respondsToSelector:@selector(photoLibraryCellRequestICloudAssetComplete:)]) {
                    [weakSelf.delegate photoLibraryCellRequestICloudAssetComplete:weakSelf];
                }
            }
        } failed:^(HYPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model == model) {
                [weakSelf downloadError:info];
            }
        }];
    }else {
        self.iCloudRequestID = [HYPhotoTools getImageDataWithModel:self.model startRequestIcloud:^(HYPhotoModel *model, PHImageRequestID cloudRequestId) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.downloadView.progress = 0;
                weakSelf.iCloudRequestID = cloudRequestId;
            }
        } progressHandler:^(HYPhotoModel *model, double progress) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.hidden = NO;
                weakSelf.downloadView.progress = progress;
            }
        } completion:^(HYPhotoModel *model, NSData *imageData, UIImageOrientation orientation) {
            if (weakSelf.model == model) {
                weakSelf.downloadView.progress = 1;
                if ([weakSelf.delegate respondsToSelector:@selector(photoLibraryCellRequestICloudAssetComplete:)]) {
                    [weakSelf.delegate photoLibraryCellRequestICloudAssetComplete:weakSelf];
                }
            }
        } failed:^(HYPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model == model) {
                [weakSelf downloadError:info];
            }
        }];
    }
}


#pragma mark ----- 下载失败处理
- (void)downloadError:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;

    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
        NSLog(@"下载失败，请重试");
    }
    if ([weakSelf.delegate respondsToSelector:@selector(photoLibraryCellRequestICloudAssetError:)]) {
        [weakSelf.delegate photoLibraryCellRequestICloudAssetError:weakSelf];
    }
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.downloadView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        weakSelf.downloadView.hidden = YES;
    }];
    [weakSelf.downloadView resetState];
    weakSelf.iCloudIcon.hidden = !self.model.isICloud;
    weakSelf.iCloudMaskLayer.hidden = !self.model.isICloud;
}


- (void)cancelRequest {
    [self.imageView sd_cancelCurrentImageLoad];
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    if (self.iCloudRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.iCloudRequestID];
        self.iCloudRequestID = -1;
    }
}


- (void)dealloc {
    self.model.dateCellIsVisible = NO;
}

- (void)updateItemdidSelect:(BOOL)startIndexisSelect {
    [self didSelectClick:self.selectBtn];
}

- (void)updateRangeItemdidSelect:(BOOL)startIndexisSelect {
    
//    [self didSelectClick:self.selectBtn];
}

#pragma mark ----- 选择按钮点击方法
- (void)didSelectClick:(UIButton *)button {
    if ([[self.model.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        if ([self.delegate respondsToSelector:@selector(photoLibraryCellDidSelectGIF)]) {
            [self.delegate photoLibraryCellDidSelectGIF];
            return;
        }
    }
    if (self.model.type == HYPhotoModelMediaTypeCamera) {
        return;
    }
    if (self.model.isICloud) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(photoLibraryCell:didSelectBtn:)]) {
        [self.delegate photoLibraryCell:self didSelectBtn:button];
    }
}
- (void)didSelectBackGroundClick{
    [self didSelectClick:self.selectBtn];
}
#pragma mark - < 懒加载 >

- (HYPhotoDownloadProgressView *)downloadView {
    if (!_downloadView) {
        _downloadView = [[HYPhotoDownloadProgressView alloc] initWithFrame:self.bounds];
    }
    return _downloadView;
}

- (HYCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HYCircleProgressView alloc] initWithFrame:CGRectMake((self.hy_width - 50) * 0.5, (self.hy_height - 50) * 0.5, 50, 50)];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.hy_width, self.hy_height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
//        _imageView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    }
    return _imageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.hy_width, self.hy_height)];
        [_maskView.layer addSublayer:self.bottomMaskLayer];
        [_maskView.layer addSublayer:self.selectMaskLayer];
        [_maskView.layer addSublayer:self.iCloudMaskLayer];
        [_maskView addSubview:self.iCloudIcon];
        [_maskView addSubview:self.selectBtn];
        [_maskView addSubview:self.stateLabel];
        [_maskView insertSubview:self.selectBackgroundImageView belowSubview:self.selectBtn];

    }
    return _maskView;
}

- (UIImageView *)iCloudIcon {
    if (!_iCloudIcon) {
        _iCloudIcon = [[UIImageView alloc] initWithImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_icloud_yun" bundleName:@"HYPhotoLibraryKit"]];
        _iCloudIcon.frame = CGRectMake(self.hy_width - 6 - 20, 2, 20, 20);
    }
    return _iCloudIcon;
}

- (CALayer *)selectMaskLayer {
    if (!_selectMaskLayer) {
        _selectMaskLayer = [CALayer layer];
        _selectMaskLayer.hidden = YES;
        _selectMaskLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _selectMaskLayer;
}

- (CALayer *)iCloudMaskLayer {
    if (!_iCloudMaskLayer) {
        _iCloudMaskLayer = [CALayer layer];
        _iCloudMaskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _iCloudMaskLayer;
}

- (CAGradientLayer *)bottomMaskLayer {
    if (!_bottomMaskLayer) {
        _bottomMaskLayer = [CAGradientLayer layer];
        _bottomMaskLayer.colors = @[
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                    (id)[[UIColor blackColor] colorWithAlphaComponent:0.35].CGColor
                                    ];
        _bottomMaskLayer.startPoint = CGPointMake(0, 0);
        _bottomMaskLayer.endPoint = CGPointMake(0, 1);
        _bottomMaskLayer.locations = @[@(0.15f),@(0.9f)];
        _bottomMaskLayer.borderWidth  = 0.0;
    }
    return _bottomMaskLayer;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(self.hy_width - 6 - 22, 6, 22, 22);
        [_selectBtn setBackgroundImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_ximg_CheckBox" bundleName:@"HYPhotoLibraryKit"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _selectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:30 left:30];
        _selectBtn.layer.cornerRadius = 11;
    }
    return _selectBtn;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hy_height - 18, self.hy_width - 4, 18)];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateLabel;
}

- (UIImageView *)selectBackgroundImageView
{
    if (_selectBackgroundImageView == nil) {
        _selectBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_img_touming" bundleName:@"HYPhotoLibraryKit"]];
        _selectBackgroundImageView.frame = CGRectMake(self.hy_width - 36, 0, 36, 36);
        _selectBackgroundImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectBackGroundClick)];
        [_selectBackgroundImageView addGestureRecognizer:reg];
     }
    return _selectBackgroundImageView;
}
@end
