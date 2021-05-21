//
//  HYPhotoLibraryPreviewViewController.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/16.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryPreviewViewController.h"
#import "HYPhotoLibraryPreviewCell.h"
#import "HYPhotoModel.h"
#import "HYPhotoLibraryManager.h"
#import "HYPhotoLibraryInteractiveTransition.h"
#import "HYPhotoLibraryViewTransition.h"
#import "UIView+Toast.h"
#import "UIButton+EnlargeTouchArea.h"
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
#import "UIColor+HYUtilities.h"
#import "UIImage+HYBundleImage.h"
#import "UIImage+HYImage.h"

@interface HYPhotoLibraryPreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readwrite) UICollectionView *previewCollectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UIButton *selectBtn;
@property (strong, nonatomic) HYPhotoModel *currentModel;
@property (nonatomic,assign) BOOL isAddInteractiveTransition;
@property (strong, nonatomic) HYPhotoLibraryPreviewCell *tempCell;
@property (strong, nonatomic) HYPhotoLibraryInteractiveTransition *interactiveTransition;

@end

@implementation HYPhotoLibraryPreviewViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
    }
    return self;
}
#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HYPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    HYPhotoLibraryPreviewCell *cell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HYPhotoLibraryPreviewCell *tempCell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            self.tempCell = tempCell;
            [tempCell requestHDImage];
        });
    }else {
        self.tempCell = cell;
        [cell requestHDImage];
    }
    
    if (!self.isAddInteractiveTransition) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //初始化手势过渡的代理
            self.interactiveTransition = [[HYPhotoLibraryInteractiveTransition alloc] init];
            //给当前控制器的视图添加手势
            [self.interactiveTransition addPanGestureForViewController:self];
        });
        self.isAddInteractiveTransition = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    HYPhotoLibraryPreviewCell *cell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    cell.stopCancel = self.stopCancel;
    [cell cancelRequest];
    self.stopCancel = NO;
}

- (void)dealloc {
    if (_previewCollectionView) {
        HYPhotoLibraryPreviewCell *cell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        [cell cancelRequest];
    }
    if ([UIApplication sharedApplication].statusBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    HYDebugLog(@"dealloc HYPhotoLibraryPreviewViewController");
}
#pragma mark ----- 设置UI
- (void)setupUI {
    
    //获取当前所在bundle
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSDictionary *dic = currentBundle.infoDictionary;
    //获取bundle名
    self.view.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:2550 darkR:0 darkG:0 darkB:1];
    [self.view addSubview:self.previewCollectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    UIButton *navBackBtn = [[UIButton alloc] init];
    UIImage *whiteImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_white" bundleName:@"HYPhotoLibraryKit"];
    UIImage *blackImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_black" bundleName:@"HYPhotoLibraryKit"];
    [navBackBtn setImage:[UIImage hy_imageLightImage:blackImage darkImage:whiteImage] forState:UIControlStateNormal];
    [navBackBtn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    navBackBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.previewCollectionView.contentSize = CGSizeMake(self.modelArray.count * (KHYScreenWidth + 20), 0);
    [self.previewCollectionView setContentOffset:CGPointMake(self.currentModelIndex * (KHYScreenWidth + 20), 0)];

    HYPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.selectBtn.selected = model.selected;
    [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
    self.selectBtn.backgroundColor = self.selectBtn.selected ? self.manager.configuration.themeColor : nil;
    
    if (self.manager.configuration.singleSelected) {
        self.selectBtn.hidden = YES;
    }
    [self.previewCollectionView reloadData];
}

#pragma mark ----- 返回方法
- (void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- 转场
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return [HYPhotoLibraryViewTransition transitionWithType:HYPhotoLibraryViewTransitionTypePush];
    }else {
        if (![fromVC isKindOfClass:[self class]]) {
            return nil;
        }
        return [HYPhotoLibraryViewTransition transitionWithType:HYPhotoLibraryViewTransitionTypePop];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

#pragma mark ----- 选择按钮点击方法
- (void)didSelectClick:(UIButton *)button {
    
    if (self.modelArray.count <= 0) {
        HYDebugLog(@"没有照片可选!");
        return;
    }
    HYPhotoModel *model = self.modelArray[self.currentModelIndex];
    // 屏蔽GIF图片的选择
    if ([[model.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        [self.view makeToast:@"暂不支持上传Gif图片" duration:1.0f position:CSToastPositionCenter];
        return;
    }
    if (model.isICloud) {
        HYPhotoLibraryPreviewCell *cell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        [cell cancelRequest];
        [cell requestHDImage];
        HYDebugLog(@"正在下载iCloud上的资源");
        return;
    }
    if (button.selected) {
        button.selected = NO;
        [self.manager beforeSelectedListdeletePhotoModel:model];
    }else {
        NSString *str = [self.manager maximumOfJudgment:model];
        if (str) {
//            [self.view showImageHUDText:str];
            return;
        }
        [self.manager beforeSelectedListAddPhotoModel:model];
        button.selected = YES;
        [button setTitle:model.selectIndexStr forState:UIControlStateSelected];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [button.layer addAnimation:anim forKey:@""];
    }
    button.backgroundColor = button.selected ? self.manager.configuration.themeColor : nil;
    if ([self.delegate respondsToSelector:@selector(photoLibraryPreviewViewDidSelect:model:)]) {
        [self.delegate photoLibraryPreviewViewDidSelect:self model:model];
    }
}

- (HYPhotoLibraryPreviewCell *)currentPreviewCell:(HYPhotoModel *)model {
    if (!model) {
        return nil;
    }
    return (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
}
#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoLibraryPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoLibraryPreviewCellId" forIndexPath:indexPath];
    HYPhotoModel *model = self.modelArray[indexPath.item];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
 
    [cell setCellDownloadICloudAssetComplete:^(HYPhotoLibraryPreviewCell *myCell) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoLibraryPreviewViewDownLoadICloudAssetComplete:model:)]) {
            [weakSelf.delegate photoLibraryPreviewViewDownLoadICloudAssetComplete:weakSelf model:myCell.model];
        }
    }];
    
    [cell setCellTapClick:^{
        [weakSelf setSubviewAlphaAnimate:YES];
    }];
    
    return cell;
}
#pragma mark ----- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [(HYPhotoLibraryPreviewCell *)cell resetScale];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HYPhotoLibraryPreviewCell *)cell cancelRequest];
}

#pragma mark - <UICollectionViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.previewCollectionView) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetx = self.previewCollectionView.contentOffset.x;
    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
    if (currentIndex > self.modelArray.count - 1) {
        currentIndex = self.modelArray.count - 1;
    }
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    if (self.modelArray.count > 0) {
        HYPhotoModel *model = self.modelArray[currentIndex];

        self.selectBtn.selected = model.selected;
        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
        self.selectBtn.backgroundColor = self.selectBtn.selected ? self.manager.configuration.themeColor : nil;
    }
    self.currentModelIndex = currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.modelArray.count > 0) {
        HYPhotoLibraryPreviewCell *cell = (HYPhotoLibraryPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        HYPhotoModel *model = self.modelArray[self.currentModelIndex];
        self.currentModel = model;
        [cell requestHDImage];
    }
}

#pragma mark ----- 动画展示
- (void)setSubviewAlphaAnimate:(BOOL)animete {
    [self setSubviewAlphaAnimate:animete duration:0.15];
}

- (void)setSubviewAlphaAnimate:(BOOL)animete duration:(NSTimeInterval)duration {

    if (!self.isHide) {
        self.isHide = YES;
    }else{
        self.isHide = NO;
    }
    
    if (!self.isHide) {
        [self.navigationController setNavigationBarHidden:self.isHide animated:NO];
    }
/** 不做动画没太大区别这里先注释 */
//    if (animete) {
//        [UIView animateWithDuration:duration animations:^{
//            self.navigationController.navigationBar.alpha = self.isHide ? 0 : 1;
//
//            self.view.backgroundColor = self.isHide ? [UIColor blackColor] : KMainBGColor;
//            self.previewCollectionView.backgroundColor = self.isHide ? [UIColor blackColor] : KMainBGColor;
//        } completion:^(BOOL finished) {
//            if (self.isHide) {
//                [self.navigationController setNavigationBarHidden:self.isHide animated:NO];
//            }
//        }];
//    }else {
        self.navigationController.navigationBar.alpha = self.isHide ? 0 : 1;

    UIColor *color = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1];
        self.view.backgroundColor = self.isHide ? [UIColor blackColor] : color;
        self.previewCollectionView.backgroundColor = self.isHide ? [UIColor blackColor] : color;
        if (self.isHide) {
            [self.navigationController setNavigationBarHidden:self.isHide];
//        }
    }
}

#pragma mark ----- 懒加载
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        
        [_selectBtn setBackgroundImage:[UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_ximg_CheckBox" bundleName:@"HYPhotoLibraryKit"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _selectBtn.adjustsImageWhenDisabled = YES;
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
        _selectBtn.layer.cornerRadius = 11;
    }
    return _selectBtn;
}

- (UICollectionView *)previewCollectionView {
    if (!_previewCollectionView) {
        CGFloat collectionViewHeight = 0;
        
        if (KHYISIPhoneX) {
            collectionViewHeight = KHYScreenHeight - 88;
        }else{
            collectionViewHeight = KHYScreenHeight - 64;
        }
        _previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(- 10, KHYHiddenStatusNavbarHeight, KHYScreenWidth + 20, collectionViewHeight) collectionViewLayout:self.flowLayout];
        _previewCollectionView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1];
        _previewCollectionView.dataSource = self;
        _previewCollectionView.delegate = self;
        _previewCollectionView.pagingEnabled = YES;
        _previewCollectionView.showsVerticalScrollIndicator = NO;
        _previewCollectionView.showsHorizontalScrollIndicator = NO;
        [_previewCollectionView registerClass:[HYPhotoLibraryPreviewCell class] forCellWithReuseIdentifier:@"PhotoLibraryPreviewCellId"];
        
        if (@available(iOS 11.0, *)) {
            _previewCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _previewCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 20;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(KHYScreenWidth, self.view.bounds.size.height - KHYHiddenStatusNavbarHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    }
    return _flowLayout;
}
@end
