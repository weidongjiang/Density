//
//  MDRecordTableViewBaseCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "MDRecordTableViewCellTitleView.h"
#import "MDPhotoBrowserModel.h"

extern NSString * _Nonnull const MDRecordTableViewBaseCellID;
#define KMDRecordTableViewCellTitleView_Height 50
#define KMDRecordTableViewCellbackImageView_m 15
#define KMDRecordTableViewCellbackImageView_Width (KHYScreenWidth - 2*KMDRecordTableViewCellbackImageView_m)
#define KMDRecordTableViewCellbackImageView_Height 500


NS_ASSUME_NONNULL_BEGIN

@interface MDRecordTableViewBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) MDRecordTableViewCellTitleView *titleView;

- (void)setUpUI;
- (void)updateRecordModel:(MDPhotoBrowserModel *)model;

@end

NS_ASSUME_NONNULL_END
