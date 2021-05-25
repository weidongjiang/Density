//
//  MDRecordTableViewCell1.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/25.
//

#import "MDRecordTableViewCell1.h"

@interface MDRecordTableViewCell1 ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView        *collectionBackView; ///< <#value#>
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout; ///< <#value#>
@property (nonatomic, strong) UICollectionView        *collectionView; ///< <#value#>
@property (nonatomic, strong) NSMutableArray        *collectionViewDataArray; ///< <#value#>

@property(nonatomic, assign) NSInteger currentPage; //default is 0.


@end

@implementation MDRecordTableViewCell1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
        self.currentPage = 0;
    }
    return self;
}


- (void)setUpUI {
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(KHYScreenWidth, 500);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.contentView.hy_width, self.contentView.hy_height) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.collectionView registerClass:[MDPhotoBrowserViewCell class] forCellWithReuseIdentifier:@"KYXNMyUserCellItemCellID"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
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
    MDPhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYXNMyUserCellItemCellID" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

//    if (0 >= scrollView.contentOffset.x) {
//        [self collectionViewScrollToRealPage:self.collectionViewDataArray.count];
//    } else if (ceil((self.collectionViewDataArray.count + 1) * scrollView.frame.size.width) <= ceil(scrollView.contentOffset.x)) {
//        [self collectionViewScrollToRealPage:1];
//    } else {
//        _currentPage = ceil(scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
//    }
    
        HYDebugLog(@"scrollViewWillBeginDragging scrollView.contentOffset.x---%f",scrollView.contentOffset.x);

    HYDebugLog(@"scrollViewWillBeginDragging currentPage---%ld",(long)self.currentPage);
    
    if (self.collectionViewDataArray.count > 1) {
        self.currentPage = self.currentPage + 1;
//        HYDebugLog(@"scrollViewWillBeginDragging currentPage--1-%ld",(long)self.currentPage);

        [self.collectionView setContentOffset:CGPointMake(self.currentPage * self.collectionView.frame.size.width, 0) animated:NO];
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset API_AVAILABLE(ios(5.0)) {
    HYDebugLog(@"scrollViewWillEndDragging");

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    HYDebugLog(@"scrollViewDidEndDragging");

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    HYDebugLog(@"scrollViewWillBeginDecelerating");

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    HYDebugLog(@"scrollViewDidEndDecelerating");

}





- (void)collectionViewScrollToRealPage:(NSInteger)page {
    [self setCurrentPage:page - 1 animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    _currentPage = currentPage;
    
    if (self.window != nil && self.collectionViewDataArray.count > 1) {
        [self.collectionView setContentOffset:CGPointMake((currentPage + 1) * self.collectionView.frame.size.width, 0) animated:animated];
    }
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

    
    self.collectionViewDataArray = data;
    [self.collectionView reloadData];
}

@end
