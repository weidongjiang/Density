//
//  MDPhotoBrowserView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDPhotoBrowserView.h"
#import "MDPhotoBrowserViewCell.h"

static NSString *CellIdentifier = @"MDPhotoBrowserViewCell";


@interface MDPhotoBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView        *collectionBackView; ///< <#value#>
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout; ///< <#value#>
@property (nonatomic, strong) UICollectionView        *collectionView; ///< <#value#>
@property (nonatomic, strong) NSMutableArray        *collectionViewDataArray; ///< <#value#>

@property(nonatomic, assign) NSInteger currentPage; //default is 0.



@end


@implementation MDPhotoBrowserView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}
- (void)dealloc {
    HYDebugLog(@"%s",__FUNCTION__);
}

- (void)initSubViews {
    self.backgroundColor = [UIColor yellowColor];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(KHYScreenWidth, 500);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.hy_width, self.hy_height) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.collectionView registerClass:[MDPhotoBrowserViewCell class] forCellWithReuseIdentifier:@"KYXNMyUserCellItemCellID"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
}

- (void)setBrowserDataArray:(NSArray<MDPhotoBrowserModel *> *)browserDataArray {
    self.collectionViewDataArray = browserDataArray;
    [self.collectionView reloadData];
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
    
    NSInteger currentPage = ceil(scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
    if (currentPage == self.currentPage) {
        return;
    }
    if (currentPage == self.collectionViewDataArray.count) {
        return;
    }
    self.currentPage = currentPage;
    if (self.window != nil && self.collectionViewDataArray.count > 1) {
        [self.collectionView setContentOffset:CGPointMake((_currentPage + 1) * self.collectionView.frame.size.width, 0) animated:NO];
    }
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



@end
