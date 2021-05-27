//
//  MDRecordTableViewCommentCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDRecordTableViewCommentCell.h"

@interface MDRecordTableViewCommentCell ()

@end


@implementation MDRecordTableViewCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    self.commentView = [[MDRecordCommentView alloc] init];
    [self.backImageView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.interflowView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(KMDRecordCommentView_Height);
    }];
    
    self.inputBoxView = [[MDRecordTableViewCellInputBoxView alloc] init];
    [self.backImageView addSubview:self.inputBoxView];
    [self.inputBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(KMDRecordTableViewCellInputBoxView_Height);
    }];
}

- (void)updateRecordModel:(MDPhotoBrowserModel *)model {
    [super updateRecordModel:model];
    
    
}

@end

NSString * _Nonnull const MDRecordTableViewCommentCellID = @"MDRecordTableViewCommentCellID";
