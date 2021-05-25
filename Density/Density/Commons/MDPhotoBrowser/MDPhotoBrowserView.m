//
//  MDPhotoBrowserView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDPhotoBrowserView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"

@interface MDPhotoBrowserViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation MDPhotoBrowserViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.frame;
}

@end

static NSString *CellIdentifier = @"MDPhotoBrowserViewCell";


@interface MDPhotoBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _currentPage;
}
@property(nonatomic, copy) NSArray *urls;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic) BOOL useCustomPageControlFrame;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end


@implementation MDPhotoBrowserView

@synthesize pageControl = _pageControl;

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    [self invalidateTimer];
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls {
    self = [super initWithFrame:frame];
    if (self) {
        self.urls = [self convertToNSURLArrayFrom:imageUrls];
        
        [self prefetchImages];
        
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        [self setup];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow != nil)
    {
        [self invalidateTimer];
        [self setupTimer];
    }
    else
    {
        [self invalidateTimer];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.collectionViewLayout = self.flowLayout;
    
    if (self.useCustomPageControlFrame) {
        self.pageControl.frame = self.pageControlFrame;
    } else {
        self.pageControl.frame = CGRectMake(0, self.frame.size.height - 22, self.frame.size.width, 22);
    }
    
    [self setCurrentPage:self.currentPage animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.urls.count <= 1) {
        return self.urls.count;
    }
    return self.urls.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDPhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (0 == indexPath.item) {
        [cell.imageView sd_setImageWithURL:[self.urls lastObject]
                          placeholderImage:self.placeholderImage];
    } else if (self.urls.count + 1 == indexPath.item) {
        [cell.imageView sd_setImageWithURL:[self.urls firstObject]
                          placeholderImage:self.placeholderImage];
    } else {
        [cell.imageView sd_setImageWithURL:self.urls[indexPath.item - 1]
                          placeholderImage:self.placeholderImage];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([self.bannerDelegate respondsToSelector:@selector(bannerView:didSelectAtIndex:)]) {
        [self.bannerDelegate bannerView:self didSelectAtIndex:self.pageControl.currentPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (0 >= scrollView.contentOffset.x) {
        [self collectionViewScrollToRealPage:self.urls.count];
    } else if (ceil((self.urls.count + 1) * scrollView.frame.size.width) <= ceil(scrollView.contentOffset.x)) {
        [self collectionViewScrollToRealPage:1];
    } else {
        _currentPage = ceil(scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
    }
    if (self.bannerDelegate && [self.bannerDelegate respondsToSelector:@selector(bannerView:didShowAtIndex:)] && self.pageControl.currentPage != self.currentPage) {
        [self.bannerDelegate bannerView:self didShowAtIndex:self.pageControl.currentPage];
    }
    self.pageControl.currentPage = self.currentPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self continueTimerLater];
}

#pragma mark - Event Response
- (void)scrollToNext {
    if (self.currentPage >= self.urls.count) {
        _currentPage %= self.urls.count;
    }
    self.currentPage++;
}

#pragma mark - Private Method
- (void)setup {
    self.pageControl.numberOfPages = self.urls.count;
    self.animationDuration = 3;
    self.autoScroll = YES;
}

- (void)collectionViewScrollToRealPage:(NSInteger)page {
    [self setCurrentPage:page - 1 animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    _currentPage = currentPage;
    
    if (self.window != nil && self.urls.count > 1) {
        [self.collectionView setContentOffset:CGPointMake((currentPage + 1) * self.collectionView.frame.size.width, 0) animated:animated];
    }
}

- (void)pauseTimer {
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)continueTimerLater {
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.animationDuration];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupTimer {
    if (self.urls.count > 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration
                                                      target:self
                                                    selector:@selector(scrollToNext)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (NSArray *)convertToNSURLArrayFrom:(NSArray *)urlArray {
    NSMutableArray *convertedArray = [NSMutableArray array];
    for (id url in urlArray) {
        NSAssert([url isKindOfClass:[NSURL class]] || [url isKindOfClass:[NSString class]],
                 @"*** object in array \"imageUrls\" must be kind of NSString or NSURL class");
        if ([url isKindOfClass:[NSURL class]]) {
            [convertedArray addObject:url];
        } else if ([url isKindOfClass:[NSString class]]) {
            [convertedArray addObject:[NSURL URLWithString:url]];
        }
    }
    return [convertedArray copy];
}

- (void)prefetchImages {
    if (self.urls.count > 1) {
        NSMutableArray *urlsExceptFirst = [self.urls mutableCopy];
        [urlsExceptFirst removeObjectAtIndex:0];
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urlsExceptFirst];
    }
}

- (void)reloadWithImageUrls:(NSArray *)imageUrls {
    NSArray *array = [self convertToNSURLArrayFrom:imageUrls];
    if (![self.urls isEqualToArray:array]) {
        self.urls = [array copy];
        
        [self prefetchImages];
        self.pageControl.numberOfPages = self.urls.count;
        self.pageControl.currentPage = 0;
        [self setCurrentPage:0 animated:NO];
        [self.collectionView reloadData];
        
        if (self.autoScroll) {
            [self invalidateTimer];
            [self setupTimer];
        }
    }
}

#pragma mark - Getters && Setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[MDPhotoBrowserViewCell class]
            forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (SMPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.minHeight = 22;
    }
    return _pageControl;
}

- (NSInteger)currentPage
{
    NSInteger page = _currentPage;
    if (_currentPage >= self.urls.count) {
        page %= self.urls.count;
    }
    return page;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage animated:YES];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self invalidateTimer];
        [self setupTimer];
    } else {
        [self invalidateTimer];
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    
    if (self.timer.timeInterval != animationDuration) {
        [self invalidateTimer];
        [self setupTimer];
    }
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    
    self.useCustomPageControlFrame = YES;
}

@end
