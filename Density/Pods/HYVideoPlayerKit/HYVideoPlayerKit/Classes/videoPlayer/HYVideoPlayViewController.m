//
//  HYVideoPlayViewController.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/1.
//

#import "HYVideoPlayViewController.h"
#import "HYVideoPlayView.h"
#import "HYUtilsMacro.h"
#import "HYUtilsMacro.h"
#import "UIImage+HYBundleImage.h"
@interface HYVideoPlayViewController ()

@property (nonatomic, strong) HYVideoPlayView *playView;

@end

@implementation HYVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)dealloc {
    HYDebugLog(@"%s",__func__);
    [self cleanAll];
}

- (instancetype)initWithUrl:(NSURL *)url context:(HYVideoPlayContext *)context {
    if (self = [super init]) {
        CGFloat _statusBarHeight =  0;
        if (@available(iOS 13.0, *)) {
            _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
            _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        CGRect frame = CGRectMake(0, _statusBarHeight, KHYScreenWidth, KHYScreenHeight-_statusBarHeight-kHYTabBarSafe);
        self.playView = [[HYVideoPlayView alloc] initWithFrame:frame url:url context:context];
        [self addViewWithFrame:frame];
    }
    return self;
}

- (instancetype)initWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context {
    if (self = [super init]) {
        CGFloat _statusBarHeight =  0;
        if (@available(iOS 13.0, *)) {
            _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
            _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        CGRect frame = CGRectMake(0, _statusBarHeight, KHYScreenWidth, KHYScreenHeight-_statusBarHeight-kHYTabBarSafe);
        self.playView = [[HYVideoPlayView alloc] initWithFrame:frame asset:asset context:context];
        [self addViewWithFrame:frame];
    }
    return self;
}

- (void)addViewWithFrame:(CGRect)frame {
    self.playView.frame = frame;
    [self.view addSubview:self.playView];
    CGFloat _statusBarHeight =  0;
    if (@available(iOS 13.0, *)) {
        _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    CGFloat navBackView_h = 44;
    UIView *navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _statusBarHeight, KHYScreenWidth, navBackView_h)];
    [self.view addSubview:navBackView];
    
    CGFloat backButton_w_h = 24;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 10, backButton_w_h, backButton_w_h)];
    [backButton setBackgroundImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_back_white" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDid) forControlEvents:UIControlEventTouchUpInside];
    [navBackView addSubview:backButton];
    
}

- (void)play {
    [self.playView play];
}

- (void)pause {
    [self.playView pause];
}

- (void)seekToTime:(double)time {
    [self.playView seekToTime:time];
}

- (void)backButtonDid {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)cleanAll {
    [self pause];
    if (self.playView) {
        self.playView = nil;
    }
}


@end
