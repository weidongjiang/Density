//
//  MDRecordTableViewPhotoBrowserCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDRecordTableViewBaseCell.h"

extern NSString * _Nonnull const MDRecordTableViewPhotoBrowserCellID;

#define KCollectionBackView_Width KMDRecordTableViewCellbackImageView_Width
#define KCollectionBackView_Height 200


NS_ASSUME_NONNULL_BEGIN

@interface MDRecordTableViewPhotoBrowserCell : MDRecordTableViewBaseCell

@property (nonatomic, strong) UIView        *collectionBackView; ///< <#value#>

- (void)setUpUI;
- (void)updateRecordModel:(MDPhotoBrowserModel *)model;

@end

NS_ASSUME_NONNULL_END
