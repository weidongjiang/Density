//
//  HYAlbumCell.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/18.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYAlbumCell.h"
#import "HYPhotoTools.h"
#import "UIColor+HYUtilities.h"
#import "HYUtilitiesTools.h"
#import "UIView+HYFrame.h"
#import "HYUtilsDeviceMacro.h"

#define ABLUMSQUAREWIDTH 50.0f


@interface HYAlbumCell()

@property (nonatomic,strong) UIImageView *albumImageView;
@property (nonatomic,strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) HYAlbumModel   *albumModel;
@end
@implementation HYAlbumCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor hy_colorLightWithLightHex:@"0xFFFFFF" colorDark:@"0x000000"];
        
        CGFloat HYAlbumCell_h = 74;
        CGFloat albumImageView_w = 50;
        CGFloat albumImageView_h = 50;
        CGFloat albumImageView_x = 16;
        CGFloat albumImageView_y = (HYAlbumCell_h - albumImageView_h) * 0.5;
        self.albumImageView.frame = CGRectMake(albumImageView_x, albumImageView_y, albumImageView_w, albumImageView_h);
        [self.contentView addSubview:self.albumImageView];
        
        CGFloat albumNameLabel_w = 200;
        CGFloat albumNameLabel_h = 30;
        CGFloat albumNameLabel_x = albumImageView_x + albumImageView_w + 8;
        CGFloat albumNameLabel_y = (HYAlbumCell_h - albumNameLabel_h) * 0.5;
        self.albumNameLabel.frame = CGRectMake(albumNameLabel_x, albumNameLabel_y, albumNameLabel_w, albumNameLabel_h);
        [self.contentView addSubview:self.albumNameLabel];
        
       
        CGFloat countLabel_w = 50;
        CGFloat countLabel_h = 20;
        CGFloat countLabel_x = albumNameLabel_x + albumNameLabel_w + 8;
        CGFloat countLabel_y = self.albumNameLabel.hy_y;
        self.countLabel.frame = CGRectMake(countLabel_x, countLabel_y, countLabel_w, countLabel_h);
        [self.contentView addSubview:self.countLabel];
        
        
        CGFloat lineView_w = KHYScreenWidth;
        CGFloat lineView_h = 0.5;
        CGFloat lineView_x = 0;
        CGFloat lineView_y = HYAlbumCell_h - lineView_h;
        self.lineView.frame = CGRectMake(lineView_x, lineView_y, lineView_w, lineView_h);
        [self.contentView addSubview:self.lineView];
 
    }
    return self;
}

#pragma mark ----- 设置数据
- (void)configCellWithAlbumModel:(HYAlbumModel *)albumModel
{
    _albumModel = albumModel;
    if (!albumModel.asset) {
        id asset = albumModel.result.firstObject;
        if (asset) {
            albumModel.asset = asset;
        }else{
            return;
        }
    }
    __weak typeof(self) weakSelf = self;
    [HYPhotoTools getImageWithAlbumModel:albumModel size:CGSizeMake(ABLUMSQUAREWIDTH * 2.0, ABLUMSQUAREWIDTH * 2.0) completion:^(UIImage *image, HYAlbumModel *model) {
        if (!image || !model) {return;}
        if (weakSelf.albumModel == model) {
            weakSelf.albumImageView.image = image;
        }
    }];
    
    self.albumNameLabel.text  = albumModel.albumName;
    self.countLabel.text = [NSString stringWithFormat:@"%tu",albumModel.count];
    
    CGFloat albumNameLabel_w = [HYUtilitiesTools sizeWithFont:self.albumNameLabel.font string:self.albumNameLabel.text].width;
    self.albumNameLabel.hy_width = albumNameLabel_w;
    
    CGFloat countLabel_x = self.albumNameLabel.hy_x + self.albumNameLabel.hy_width + 8;
    self.countLabel.hy_x = countLabel_x;
}




#pragma mark ----- 懒加载
- (UIImageView *)albumImageView
{
    if (_albumImageView == nil) {
        _albumImageView = [[UIImageView alloc] init];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
    }
    return _albumImageView;
}

- (UILabel *)albumNameLabel
{
    if (_albumNameLabel == nil) {
        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _albumNameLabel.textColor = [UIColor hy_colorWithColorLight:[UIColor blackColor] dark:[UIColor whiteColor]];
    }
    return _albumNameLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _countLabel.textColor = [UIColor hy_colorWithColorLight:[UIColor blackColor] dark:[UIColor whiteColor]];
    }
    return _countLabel;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor hy_rgbColorLightR:229 lightG:229 lightB:229 lightA:0.6 darkR:15 darkG:14 darkB:31 darkA:0.3];
    }
    return _lineView;
}
@end
