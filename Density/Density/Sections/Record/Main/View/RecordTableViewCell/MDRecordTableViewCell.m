//
//  MDRecordTableViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordTableViewCell.h"
#import "MDRecordTableViewCellTitleView.h"
#import "MDScanImageAndVideoView.h"
#import "MDRecordTableViewCellInterflowView.h"
#import "MDRecordCommentView.h"
#import "MDRecordTableViewCellInputBoxView.h"

@interface MDRecordTableViewCell ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) MDRecordTableViewCellTitleView *titleView;
@property (nonatomic, strong) MDScanImageAndVideoView *scanView;
@property (nonatomic, strong) MDRecordTableViewCellInterflowView *interflowView;
@property (nonatomic, strong) MDRecordCommentView *commentView;
@property (nonatomic, strong) MDRecordTableViewCellInputBoxView *inputBoxView;



@end


@implementation MDRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
        [self setEditing:YES animated:YES];
    }
    return self;
}

- (void)setUpUI {
   
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.contentView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(15);
            make.bottom.right.equalTo(self.contentView).offset(-15);
    }];
    
    CGFloat titleView_h = 50;
    self.titleView = [[MDRecordTableViewCellTitleView alloc] init];
    [self.backImageView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(titleView_h);
    }];
    
    
    CGFloat scanView_h = 200;
    self.scanView = [[MDScanImageAndVideoView alloc] init];
    [self.backImageView addSubview:self.scanView];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(scanView_h);
    }];
    
    CGFloat interflowView_h = 30;
    self.interflowView = [[MDRecordTableViewCellInterflowView alloc] init];
    [self.backImageView addSubview:self.interflowView];
    [self.interflowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scanView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(interflowView_h);
    }];
    
    CGFloat commentView_h = 100;
    self.commentView = [[MDRecordCommentView alloc] init];
    [self.backImageView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.interflowView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(commentView_h);
    }];

    CGFloat inputBoxView_h = 40;
    self.inputBoxView = [[MDRecordTableViewCellInputBoxView alloc] init];
    [self.backImageView addSubview:self.inputBoxView];
    [self.inputBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(inputBoxView_h);
    }];
    
}

@end


NSString *const MDRecordTableViewCellID = @"MDRecordTableViewCellID";
CGFloat const MDRecordTableViewCellHeight = 500;
