//
//  MDRecordTableViewCommentCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDRecordTableViewInterflowCell.h"
#import "MDRecordCommentView.h"
#import "MDRecordTableViewCellInputBoxView.h"

extern NSString * _Nonnull const MDRecordTableViewCommentCellID;
#define KMDRecordCommentView_Width KMDRecordTableViewCellbackImageView_Width
#define KMDRecordCommentView_Height 180

#define KMDRecordTableViewCellInputBoxView_Height 40

NS_ASSUME_NONNULL_BEGIN

@interface MDRecordTableViewCommentCell : MDRecordTableViewInterflowCell

@property (nonatomic, strong) MDRecordCommentView *commentView;
@property (nonatomic, strong) MDRecordTableViewCellInputBoxView *inputBoxView;

- (void)setUpUI;
- (void)updateRecordModel:(MDPhotoBrowserModel *)model;


@end

NS_ASSUME_NONNULL_END
