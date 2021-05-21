//
//  HYPhotoLibraryVideoPlayViewController.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/12.
//

#import "HYPhotoLibraryVideoPlayViewController.h"
#import "UIImage+HYBundleImage.h"
#import "HYUtilsMacro.h"
#import "HYUtilsDeviceMacro.h"
#import "UIImage+HYImage.h"

@interface HYPhotoLibraryVideoPlayViewController ()

@property (nonatomic, strong) HYVideoPlayView *videoPlayView;

@end

@implementation HYPhotoLibraryVideoPlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (instancetype)initWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context {
    if (self = [super init]) {
        [self iniUIWithAsset:asset context:context];
    }
    return self;
}

- (void)dealloc {
    HYDebugLog(@"%s",__func__);
    [self cleanAll];
}

- (void)cleanAll {
    if (self.videoPlayView) {
        [self.videoPlayView stop];
        self.videoPlayView = nil;
    }
}

- (void)iniUIWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *whiteImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_white" bundleName:@"HYPhotoLibraryKit"];
    UIImage *blackImage = [UIImage hy_getBundleImageWithImageName:@"HYPhotoLibraryKit_icon_back_black" bundleName:@"HYPhotoLibraryKit"];
    [backButton setImage:[UIImage hy_imageLightImage:blackImage darkImage:whiteImage] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDid) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backBaritem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBaritem;
    self.videoPlayView = [[HYVideoPlayView alloc] initWithFrame:self.view.bounds asset:asset context:context];
    [self.view addSubview:self.videoPlayView];
    
    
    CGFloat sureButton_w = 160;
    CGFloat sureButton_h = 48;
    CGFloat sureButton_bottom_m = 24;
    CGFloat sureButton_x = (KHYScreenWidth - sureButton_w)*0.5;
    CGFloat sureButton_y = KHYScreenHeight - sureButton_bottom_m - kHYTabBarSafe - sureButton_h;
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(sureButton_x, sureButton_y, sureButton_w, sureButton_h)];
    sureButton.layer.cornerRadius = 12;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [sureButton setBackgroundColor:[UIColor colorWithRed:25/255.0 green:140/255.0 blue:255/255.0 alpha:1]];
    [sureButton addTarget:self action:@selector(sureButtonDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

- (void)backButtonDid {
    if (self.backButtonActionBlock) {
        self.backButtonActionBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureButtonDid {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.sureButtonDidBlock) {
        self.sureButtonDidBlock();
    }
}

@end
