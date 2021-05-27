//
//  MDRecordTableViewInterflowCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDRecordTableViewPhotoBrowserCell.h"
#import "MDRecordTableViewCellInterflowView.h"

extern NSString * _Nonnull const MDRecordTableViewInterflowCellID;
#define KMDRecordTableViewCellInterflowView_Width KMDRecordTableViewCellbackImageView_Width
#define KMDRecordTableViewCellInterflowView_Height 30


NS_ASSUME_NONNULL_BEGIN


@interface MDRecordTableViewInterflowCell : MDRecordTableViewPhotoBrowserCell

@property (nonatomic, strong) MDRecordTableViewCellInterflowView *interflowView;

- (void)setUpUI;
- (void)updateRecordModel:(MDPhotoBrowserModel *)model;

@end

NS_ASSUME_NONNULL_END
