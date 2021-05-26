//
//  MDPhotoBrowserCollectionView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDPhotoBrowserCollectionView.h"
#import "MDPhotoBrowserViewCell.h"

@interface MDPhotoBrowserCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout; ///< <#value#>

@property(nonatomic, assign) NSInteger currentPage; //default is 0.
@property (nonatomic, assign) BOOL isScrollViewCanDragging;

@end

@implementation MDPhotoBrowserCollectionView

- (instancetype)init {
    if (self = [super init]) {
        _isScrollViewCanDragging = YES;
    }
    return self;
}

- (void)initCollectionViewFrame:(CGRect)frame itemSize:(CGSize)itemSize {
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = itemSize;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.collectionView registerClass:[MDPhotoBrowserViewCell class] forCellWithReuseIdentifier:MDPhotoBrowserViewCellID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
}

- (void)setCollectionViewDataArray:(NSMutableArray *)collectionViewDataArray {
    _collectionViewDataArray = collectionViewDataArray;
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
        if (cell.model.type == MDPhotoBrowserModelTypeVideo) {
            [cell updateVisibleCellsPlay:YES];
        }else {
            [[MDPhotoBrowserViewPlayManager sharedManager] pause];
        }
    }
}

@end
