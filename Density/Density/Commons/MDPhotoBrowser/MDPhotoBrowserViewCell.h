//
//  MDPhotoBrowserViewCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "MDPhotoBrowserModel.h"


extern NSString * _Nonnull const MDPhotoBrowserViewCellID;

NS_ASSUME_NONNULL_BEGIN
@class MDPhotoBrowserViewCell;

typedef void(^MDPhotoBrowserViewCellBlock)(UIPanGestureRecognizer *gesture,MDPhotoBrowserViewCell *cell);

@interface MDPhotoBrowserViewCell : UICollectionViewCell



@property (nonatomic, strong) MDPhotoBrowserModel *model;

@property (nonatomic, copy) MDPhotoBrowserViewCellBlock gestureCellBlock;


@end

NS_ASSUME_NONNULL_END
