//
//  MDRecordTableViewPhotoBrowserCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDRecordTableViewPhotoBrowserCell.h"
#import "MDPhotoBrowserCollectionView.h"

@interface MDRecordTableViewPhotoBrowserCell ()
@property (nonatomic, strong) MDPhotoBrowserCollectionView *browserView;
@end

@implementation MDRecordTableViewPhotoBrowserCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [super setUpUI];
    
    
    self.browserView = [[MDPhotoBrowserCollectionView alloc] init];
    [self.browserView initCollectionViewFrame:CGRectMake(0,0,self.contentView.hy_width, self.contentView.hy_height) itemSize:CGSizeMake(KCollectionBackView_Width, KCollectionBackView_Height)];
    [self.contentView addSubview:self.browserView.collectionView];
    [self.browserView.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KMDRecordTableViewCellbackImageView_m);
        make.top.equalTo(self.titleView.mas_bottom);
        make.width.mas_equalTo(KCollectionBackView_Width);
        make.height.mas_equalTo(KCollectionBackView_Height);
    }];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
}
- (void)updateRecordModel:(MDPhotoBrowserModel *)model {
    [super updateRecordModel:model];
    
    [self setbrowserViewData];
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
    
    MDPhotoBrowserModel *model_7 = [[MDPhotoBrowserModel alloc] init];
    model_7.type = MDPhotoBrowserModelTypeVideo;
    model_7.imageUrlString = @"http://aop.huoying666.com/images/20210513/8096db985aef973f4eb43934ec1a5d9d/8096db985a.jpg_home-image-1080";
    model_7.videoUrlString = @"http://aop.huoying666.com/videos/20210526/73576f49275fccce2fc4e4b08eda7068/73576f4927.mp4";
    
    MDPhotoBrowserModel *model_8 = [[MDPhotoBrowserModel alloc] init];
    model_8.type = MDPhotoBrowserModelTypeVideo;
    model_8.imageUrlString = @"http://aop.huoying666.com/images/20210517/7d61308436204de9d6231d44039a44c2/7d61308436.jpg_home-image-1080";
    model_8.videoUrlString = @"https://vd3.bdstatic.com//mda-ma5jqzcy8my15dxk//cae_h264_clips//1609916394//mda-ma5jqzcy8my15dxk.mp4";
    
    
    

    [data hy_addSafeObject:model_1];
    [data hy_addSafeObject:model_2];
    [data hy_addSafeObject:model_7];
    [data hy_addSafeObject:model_3];
    [data hy_addSafeObject:model_4];
    [data hy_addSafeObject:model_8];
    [data hy_addSafeObject:model_5];
    [data hy_addSafeObject:model_6];

    
    self.browserView.collectionViewDataArray = data;
}


@end
NSString * _Nonnull const MDRecordTableViewPhotoBrowserCellID = @"MDRecordTableViewPhotoBrowserCellID";
