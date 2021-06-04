//
//  MDRecordCommentViewCell.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/27.
//

#import <UIKit/UIKit.h>
#import "MDRecordCommentModel.h"

extern NSString *const MDRecordCommentViewCellID;


NS_ASSUME_NONNULL_BEGIN

@interface MDRecordCommentViewCell : UITableViewCell

- (void)updateCommentModel:(MDRecordCommentModel *)model;

@end

NS_ASSUME_NONNULL_END
