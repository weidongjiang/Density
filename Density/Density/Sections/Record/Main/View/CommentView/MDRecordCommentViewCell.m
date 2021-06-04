//
//  MDRecordCommentViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/27.
//

#import "MDRecordCommentViewCell.h"

@interface MDRecordCommentViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation MDRecordCommentViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
   
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
    }];
    
    
    
}

- (void)updateCommentModel:(MDRecordCommentModel *)model {
    
    
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end


NSString *const MDRecordCommentViewCellID = @"MDRecordCommentViewCellID";
