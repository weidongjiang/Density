//
//  HYAlbumPopView.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/18.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYAlbumPopView.h"
#import "HYAlbumModel.h"
#import "HYAlbumCell.h"
#import "UIButton+EnlargeTouchArea.h"
#import "HYUtilsDeviceMacro.h"
#import "UIColor+HYUtilities.h"
#import "HYUtilsMacro.h"
#import "UIImage+HYBundleImage.h"
#import "UIImage+HYImage.h"
#import "UIView+HYFrame.h"
#import "HYUtilitiesTools.h"

#define cellHeight 74.0f
#define backgroundViewAlpha 0.5f
@interface HYAlbumPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *albumTableView;
@property (nonatomic,strong) NSArray *albumArray;
@property (nonatomic,strong) UIView *wrapperView;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIView *tableViewContainerView;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,assign) BOOL isMenuShow;

@end
@implementation HYAlbumPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
    }
    return self;
}

#pragma mark ----- 设置数据
- (void)setAlbumsArray:(NSArray *)albumsArray
{
    _albumArray = albumsArray;
    [self.albumTableView reloadData];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        
        CGFloat titleView_w = KHYScreenWidth - 150;
        CGFloat titleView_h = 40;
        CGFloat titleView_x = (self.hy_width - titleView_w)*0.5;
        CGFloat titleView_y = 0;
        self.titleView = [[UIView alloc] init];
        self.titleView.frame = CGRectMake(titleView_x, titleView_y, titleView_w, titleView_h);
        [self addSubview:self.titleView];
        
        
        UIButton *titleBtn = [[UIButton alloc] init];
        _titleBtn = titleBtn;
        titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        titleBtn.userInteractionEnabled = YES;
        titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        UIColor *color = [UIColor hy_rgbColorLightR:51 lightG:51 lightB:51 lightA:1 darkR:255 darkG:255 darkB:255 darkA:1];
        [titleBtn setTitleColor:color forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(tapTitleView) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        
        CGFloat titleBtn_h = 18;
        CGFloat titleBtn_w = self.titleView.hy_width;
        CGFloat titleBtn_x = 0;
        CGFloat titleBtn_y = 6;
        titleBtn.frame = CGRectMake(titleBtn_x, titleBtn_y, titleBtn_w, titleBtn_h);
        [self.titleView addSubview:titleBtn];
        
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.text = @"轻触更改相册";
        subLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        subLabel.textColor = [UIColor hy_rgbColorLightR:51 lightG:51 lightB:51 lightA:1 darkR:255 darkG:255 darkB:255 darkA:1];
        
        CGFloat subLabel_h = 10;
        CGFloat subLabel_w = [HYUtilitiesTools sizeWithFont:subLabel.font string:subLabel.text].width;
        CGFloat subLabel_x = (self.titleView.hy_width - subLabel_w)*0.5;
        CGFloat subLabel_y = titleBtn.hy_y + titleBtn.hy_height + 2;
        subLabel.frame = CGRectMake(subLabel_x, subLabel_y, subLabel_w, subLabel_h);
        [self.titleView addSubview:subLabel];
        
     
        CGFloat arrowImageView_h = 9;
        CGFloat arrowImageView_w = 9;
        CGFloat arrowImageView_x = subLabel.hy_x - 0.5 - arrowImageView_w;
        CGFloat arrowImageView_y = subLabel.hy_y - (subLabel.hy_height - arrowImageView_h)*0.5;
        self.arrowImageView.frame = CGRectMake(arrowImageView_x, arrowImageView_y, arrowImageView_w, arrowImageView_h);
        [self.titleView addSubview:self.arrowImageView];
        
       
        CGFloat wrapperView_w = KHYScreenWidth;
        CGFloat wrapperView_h = KHYScreenHeight - KHYHiddenStatusNavbarHeight;
        CGFloat wrapperView_x = 0;
        CGFloat wrapperView_y = KHYHiddenStatusNavbarHeight;
        self.wrapperView.frame = CGRectMake(wrapperView_x, wrapperView_y, wrapperView_w, wrapperView_h);
        [self.window addSubview:self.wrapperView];
        
        self.backgroundView.frame = CGRectMake(0, 0, self.wrapperView.hy_width, self.wrapperView.hy_height);
        [self.wrapperView addSubview:self.backgroundView];
           
        
        CGFloat tableCellsHeight = cellHeight * 6;
        CGFloat tableViewContainerView_y = - cellHeight * 6 - 30;
        self.tableViewContainerView.frame = CGRectMake(0, tableViewContainerView_y, self.wrapperView.hy_width, tableCellsHeight + 30);
        [self.wrapperView addSubview:self.tableViewContainerView];
   
        self.albumTableView.frame = CGRectMake(0, 0, self.tableViewContainerView.hy_width, cellHeight * 6);
        [self.tableViewContainerView addSubview:self.albumTableView];
 
        self.wrapperView.hidden = NO;
    }else{
        // 避免不能销毁的问题
        [self.wrapperView removeFromSuperview];
    }
    

}
#pragma mark ----- 展示
- (void)showMenu{
    self.titleBtn.enabled = NO;
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.alpha = 0.0f;
    self.wrapperView.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
        self.tableViewContainerView.hy_y = 0;
                         [self.tableViewContainerView.superview layoutSubviews];
        self.backgroundView.alpha = backgroundViewAlpha;
        self.titleBtn.enabled = YES;
        self.backgroundView.userInteractionEnabled = YES;
    }];
}

- (void)setTitleContent : (NSString *)content{
    [self.titleBtn setTitle:content forState:UIControlStateNormal];
}


#pragma mark ----- 关闭
- (void)hideMenu
{
    self.titleBtn.enabled = NO;
    self.backgroundView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
                            self.tableViewContainerView.hy_y =  - cellHeight * 6 - 30;
                         [self.tableViewContainerView.superview layoutSubviews];
    } completion:^(BOOL finished) {
        self.wrapperView.hidden = YES;
        [self.albumTableView reloadData];
        self.titleBtn.enabled = YES;
        self.backgroundView.userInteractionEnabled = YES;
    }];
}


- (void)dissmissMenu{
    self.wrapperView.hidden = YES;
}
#pragma mark ----- 点击titleView
- (void)tapTitleView
{
    self.isMenuShow = !self.isMenuShow;
    HYDebugLog(@"%tu展示",self.isMenuShow);
}
- (void)setIsMenuShow:(BOOL)isMenuShow
{
    if (_isMenuShow != isMenuShow)
    {
        _isMenuShow = isMenuShow;
        
        if (isMenuShow)
        {
            [self showMenu];
        }
        else
        {
            [self hideMenu];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellId" forIndexPath:indexPath];
    HYAlbumModel *albumModel = [self.albumArray objectAtIndex:indexPath.row];
    [cell configCellWithAlbumModel:albumModel];
    return cell;
}

#pragma mark -- UITableViewDataDelegate --

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedAtIndex)
    {
        [self setIsMenuShow:NO];
        self.selectedAtIndex((int)indexPath.row);
    }
}

#pragma mark ----- 懒加载
- (UITableView *)albumTableView
{
    if (_albumTableView == nil) {
        _albumTableView = [[UITableView alloc] init];
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        _albumTableView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:0 darkA:1];
        _albumTableView.tableFooterView = [[UIView alloc] init];
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_albumTableView registerClass:[HYAlbumCell class] forCellReuseIdentifier:@"albumCellId"];
        
    }
    return _albumTableView;
}

- (UIView *)wrapperView
{
    if (_wrapperView == nil)
    {
        _wrapperView = [[UIView alloc] init];
        _wrapperView.clipsToBounds = YES;

    }
    
    return _wrapperView;
}
- (UIView *)tableViewContainerView
{
    if (_tableViewContainerView == nil)
    {
        _tableViewContainerView = [[UIView alloc] init];
        _tableViewContainerView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:0 darkA:1];
    }
    return _tableViewContainerView;
}
- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleView)];
        [_backgroundView addGestureRecognizer:reg];
        _backgroundView.alpha = backgroundViewAlpha;
    }
    
    return _backgroundView;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil)
    {
        _arrowImageView = [[UIImageView alloc] init];
         UIImage *image = [UIImage hy_imageLightImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_imgarr_xia" bundleName:@"HYPhotoLibraryKit"] darkImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_imgarr_xia_black" bundleName:@"HYPhotoLibraryKit"]];
        [_arrowImageView setImage:image];
    }
    return _arrowImageView;
}

@end
