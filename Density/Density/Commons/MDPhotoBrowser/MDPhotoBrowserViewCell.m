//
//  MDPhotoBrowserViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDPhotoBrowserViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"
#import "HYVideoPlayView.h"

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
//    self.playView = [HYVideoPlayView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.hy_width, self.contentView.hy_height) url:<#(nonnull NSURL *)#> context:<#(nonnull HYVideoPlayContext *)#>
//    []
}


- (void)setModel:(MDPhotoBrowserModel *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlString]];
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end

NSString * _Nonnull const MDPhotoBrowserViewCellID = @"MDPhotoBrowserViewCellID";
