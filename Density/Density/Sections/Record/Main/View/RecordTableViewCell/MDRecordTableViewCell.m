//
//  MDRecordTableViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordTableViewCell.h"
#import "MDRecordTableViewCellTitleView.h"
#import "MDPhotoBrowserView.h"
#import "MDRecordTableViewCellInterflowView.h"
#import "MDRecordCommentView.h"
#import "MDRecordTableViewCellInputBoxView.h"
#import "XNLoopBannerView.h"

@interface MDRecordTableViewCell ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) MDRecordTableViewCellTitleView *titleView;
@property (nonatomic, strong) MDPhotoBrowserView *browserView;
@property (nonatomic, strong) MDRecordTableViewCellInterflowView *interflowView;
@property (nonatomic, strong) MDRecordCommentView *commentView;
@property (nonatomic, strong) MDRecordTableViewCellInputBoxView *inputBoxView;

//@property (nonatomic, strong) XNLoopBannerView *bannerView;



@end


@implementation MDRecordTableViewCell
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
    self.browserView = [[MDPhotoBrowserView alloc] initWithFrame:CGRectMake(0, 0, self.backImageView.hy_width, scanView_h)];
    [self.backImageView addSubview:self.browserView];
    [self.browserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(scanView_h);
    }];
    
//    self.bannerView = [[XNLoopBannerView alloc] initWithFrame:CGRectZero imageUrls:@[]];
//    [self.backImageView addSubview:self.bannerView];
//    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleView.mas_bottom);
//            make.left.right.equalTo(self.backImageView);
//            make.height.mas_equalTo(scanView_h);
//    }];
    
    
    CGFloat interflowView_h = 30;
    self.interflowView = [[MDRecordTableViewCellInterflowView alloc] init];
    [self.backImageView addSubview:self.interflowView];
    [self.interflowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.browserView.mas_bottom);
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

- (void)setbrowserViewData {

    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    MDPhotoBrowserModel *model_1 = [[MDPhotoBrowserModel alloc] init];
    model_1.type = MDPhotoBrowserModelTypeImage;
    model_1.imageUrlString = @"http://aop.huoying666.com/images/20210517/89cc040611e30a18b213968e730ec54d/89cc040611.jpg_home-image-1080";
    
    
    MDPhotoBrowserModel *model_2 = [[MDPhotoBrowserModel alloc] init];
    model_2.type = MDPhotoBrowserModelTypeImage;
    model_2.imageUrlString = @"http://aop.huoying666.com/images/20210517/717c720781140b7bc3e85c6f40f0cedd/717c720781.jpg_home-image-1080";
    
    MDPhotoBrowserModel *model_3 = [[MDPhotoBrowserModel alloc] init];
    model_3.type = MDPhotoBrowserModelTypeImage;
    model_3.imageUrlString = @"http://aop.huoying666.com/images/20210517/a75465a833b1cf4a8a90104f616ad34c/a75465a833.jpg_home-image-1080";
    MDPhotoBrowserModel *model_4 = [[MDPhotoBrowserModel alloc] init];
    model_4.type = MDPhotoBrowserModelTypeImage;
    model_4.imageUrlString = @"http://aop.huoying666.com/images/20210517/717c720781140b7bc3e85c6f40f0cedd/717c720781.jpg_home-image-1080";
    MDPhotoBrowserModel *model_5 = [[MDPhotoBrowserModel alloc] init];
    model_5.type = MDPhotoBrowserModelTypeImage;
    model_5.imageUrlString = @"http://aop.huoying666.com/images/20210517/7d61308436204de9d6231d44039a44c2/7d61308436.jpg_home-image-1080";
    MDPhotoBrowserModel *model_6 = [[MDPhotoBrowserModel alloc] init];
    model_6.type = MDPhotoBrowserModelTypeImage;
    model_6.imageUrlString = @"http://aop.huoying666.com/images/20210513/8096db985aef973f4eb43934ec1a5d9d/8096db985a.jpg_home-image-1080";
    

    [data hy_addSafeObject:model_1];
    [data hy_addSafeObject:model_2];
    [data hy_addSafeObject:model_3];
    [data hy_addSafeObject:model_4];
    [data hy_addSafeObject:model_5];
    [data hy_addSafeObject:model_6];

    self.browserView.browserDataArray = data;
    
    
    NSArray *dataArray = @[@"http://aop.huoying666.com/images/20210517/89cc040611e30a18b213968e730ec54d/89cc040611.jpg_home-image-1080",@"http://aop.huoying666.com/images/20210517/717c720781140b7bc3e85c6f40f0cedd/717c720781.jpg_home-image-1080",@"http://aop.huoying666.com/images/20210517/a75465a833b1cf4a8a90104f616ad34c/a75465a833.jpg_home-image-1080",@"http://aop.huoying666.com/images/20210517/717c720781140b7bc3e85c6f40f0cedd/717c720781.jpg_home-image-1080",@"http://aop.huoying666.com/images/20210517/7d61308436204de9d6231d44039a44c2/7d61308436.jpg_home-image-1080",@"http://aop.huoying666.com/images/20210513/8096db985aef973f4eb43934ec1a5d9d/8096db985a.jpg_home-image-1080"];
//    [self.bannerView reloadWithImageUrls:dataArray];
}

@end


NSString *const MDRecordTableViewCellID = @"MDRecordTableViewCellID";
CGFloat const MDRecordTableViewCellHeight = 500;
