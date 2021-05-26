//
//  MDPhotoBrowserViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDPhotoBrowserViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"

@interface MDPhotoBrowserViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HYVideoPlayView *playView;
@end

@implementation MDPhotoBrowserViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
    }];

    [self.contentView setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    
}


- (void)setModel:(MDPhotoBrowserModel *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlString]];
    if (model.type == MDPhotoBrowserModelTypeVideo) {
        HYVideoPlayContext *context = [[HYVideoPlayContext alloc] init];
        context.isShowSliderView = NO;
        context.isLoopPlay = NO;
        context.isAutoPlay = NO;
        [[MDPhotoBrowserViewPlayManager sharedManager] initPlayViewWithFrame:self.contentView.bounds url:[NSURL URLWithString:model.videoUrlString] context:context superView:self.contentView];
        [[MDPhotoBrowserViewPlayManager sharedManager] pause];
    }else {
        
    }
}

- (void)updateVisibleCellsPlay:(BOOL)isPlay {
    if (self.model.type == MDPhotoBrowserModelTypeVideo) {
        if (isPlay) {
            [[MDPhotoBrowserViewPlayManager sharedManager] play];
        }else {
            [[MDPhotoBrowserViewPlayManager sharedManager] pause];
        }
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end

NSString * _Nonnull const MDPhotoBrowserViewCellID = @"MDPhotoBrowserViewCellID";
