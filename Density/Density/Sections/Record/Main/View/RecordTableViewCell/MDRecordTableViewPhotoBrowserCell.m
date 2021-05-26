//
//  MDRecordTableViewPhotoBrowserCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDRecordTableViewPhotoBrowserCell.h"
#import "MDPhotoBrowserViewCell.h"

@interface MDRecordTableViewPhotoBrowserCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout; ///< <#value#>
@property (nonatomic, strong) UICollectionView        *collectionView; ///< <#value#>
@property (nonatomic, strong) NSMutableArray        *collectionViewDataArray; ///< <#value#>

@property(nonatomic, assign) NSInteger currentPage; //default is 0.
@property (nonatomic, assign) BOOL isScrollViewCanDragging;
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
    
    self.isScrollViewCanDragging = YES;
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(KCollectionBackView_Width, KCollectionBackView_Height);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.contentView.hy_width, self.contentView.hy_height) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.collectionView registerClass:[MDPhotoBrowserViewCell class] forCellWithReuseIdentifier:MDPhotoBrowserViewCellID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDPhotoBrowserModel *model = [self.collectionViewDataArray hy_unknownObjectAtIndex:indexPath.item];
    MDPhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDPhotoBrowserViewCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark - UIScrollViewDelegate
- (void)collectionViewScrollToRealPage:(NSInteger)page {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    HYDebugLog(@"scrollViewWillBeginDragging");
    self.currentPage = ceil(scrollView.contentOffset.x / scrollView.frame.size.width);
    HYDebugLog(@"scrollViewWillBeginDragging _currentPage %ld",(long)self.currentPage);
    if (self.currentPage + 1 == self.collectionViewDataArray.count && self.isScrollViewCanDragging) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info hy_setSafeObject:@"right" forKey:@"Dragging"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"KViewControllershandlerPanNotification" object:nil userInfo:info];
        self.isScrollViewCanDragging = NO;
    }else if (self.currentPage + 1 < self.collectionViewDataArray.count && self.currentPage > 0){
        self.isScrollViewCanDragging = YES;
    }else if (self.currentPage == 0 && self.isScrollViewCanDragging) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info hy_setSafeObject:@"left" forKey:@"Dragging"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"KViewControllershandlerPanNotification" object:nil userInfo:info];
        self.isScrollViewCanDragging = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleCells = [self.collectionView visibleCells];
    HYDebugLog(@"visibleCells--%@",visibleCells);
    for (MDPhotoBrowserViewCell *cell in visibleCells) {
        [cell updateVisibleCellsPlay];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    HYDebugLog(@"scrollViewDidEndScrollingAnimation");
    
    MDPhotoBrowserViewCell *cell = (MDPhotoBrowserViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
    
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

    
    self.collectionViewDataArray = data;
    [self.collectionView reloadData];
}


@end
NSString * _Nonnull const MDRecordTableViewPhotoBrowserCellID = @"MDRecordTableViewPhotoBrowserCellID";
