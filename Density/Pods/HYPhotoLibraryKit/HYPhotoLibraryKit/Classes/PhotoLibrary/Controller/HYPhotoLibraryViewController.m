//
//  HYPhotoLibraryViewController.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/16.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryViewController.h"
#import "HYPhotoLibraryManager.h"
#import "HYAlbumModel.h"
#import "HYPhotoLibraryCell.h"
#import "HYAlbumPopView.h"
#import "UICollectionView+Convenience.h"
#import "HYPhotoLibraryPreviewViewController.h"
#import "HYToolsManager.h"
#import "UIView+Toast.h"
#import <PhotosUI/PHPhotoLibrary+PhotosUISupport.h>
#import "XHNetworkCache.h"
#import "UIButton+EnlargeTouchArea.h"
#import "WKWebViewController.h"
#import "HYPhotoLibraryVideoPlayViewController.h"
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
#import "UIColor+HYUtilities.h"
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+HYBundleImage.h"
#import "UIImage+HYImage.h"


#define hyBottomMargin (KHYISIPhoneX ? 34 : 0)

@interface HYPhotoLibraryViewController ()<HYPhotoLibraryCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HYPhotoLibraryPreviewViewControllerDelegate,PHPhotoLibraryChangeObserver>
// 相册的collectionView
@property (nonatomic,strong,readwrite) UICollectionView *libraryCollectionView;
// 相册布局layout
@property (strong, nonatomic) UICollectionViewFlowLayout *libraryFlowLayout;
// 所有数据的数组
@property (strong, nonatomic) NSMutableArray *allArray;
// 预览的数组
@property (strong, nonatomic) NSMutableArray *previewArray;
// 图片的数组
@property (strong, nonatomic) NSMutableArray *photoArray;
// 视频的数组
@property (strong, nonatomic) NSMutableArray *videoArray;
// 相册的数组
@property (nonatomic,strong) NSMutableArray *albumModelArray;
// 当前选择的相册model
@property (nonatomic,strong) HYAlbumModel *albumModel;
// navgationTitleView
@property (nonatomic,strong) HYAlbumPopView  *titleView;

@property CGRect previousPreheatRect;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) HYToolsManager *toolManager;
@property (nonatomic, strong) AVURLAsset *asset;

// 导航栏下一步按钮
@property (nonatomic,strong) UIButton *finishBtn;

@property (nonatomic,assign) NSInteger selectedAlbumIndex;


/** 是否展示头部视图 */
@property (nonatomic, assign) BOOL shieldHeader;

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;
@property (nonatomic, assign) BOOL startIndexisSelect;
@property (nonatomic, strong) HYPhotoLibraryCell *locationSelectCell;

@end

@implementation HYPhotoLibraryViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}


#pragma mark ----- 控制器生命周期
#pragma mark ----- dealloc
- (void)dealloc{
    if (self.manager.configuration.isUpload == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISUPLOADING" object:@{@"isUpload":@"0"}];
    }
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];

    HYDebugLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observerConfig];
    /** 是否屏蔽头部视图 */
    self.shieldHeader = [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_shield"] integerValue];
    /** 初始化Nav */
    [self initNav];
    /** 初始化子视图 */
    [self initSubviews];
    /** 权限验证 */
    [self authPhotoBrower];

}

- (void)needRingGuide{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ringGuide"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ringGuide"];
        
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark ----- 初始化控制器

- (void)observerConfig{
    if (self.manager.configuration.isUpload == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISUPLOADING" object:@{@"isUpload":@"1"}];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navDismiss) name:@"SendImageWallpaperSuccess" object:nil];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}


- (void)initSubviews {
    /** 适配暗黑模式，单纯设置translucent为NO会导致转场偏移等问题 */
    
    UIImage *img = [self createImageWithColor:[UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 darkR:15 darkG:14 darkB:31] size:CGSizeMake(1, 1)];
    
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 darkR:0 darkG:0 darkB:1];//[UIColor dm_colorWithColorLight:rgba(255,255,255,1) dark:rgba(0,0,1,1)];
    
    
    [self.view addSubview:self.libraryCollectionView];
    
    if (self.manager.configuration.canSlideSelectMoreItem) {
        [self _addGestureRecognizer];
    }
}


- (void)initNav{
    self.navigationController.navigationBar.titleTextAttributes  = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    if (self.manager.configuration.isMakeLivePhoto) {
        UIButton *closeBtn = [[UIButton alloc] init];
        UIImage *whiteImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_white" bundleName:@"HYPhotoLibraryKit"];
        UIImage *blackImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_black" bundleName:@"HYPhotoLibraryKit"];
        [closeBtn setImage:[UIImage hy_imageLightImage:blackImage darkImage:whiteImage] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(navPop) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.frame = CGRectMake(0, 0, 20, 20);
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }else if(!self.manager.configuration.sendImageTextAdd){
        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [closeBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"000000" colorDark:@"FFFFFF"] forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(navDismiss) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn sizeToFit];
        [closeBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    if (self.manager.configuration.singleSelected != YES) {
        NSString *str = @"";
        
        UIButton *finishBtn = [[UIButton alloc] init];

        if (self.manager.configuration.sendImageTextAdd) {
            
            UIColor *finishBtnColor = self.manager.selectedArray.count ? [UIColor hy_colorWithColorLight:[UIColor blackColor] dark:[UIColor whiteColor]] : [UIColor hy_colorLightWithLightHex:@"0xE5E5E5" lightAlpha:1 colorDark:@"FFFFFF" darkAlpha:0.5];
            str = @"完成";
            [finishBtn setTitleColor:finishBtnColor forState:UIControlStateNormal];
        }else{
            str = @"下一步";
            [finishBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"0xE5E5E5" lightAlpha:1 colorDark:@"FFFFFF" darkAlpha:0.5] forState:UIControlStateNormal];
        }
        
        finishBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        [finishBtn setTitle:str forState:UIControlStateNormal];
        
        finishBtn.enabled = self.manager.selectedArray.count;
        finishBtn.userInteractionEnabled = self.manager.selectedArray.count;
        
        [finishBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        [finishBtn sizeToFit];
        [finishBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        self.finishBtn = finishBtn;
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }else{
        
    }
    
    self.titleView.intrinsicContentSize = CGSizeMake(100, 40);
    if (!self.shieldHeader) {
        self.navigationItem.titleView = self.titleView;
    }
}

#pragma mark ----- cancel
- (void)navDismiss{
    [self.titleView dissmissMenu];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navPop{
    [self.titleView dissmissMenu];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButton{
//    if (self.manager.configuration.isMakeRingtone){
//        //教程
//        WKWebViewController *vc = [[WKWebViewController alloc] init];
//        vc.isNavHidden = NO;
//        [vc loadWebURLSring:@"http://mod.huoying666.com/ringguide/ringcourse.html"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
        //你的影响力
//        WKWebViewController *vc = [[WKWebViewController alloc] init];
//        vc.isNavHidden = NO;
//        [vc loadWebURLSring:@"http://mod.huoying666.com/ringguide/ringcourse.html"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark ----- nextStep多张跳转
- (void)nextStep{
    if (self.selectedComplete) {
        self.selectedComplete(self.manager.selectedArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----- 获取相册列表
- (void)getAbumList{
    if (self.manager.albums.count > 0){
        [self getPhotoListWithAlbums:self.manager.albums];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self.manager getAllPhotoAlbums:^(NSArray *albums) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getPhotoListWithAlbums:albums];
            });
        } isFirst:NO];
    });
}


- (void)getPhotoListWithAlbums : (NSArray *)albums {
    __weak typeof(self) weakSelf = self;
    weakSelf.albumModelArray = [NSMutableArray arrayWithArray:albums];
    
    /** 是否屏蔽头部视图 */
    if (!self.shieldHeader) {
        weakSelf.titleView.albumsArray = weakSelf.albumModelArray;
    }
    
    HYAlbumModel *firstAlbumModel  = [weakSelf.albumModelArray firstObject];
    weakSelf.albumModel = firstAlbumModel;
    
    [weakSelf.titleView setTitleContent:firstAlbumModel.albumName];
    [weakSelf getPhotoListWithAlbumModel:weakSelf.albumModel];
}

#pragma mark ----- 获取相册里面所有的照片
- (void)getPhotoListWithAlbumModel : (HYAlbumModel *)albumModel {
    if (albumModel) {
        __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.manager getPhotoListWithAlbumModel:albumModel complete:^(NSArray *allList, NSArray *previewList, NSArray *photoList, NSArray *videoList, NSArray *dateList, HYPhotoModel *firstSelectModel) {
                    if (allList.count) {
                        weakSelf.allArray = allList.mutableCopy;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.libraryCollectionView reloadData];
                            if (weakSelf.allArray.count) {
                                [weakSelf.libraryCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.allArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                            }
                            [weakSelf.titleView setTitleContent:albumModel.albumName];
                            weakSelf.albumModel = albumModel;
                        });
                    }
                }];
            });
    }else{
        HYDebugLog(@"没有找到相册的model");
    }
}

#pragma mark ----- 设置数据
- (void)setupData{
    NSInteger status = [HYPhotoTools getAuthorizationStatus];
    if (status == 4 || status == 3) {
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
        [self getAbumList];
    }
}

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

#pragma mark ----- 请求权限
- (void)authPhotoBrower{
    
    [HYPhotoTools authorizationStatusAuthorizedWithCompletion:^(PHAuthorizationStatus status) {
        if (status == 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showDeniedAlert];
            });
        }else if(status == 4){
            [self showLimitAlert];
        }else if(status == 3){
            [self setupData];
        }
    }];
}

#pragma mark ----- presentAlert
- (void)showDeniedAlert{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"相册权限被禁用，请到设置中授予火萤允许访问相册权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:setAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)showLimitAlert{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"仅可访问部分资源，是否选择更多？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保留当前所选内容" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self setupData];
    }];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"选择更多资源" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 14.0, *)) {
            [[PHPhotoLibrary sharedPhotoLibrary] presentLimitedLibraryPickerFromViewController:self];
        }
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:setAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupData];
    });
}

#pragma mark ----- 转场使用
- (HYPhotoLibraryCell *)currentPreviewCell:(HYPhotoModel *)model {
    if (!model || ![self.allArray containsObject:model]) {
        return nil;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
    return (HYPhotoLibraryCell *)[self.libraryCollectionView cellForItemAtIndexPath:indexPath];
}

- (BOOL)scrollToModel:(HYPhotoModel *)model {
    if ([self.allArray containsObject:model]) {
        [self.libraryCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self.libraryCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection]]];
    }
    return [self.allArray containsObject:model];
}
- (void)scrollToPoint:(HYPhotoLibraryCell *)cell rect:(CGRect)rect {
    CGFloat navBarHeight = KHYHiddenStatusNavbarHeight;

    if (rect.origin.y < navBarHeight) {
        [self.libraryCollectionView setContentOffset:CGPointMake(0, cell.frame.origin.y - navBarHeight)];
    }else if (rect.origin.y + rect.size.height > self.view.bounds.size.height - 50.5 - hyBottomMargin) {
        [self.libraryCollectionView setContentOffset:CGPointMake(0, cell.frame.origin.y - self.view.bounds.size.height + 50.5 + hyBottomMargin + rect.size.height)];
    }
}
#pragma mark - < UICollectionViewDataSource >
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoModel *photoModel = [self.allArray objectAtIndex:indexPath.item];
    photoModel.dateCellIsVisible = YES;
    
    HYPhotoLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoLibraryCellId" forIndexPath:indexPath];
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.item = indexPath.item;
    
    if (self.manager.configuration.cellSelectedTitleColor) {
        cell.selectedTitleColor = self.manager.configuration.cellSelectedTitleColor;
    }else if (self.manager.configuration.selectedTitleColor) {
        cell.selectedTitleColor = self.manager.configuration.selectedTitleColor;
    }
    if (self.manager.configuration.cellSelectedBgColor) {
        cell.selectBgColor = self.manager.configuration.cellSelectedBgColor;
    }else {
        cell.selectBgColor = self.manager.configuration.themeColor;
    }
    photoModel.dateCellIsVisible = YES;

    photoModel.rowCount = self.manager.configuration.rowCount;
    cell.model = photoModel;
    cell.singleSelected = self.manager.configuration.singleSelected;

    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoModel *model;
    if (indexPath.item > self.allArray.count - 1) {
        return;
    }
    model = self.allArray[indexPath.item];
    if (model.type != HYPhotoModelMediaTypeCamera) {
        //        model.dateCellIsVisible = NO;
        //        NSSLog(@"cell消失");
        [(HYPhotoLibraryCell *)cell cancelRequest];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoLibraryCell *cell = (HYPhotoLibraryCell *)[self.libraryCollectionView cellForItemAtIndexPath:indexPath];
    
    
    /** 如果资源在icloud上 */
    if (cell.model.isICloud) {
        if (self.manager.configuration.downloadICloudAsset) {
            if (!cell.model.iCloudDownloading) {
                [cell startRequestICloudAsset];
            }else{
                /** 下载icloud视频的时候给与提示 */
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showTipMessageInWindow:@"正在同步iCloud视频，请稍等"];
                });
            }
        }
        return;
    }
    
    if (self.manager.configuration.singleSelected && self.manager.type == HYPhotoLibraryManagerSelectedTypePhoto) {
        
        HYPhotoModel *model = [self.allArray objectAtIndex:indexPath.item];
        NSArray *modelArray = [NSArray arrayWithObject:model];
        
        // 单选的时候跳转
        if (modelArray.count) {
            if (self.selectedComplete) {
                self.selectedComplete(modelArray);
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else if(self.manager.configuration.singleSelected && self.manager.type == HYPhotoLibraryManagerSelectedTypeVideo){
        // 当单选情况并且选择的是视频时
        HYPhotoModel *photoModel = [self.allArray objectAtIndex:indexPath.item];
                
        [HYPhotoTools getAVAssetWithModel:photoModel startRequestIcloud:^(HYPhotoModel *model, PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(HYPhotoModel *model, double progress) {
            
        } completion:^(HYPhotoModel *model, AVAsset *asset) {
            
            self.asset = (AVURLAsset *)asset;
            NSTimeInterval seconds = model.asset.duration;
            /** 当大于视频限制最长时间或者是小于最短时间时 */
            if (seconds > self.manager.configuration.videoMaxDuration && self.manager.configuration.videoMaxDuration > 0) {
                NSString *toast = [NSString stringWithFormat:@"最长支持%ld分钟的视频",(NSInteger)self.manager.configuration.videoMaxDuration / 60];
                [self.view makeToast:toast duration:2.f position:CSToastPositionCenter];
                return;
            }
            if (seconds < self.manager.configuration.videoMinDuration && self.manager.configuration.videoMinDuration > 0) {
                NSString *toast = [NSString stringWithFormat:@"最短支持%ld秒的视频",(NSInteger)self.manager.configuration.videoMinDuration];
                [self.view makeToast:toast duration:2.f position:CSToastPositionCenter];
                return;
            }
            
            /** 回调block */
            if (self.selectedComplete) {
                if (self.manager.configuration.canVideoPreview) {
                    kWeakSelf
                    HYVideoPlayContext *context = [[HYVideoPlayContext alloc] init];
                    context.isLoopPlay = YES;
                    context.isShowSliderView = NO;
                    HYPhotoLibraryVideoPlayViewController *videoPlayViewController = [[HYPhotoLibraryVideoPlayViewController alloc] initWithAsset:self.asset context:context];
                    [self.navigationController pushViewController:videoPlayViewController animated:NO];
                    videoPlayViewController.sureButtonDidBlock = ^{
                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                            weakSelf.selectedComplete(@[weakSelf.asset]);
                        }];
                    };
                }else {
                    self.selectedComplete(@[self.asset]);
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                return;
            }
            
        } failed:^(HYPhotoModel *model, NSDictionary *info) {
            [self.view makeToast:@"icloud视频下载失败" duration:2.f position:CSToastPositionCenter];
        }];
        
    }else{
        HYPhotoLibraryPreviewViewController *previewVC = [[HYPhotoLibraryPreviewViewController alloc] init];
        NSInteger currentIndex = [self.allArray indexOfObject:cell.model];
        previewVC.delegate = self;
        previewVC.modelArray = self.allArray;
        previewVC.manager = self.manager;
        previewVC.currentModelIndex = currentIndex;
        previewVC.transitioningDelegate = previewVC;
        previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        self.navigationController.delegate = previewVC;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

#pragma mark - < HYPhotoLibraryPreviewViewControllerDelegate >

- (void)photoLibraryPreviewViewDidSelect:(HYPhotoLibraryPreviewViewController *)previewController model:(HYPhotoModel *)model{
    NSMutableArray *indexPathList = [NSMutableArray array];

    if (model.currentAlbumIndex == self.albumModel.index) {
        [indexPathList addObject:[NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection]];
    }
    if (!model.selected) {
        NSInteger index = 0;
        for (HYPhotoModel *subModel in [self.manager selectedArray]) {
            subModel.selectIndexStr = [NSString stringWithFormat:@"%tu",index + 1];
            if (subModel.currentAlbumIndex == self.albumModel.index && subModel.dateCellIsVisible) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:subModel] inSection:subModel.dateSection];
                [indexPathList addObject:indexPath];
            }
            index++;
        }
    }
    if (indexPathList.count) {
        [self.libraryCollectionView reloadItemsAtIndexPaths:indexPathList];
    }
    if (!self.manager.configuration.sendImageTextAdd) {
        if (self.manager.selectedArray.count) {
            
            [self.finishBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"000000" colorDark:@"FFFFFF"] forState:UIControlStateNormal];
            self.finishBtn.enabled = YES;
            self.finishBtn.userInteractionEnabled = YES;
        }else{
            [self.finishBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"0xE5E5E5" lightAlpha:1 colorDark:@"FFFFFF" darkAlpha:0.5] forState:UIControlStateNormal];
            self.finishBtn.enabled = NO;
            self.finishBtn.userInteractionEnabled = NO;
        }
    }
}


- (void)photoLibraryPreviewViewDownLoadICloudAssetComplete:(HYPhotoLibraryPreviewViewController *)previewController model:(HYPhotoModel *)model{
    if (model.iCloudRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:model.iCloudRequestID];
    }
    if (model.dateCellIsVisible) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
        [self.libraryCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self.manager addICloudModel:model];
    }
}


#pragma mark - < HYPhotoLibrary CellDelegate >
- (void)photoLibraryCellRequestICloudAssetComplete:(HYPhotoLibraryCell *)cell {
    if (cell.model.dateCellIsVisible) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:cell.model] inSection:0];
        if (indexPath) {
            [self.libraryCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        [self.manager addICloudModel:cell.model];
    }
}

- (void)photoLibraryCellRequestICloudAssetError:(HYPhotoLibraryCell *)cell{
    [self.view makeToast:@"下载ICloud资源失败请重试" duration:0.6f position:CSToastPositionCenter];
}

- (void)photoLibraryCell:(HYPhotoLibraryCell *)cell didSelectBtn:(UIButton *)selectBtn {
//    HYDebugLog(@"panGesture---isSelectWithPoint: cell---item:%ld",(long)cell.item);
    if (selectBtn.selected) {
        if (cell.model.type != HYPhotoModelMediaTypeCameraVideo && cell.model.type != HYPhotoModelMediaTypeCameraPhoto) {
            cell.model.thumbPhoto = nil;
            cell.model.previewPhoto = nil;
        }
        [self.manager beforeSelectedListdeletePhotoModel:cell.model];
        cell.model.selectIndexStr = @"";
        cell.selectMaskLayer.hidden = YES;
        // 设置selected
        selectBtn.selected = NO;
    }else {
        NSString *str = [self.manager maximumOfJudgment:cell.model];
        HYDebugLog(@"%@ 判断信息",str);
        if (str) {
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [vc addAction:action];
            [self presentViewController:vc animated:YES completion:nil];
            HYDebugLog(@"提示视频最超限");
            return;
        }
        
        if (cell.model.type != HYPhotoModelMediaTypeCameraVideo && cell.model.type != HYPhotoModelMediaTypeCameraPhoto) {
            cell.model.thumbPhoto = cell.imageView.image;
        }
        
        [self.manager beforeSelectedListAddPhotoModel:cell.model];
        cell.selectMaskLayer.hidden = NO;
        
        // 设置selected
        selectBtn.selected = YES;
        [selectBtn setTitle:cell.model.selectIndexStr forState:UIControlStateSelected];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [selectBtn.layer addAnimation:anim forKey:@""];
    }
    
    UIColor *bgColor;
    if (self.manager.configuration.cellSelectedBgColor) {
        bgColor = self.manager.configuration.cellSelectedBgColor;
    }else {
        bgColor = self.manager.configuration.themeColor;
    }
    
    selectBtn.backgroundColor = selectBtn.selected ? bgColor : nil;
    NSMutableArray *indexPathList = [NSMutableArray array];
    if (!selectBtn.selected) {
        NSInteger index = 0;
        for (HYPhotoModel *model in [self.manager selectedArray]) {
            model.selectIndexStr = [NSString stringWithFormat:@"%tu",index + 1];
            if (model.currentAlbumIndex == self.albumModel.index) {
                if (model.dateCellIsVisible) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
                    [indexPathList addObject:indexPath];
                }
            }
            index++;
        }
    }
    
    if (self.manager.videoSelectedType == HYPhotoLibraryManagerVideoSelectedTypeSingle) {
        for (UICollectionViewCell *tempCell in self.libraryCollectionView.visibleCells) {
            if ([tempCell isKindOfClass:[HYPhotoLibraryCell class]]) {
                if ([(HYPhotoLibraryCell *)tempCell model].subType == HYPhotoModelMediaSubTypeVideo) {
                    [indexPathList addObject:[self.libraryCollectionView indexPathForCell:tempCell]];
                }
            }
        }
        if (indexPathList.count) {
            [self.libraryCollectionView reloadItemsAtIndexPaths:indexPathList];
        }
    }else {
        if (!selectBtn.selected) {
            if (indexPathList.count) {
                [self.libraryCollectionView reloadItemsAtIndexPaths:indexPathList];
            }
        }
    }
    
    if (self.manager.selectedArray.count) {
        [self.finishBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"000000" colorDark:@"FFFFFF"] forState:UIControlStateNormal];
        self.finishBtn.enabled = YES;
        self.finishBtn.userInteractionEnabled = YES;
    }else{
        [self.finishBtn setTitleColor:[UIColor hy_colorLightWithLightHex:@"0xE5E5E5" lightAlpha:1 colorDark:@"FFFFFF" darkAlpha:0.5] forState:UIControlStateNormal];
        self.finishBtn.enabled = NO;
        self.finishBtn.userInteractionEnabled = NO;
    }
}

// 屏蔽GIF图片的选择
- (void)photoLibraryCellDidSelectGIF{
    [self.view makeToast:@"暂不支持上传Gif图片" duration:1.0f position:CSToastPositionCenter];
}

#pragma mark ----- scrollviewDetegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}

- (NSInteger)dateItem:(HYPhotoModel *)model {
    NSInteger dateItem = [self.allArray indexOfObject:model];
    return dateItem;
}
- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // 预加载区域是可显示区域的两倍
    CGRect preheatRect = self.libraryCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    //     比较是否显示的区域与之前预加载的区域有不同
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.libraryCollectionView.bounds) / 3.0f) {
        
        // 区分资源分别操作
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.libraryCollectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.libraryCollectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // 更新缓存
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:CGSizeMake((KHYScreenWidth - 3) / 4,(KHYScreenWidth - 3) / 4)
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:CGSizeMake((KHYScreenWidth - 3) / 4,(KHYScreenWidth - 3) / 4)
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // 存储预加载矩形已供比较
        self.previousPreheatRect = preheatRect;
    }
}


- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        HYPhotoModel *model = [self.allArray objectAtIndex:indexPath.item];
        PHAsset *asset = model.asset;
        [assets addObject:asset];
    }
    
    return assets;
}
#pragma mark ----- 懒加载
- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (NSMutableArray *)previewArray {
    if (!_previewArray) {
        _previewArray = [NSMutableArray array];
    }
    return _previewArray;
}

- (HYAlbumPopView *)titleView
{
    if (!_titleView) {
        _titleView = [[HYAlbumPopView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        __weak typeof(self) weakSelf = self;
        _titleView.selectedAtIndex = ^(int index) {
            weakSelf.selectedAlbumIndex = index;
            HYAlbumModel *albumModel = [weakSelf.albumModelArray objectAtIndex:index];
            [weakSelf getPhotoListWithAlbumModel:albumModel];
        };
    }
    return _titleView;
}

- (UICollectionView *)libraryCollectionView {
    if (!_libraryCollectionView) {
        CGFloat collectionViewHeight = KHYScreenHeight - KHYHiddenStatusNavbarHeight;
        _libraryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KHYHiddenStatusNavbarHeight, KHYScreenWidth, collectionViewHeight) collectionViewLayout:self.libraryFlowLayout];
        _libraryCollectionView.backgroundColor = [UIColor hy_colorLightWithLightHex:@"000000" colorDark:@"FFFFFF"];
        _libraryCollectionView.dataSource = self;
        _libraryCollectionView.delegate = self;
        _libraryCollectionView.alwaysBounceVertical = YES;
        [_libraryCollectionView registerClass:[HYPhotoLibraryCell class] forCellWithReuseIdentifier:@"PhotoLibraryCellId"];

        if (@available(iOS 11.0, *)) {
            _libraryCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _libraryCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _libraryCollectionView.scrollIndicatorInsets = _libraryCollectionView.contentInset;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _libraryCollectionView;
}

- (UICollectionViewFlowLayout *)libraryFlowLayout {
        if (!_libraryFlowLayout) {
            _libraryFlowLayout = [[UICollectionViewFlowLayout alloc] init];
            _libraryFlowLayout.itemSize = CGSizeMake((KHYScreenWidth - 3) / 4,(KHYScreenWidth - 3) / 4);
            _libraryFlowLayout.minimumLineSpacing = 1;
            _libraryFlowLayout.minimumInteritemSpacing = 1;
            _libraryFlowLayout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0.5, 0);
        }
        return _libraryFlowLayout;
}

- (HYToolsManager *)toolManager
{
    if (!_toolManager) {
        _toolManager = [[HYToolsManager alloc] init];
    }
    return _toolManager;
}


- (void)showRingToneCourse{
    
    NSDictionary * dict = [XHNetworkCache cacheJsonWithURL:@"lszzJC"];
    if(dict) return;
    [XHNetworkCache saveJsonResponseToCacheFile:@{} andURL:@"lszzJC"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView * view = [[UIView alloc] initWithFrame:keyWindow.bounds];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KHYScreenWidth - 290-11* KHYWidthRatio, KHYHiddenStatusNavbarHeight - 6, 290 , 77 )];
        imageView.image = [UIImage imageNamed:@"img_lszz_jiaocheng"];
        [view addSubview:imageView];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(KHYScreenWidth - 90 - 11*KHYWidthRatio, KHYHiddenStatusNavbarHeight + 9 + 77 , 90 , 38 )];
        [btn setTitle:@"知道了" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor hy_rgbColor:73 g:182 b:255 a:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:16 * KHYWidthRatio];
        btn.layer.cornerRadius = 6 * KHYWidthRatio;
        [btn addTarget:self action:@selector(closeCourse:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [keyWindow addSubview:view];
    });
}

- (void)closeCourse:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}


#pragma mark - 添加滑动手势选中照片
- (void)_addGestureRecognizer {
    // 添加滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.locationSelectCell = nil;
            [self _setStartIndexAndEndIndexLocation:location state:UIGestureRecognizerStateBegan];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            HYPhotoLibraryCell *cell = [self _getLocationSelectCellLocation:location];
            if (cell && cell.item != self.locationSelectCell.item) {
                self.endIndex = cell.item;
                [cell updateItemdidSelect:self.startIndexisSelect];
                self.locationSelectCell = cell;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self _setStartIndexAndEndIndexLocation:location state:UIGestureRecognizerStateEnded];
        }
            break;
        default:
            break;
    }
}

- (HYPhotoLibraryCell *)_getLocationSelectCellLocation:(CGPoint)location {
    NSArray *cells = self.libraryCollectionView.visibleCells;
    HYPhotoLibraryCell *cell = nil;
    for (int i = 0; i < cells.count; i++) {
        cell = cells[i];
        BOOL isLocationSelect = [self _isLocationSelectLocation:location cell:cell];
        if (isLocationSelect) {
            break;
        }
    }
    return cell;
}



/// 定位手指滑动时 开始的首个cell 和 结束的cell
/// @param location 手指在屏幕上 self.view 上的坐标
/// @param state 滑动状态
- (void)_setStartIndexAndEndIndexLocation:(CGPoint)location state:(UIGestureRecognizerState)state {
    
    NSArray *cells = self.libraryCollectionView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        HYPhotoLibraryCell *cell = cells[i];
        BOOL isLocationSelect = [self _isLocationSelectLocation:location cell:cell];
        if (isLocationSelect) {
            NSInteger index =  [self dateItem:cell.model];
            if (UIGestureRecognizerStateBegan == state) {
                self.startIndex = index;
                self.endIndex = index;
                self.startIndexisSelect = cell.selectBtn.selected;
            }
            if (UIGestureRecognizerStateEnded == state) {
                self.endIndex = index;
            }
            break;
        }
    }
}

/// 判断手指滑动时 是否滑动在了对应的cell上
/// @param location 手指在屏幕上 self.view 上的坐标
/// @param cell collectionView 可见visibleCells中的cell
- (BOOL)_isLocationSelectLocation:(CGPoint)location cell:(HYPhotoLibraryCell *)cell {
    
    CGFloat location_x = location.x;
    CGFloat location_y = location.y;
    
    CGRect cellInView = [self.libraryCollectionView convertRect:cell.frame toView:self.view];
    CGPoint point = CGPointMake(cellInView.origin.x, cellInView.origin.y);
    CGFloat cell_x = point.x;
    CGFloat cell_y = point.y;
    CGFloat cell_w = cell.contentView.frame.size.width;
    CGFloat cell_h = cell.contentView.frame.size.height;
    BOOL is_x = location_x > cell_x && location_x < cell_x + cell_w;
    BOOL is_y = location_y > cell_y && location_y < cell_y + cell_h;
    if (is_x && is_y) {
        HYDebugLog(@"panGesture---isSelectWithPoint: cell.item:%ld cell_x:%f cell_y:%f cell_w:%f cell_h:%f",cell.item,cell_x,cell_y,cell_w,cell_h);
        return YES;
    }
    return NO;
}

/// 当滑动结束时 检测在startIndex endIndex 之间是否有状态不一致的cell
- (void)_updateItemdidSelect {// 数量少 算法速度还可以
    if (self.startIndex < self.endIndex) {
        for (NSInteger i = self.startIndex; i <= self.endIndex; i++) {
            HYPhotoModel *photoModel = self.allArray[i];
            [self _isItemdidSelect:photoModel];
        }
    }else {
        for (NSInteger i = self.startIndex; i >= self.endIndex; i--) {
            HYPhotoModel *photoModel = self.allArray[i];
            [self _isItemdidSelect:photoModel];
        }
    }
}

/// 数据model 对应的cell 改变选中的状态
/// @param photoModel model
- (HYPhotoLibraryCell *)_isItemdidSelect:(HYPhotoModel *)photoModel {
    HYPhotoLibraryCell *cell = [self currentPreviewCell:photoModel];
    [cell updateRangeItemdidSelect:self.startIndexisSelect];
    return cell;
}

@end
