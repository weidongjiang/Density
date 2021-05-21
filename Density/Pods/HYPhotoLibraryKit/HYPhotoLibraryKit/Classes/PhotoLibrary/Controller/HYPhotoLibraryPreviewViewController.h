//
//  HYPhotoLibraryPreviewViewController.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/16.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYPhotoLibraryManager,HYPhotoModel,HYPhotoLibraryPreviewViewController,HYPhotoLibraryPreviewCell;

@protocol HYPhotoLibraryPreviewViewControllerDelegate <NSObject>
@optional
- (void)photoLibraryPreviewViewDidSelect:(HYPhotoLibraryPreviewViewController *)previewController model:(HYPhotoModel *)model;
- (void)photoLibraryPreviewViewDownLoadICloudAssetComplete:(HYPhotoLibraryPreviewViewController *)previewController model:(HYPhotoModel *)model;
@end

@interface HYPhotoLibraryPreviewViewController : UIViewController <UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong,readonly) UICollectionView *previewCollectionView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (strong, nonatomic) HYPhotoLibraryManager *manager;
@property (weak, nonatomic) id<HYPhotoLibraryPreviewViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL isHide;

@property (assign, nonatomic) BOOL stopCancel;


- (HYPhotoLibraryPreviewCell *)currentPreviewCell:(HYPhotoModel *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete duration:(NSTimeInterval)duration;

@end


