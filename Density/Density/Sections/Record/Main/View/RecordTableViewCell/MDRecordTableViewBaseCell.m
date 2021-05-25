//
//  MDRecordTableViewBaseCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDRecordTableViewBaseCell.h"

@interface MDRecordTableViewBaseCell ()

@end

@implementation MDRecordTableViewBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.contentView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(KMDRecordTableViewCellbackImageView_m);
            make.width.mas_equalTo(KMDRecordTableViewCellbackImageView_Width);
        make.height.mas_equalTo(KMDRecordTableViewCellbackImageView_Height);
    }];
    
    CGFloat titleView_h = KMDRecordTableViewCellTitleView_Height;
    self.titleView = [[MDRecordTableViewCellTitleView alloc] init];
    [self.backImageView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(titleView_h);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


- (void)updateRecordModel:(MDPhotoBrowserModel *)model {
    
}

@end


NSString *const MDRecordTableViewBaseCellID = @"MDRecordTableViewBaseCellID";
