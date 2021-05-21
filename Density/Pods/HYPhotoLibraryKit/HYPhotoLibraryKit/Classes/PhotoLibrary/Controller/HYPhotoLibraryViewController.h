//
//  HYPhotoLibraryViewController.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/16.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoLibraryManager.h"

@class HYPhotoLibraryCell,HYPhotoModel;

@interface HYPhotoLibraryViewController : UIViewController
@property (nonatomic,strong,readonly) UICollectionView *libraryCollectionView;
@property (strong, nonatomic) HYPhotoLibraryManager *manager;
@property (nonatomic, copy) void (^selectedComplete)(NSArray* photoMoelArray);

- (HYPhotoLibraryCell *)currentPreviewCell:(HYPhotoModel *)model;
- (BOOL)scrollToModel:(HYPhotoModel *)model;
- (void)scrollToPoint:(HYPhotoLibraryCell *)cell rect:(CGRect)rect;
@end


