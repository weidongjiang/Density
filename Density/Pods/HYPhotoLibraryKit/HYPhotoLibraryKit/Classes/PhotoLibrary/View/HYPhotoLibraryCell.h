//
//  HYPhotoLibraryCell.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/17.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPhotoLibraryCell;
@class HYPhotoModel;
#pragma mark ----- 代理方法
@protocol HYPhotoLibraryCellDelegate <NSObject>
@optional
- (void)photoLibraryCell:(HYPhotoLibraryCell *)cell didSelectBtn:(UIButton *)selectBtn;
- (void)photoLibraryCellRequestICloudAssetComplete:(HYPhotoLibraryCell *)cell;
- (void)photoLibraryCellRequestICloudAssetError:(HYPhotoLibraryCell *)cell;
- (void)photoLibraryCellDidSelectGIF;

@end

@interface HYPhotoLibraryCell : UICollectionViewCell

@property (weak, nonatomic) id<HYPhotoLibraryCellDelegate> delegate;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger item;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) CALayer *selectMaskLayer;
@property (strong, nonatomic) HYPhotoModel *model;
@property (assign, nonatomic) BOOL singleSelected;
@property (strong, nonatomic) UIColor *selectBgColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (strong, nonatomic) UIButton *selectBtn;

- (void)cancelRequest;
- (void)startRequestICloudAsset;
- (void)bottomViewPrepareAnimation;
- (void)bottomViewStartAnimation;

- (void)updateItemdidSelect:(BOOL)startIndexisSelect;
- (void)updateRangeItemdidSelect:(BOOL)startIndexisSelect;

@end


