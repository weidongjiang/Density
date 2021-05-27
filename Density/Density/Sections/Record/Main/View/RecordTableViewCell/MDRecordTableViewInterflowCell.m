//
//  MDRecordTableViewInterflowCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDRecordTableViewInterflowCell.h"

@interface MDRecordTableViewInterflowCell ()



@end

@implementation MDRecordTableViewInterflowCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    self.interflowView = [[MDRecordTableViewCellInterflowView alloc] init];
    [self.backImageView addSubview:self.interflowView];
    [self.interflowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.browserView.collectionView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(KMDRecordTableViewCellInterflowView_Height);
    }];
    
    
}

- (void)updateRecordModel:(MDPhotoBrowserModel *)model {
    [super updateRecordModel:model];
    
    
}

@end


NSString * _Nonnull const MDRecordTableViewInterflowCellID = @"MDRecordTableViewInterflowCellID";
