//
//  HYPhotoLibraryPreviewCell.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/22.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class HYPhotoLibraryPreviewCell;
@class HYPhotoModel;

@interface HYPhotoLibraryPreviewCell : UICollectionViewCell
@property (assign, nonatomic) BOOL stopCancel;
@property (strong, nonatomic) HYPhotoModel *model;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, copy) void (^cellDownloadICloudAssetComplete)(HYPhotoLibraryPreviewCell *myCell);
@property (nonatomic, copy) void (^cellTapClick)(void);
@property (strong, nonatomic,readonly) UIImageView *imageView;

- (void)againAddImageView;
- (void)resetScale;
- (void)requestHDImage;
- (void)cancelRequest;
@end


