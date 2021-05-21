//
//  HYEditVideoViewController.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/29.
//

#import "HYEditVideoViewController.h"
#import "HYVideoPlayView.h"
#import "HYEditVideoModuleView.h"
#import "HYVideoPlayViewController.h"
#import "HYEditVideoTipView.h"
#import "HYUtilsMacro.h"
#import "UIImage+HYBundleImage.h"
#import "UIView+HYFrame.h"
#import "ZYNetworking.h"

@interface HYEditVideoViewController ()

@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) HYEditVideoModuleView  *editModuleView;
@property (nonatomic, strong) HYVideoPlayView    *videoPlayView;
@property (nonatomic, strong) UIButton               *videoAddButton;
@property (nonatomic, assign) int  startTime;
@property (nonatomic, assign) int  endTime;
@property (nonatomic, assign) int  imageTime;
@property (nonatomic, strong) UIButton               *backButton;
@property (nonatomic, strong) UIButton               *addButton;
@property (nonatomic, strong) HYEditVideoTipView     *tipView;
@property (nonatomic, strong) UILabel                *cutTipsLabel;

@end


#define KEditModuleView_h 60 //
#define KdownloadVideoSaveToPath @"downloadVideo.mp4"

@implementation HYEditVideoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    if (self.editModuleView) {
        self.editModuleView = nil;
    }
}

- (instancetype)initWithUrl:(NSURL *)url {
    if (self == [super init]) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        self.asset = asset;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithAsset:(AVURLAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.startTime = 0;
    self.endTime = [HYWditVideoCutTools getVideoTimeWithURL:self.asset.URL];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *backButton_image = [UIImage hy_getBundleImageWithImageName:@"HYEditVideoKit_icon_back_white" bundleName:@"HYEditVideoKit"];
    [backButton setImage:backButton_image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDid) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backBaritem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.backButton = backButton;
    self.navigationItem.leftBarButtonItem = backBaritem;
    
    CGFloat addButton_w = 54;
    CGFloat addButton_h = 32;
    CGFloat addButton_x = KHYScreenWidth - 12 - addButton_w;
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(addButton_x, 6, addButton_w, addButton_h)];
    [addButton setBackgroundColor:[UIColor colorWithRed:25/255.0 green:140/255.0 blue:255/255.0 alpha:1]];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = 6;
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton addTarget:self action:@selector(addButtonDid) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    

    kWeakSelf
    CGFloat editModuleView_y = KHYScreenHeight - KEditModuleView_h - kHYTabBarSafe;
    self.editModuleView = [[HYEditVideoModuleView alloc] initWithFrame:CGRectMake(0, editModuleView_y, KHYScreenWidth, KEditModuleView_h)];
    [self.view addSubview:self.editModuleView];
    self.editModuleView.getTimeRange = ^(CGFloat startTime, CGFloat endTime, CGFloat imageTime) {
        NSLog(@"startTime----%f: endTime----%f: imageTime----%f:",startTime,endTime,imageTime);
        weakSelf.startTime = ceil(startTime);
        weakSelf.endTime = ceil(endTime);
        weakSelf.imageTime = ceil(imageTime);
        
        weakSelf.videoPlayView.startPlayTime = weakSelf.startTime;
        weakSelf.videoPlayView.endPlayTime = weakSelf.endTime;
        
        [weakSelf jumpToTime:weakSelf.imageTime];
    };
    
    self.editModuleView.cutWhenDragEnd = ^{
        [weakSelf.videoPlayView seekToTime:weakSelf.startTime];
        [weakSelf.videoPlayView play];
        [weakSelf updateCutTipsLabel];
    };
    
    self.editModuleView.cutWhenDragBegan = ^{
        [weakSelf.videoPlayView pause];
    };
    
    self.editModuleView.cutWhenDragChanged = ^{
        [weakSelf.videoPlayView pause];
        [weakSelf updateCutTipsLabel];
    };
    CGFloat _statusBarHeight =  0;
    if (@available(iOS 13.0, *)) {
        _statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    CGFloat videoPlayView_y = _statusBarHeight + 44;
    CGFloat videoPlayView_h = KHYScreenHeight - (videoPlayView_y) - KEditModuleView_h - kHYTabBarSafe;
    
    HYVideoPlayContext *context = [[HYVideoPlayContext alloc] init];
    context.isLoopPlay = YES;
    context.isShowSliderView = NO;
    self.videoPlayView = [[HYVideoPlayView alloc] initWithFrame:CGRectMake(0, videoPlayView_y, KHYScreenWidth, videoPlayView_h) asset:self.asset context:context];
    [self.view addSubview:self.videoPlayView];
    
    self.videoPlayView.thumbnailImagesBlock = ^(NSArray * _Nullable images, double totalTime) {
        [weakSelf.editModuleView setThumbnailImages:images totalTime:totalTime];
    };
    
    self.videoPlayView.currentTimeBlock = ^(double currentTime, double totalTime) {
        [weakSelf.editModuleView updateMoveLineViewCurrentTime:currentTime duration:totalTime];
    };
     
    
    self.tipView = [[HYEditVideoTipView alloc] initWithFrame:CGRectMake(0, 0, KHYScreenWidth, KHYScreenHeight)];
    [self.view addSubview:self.tipView];
    self.tipView.hidden = YES;
    
    self.cutTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.editModuleView.hy_origin.y-30, KHYScreenWidth, 20)];
    self.cutTipsLabel.font = [UIFont systemFontOfSize:15];
    self.cutTipsLabel.textColor = [UIColor whiteColor];
    self.cutTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.cutTipsLabel];
    [self updateCutTipsLabel];

}

- (void)updateCutTipsLabel {
    NSInteger min = (self.endTime-self.startTime)/60;
    NSInteger min_min = min/10;
    NSInteger min_ss = min%10;
    NSInteger ss = (self.endTime-self.startTime)%60;
    NSInteger ss_min = ss/10;
    NSInteger ss_ss = ss%10;
    if (min_min >= 1) {
        min_min = 1;
        min_ss = 0;
        ss_min = 0;
        ss_ss = 0;
    }
    self.cutTipsLabel.text = [NSString stringWithFormat:@"已选取%ld%ld:%ld%ld分钟，最多能选取10分钟",(long)min_min,min_ss,ss_min,ss_ss];
}

- (void)jumpToTime:(CGFloat )time {
    [self.videoPlayView pause];
    [self.videoPlayView seekToTime:time];
}

- (void)addButtonDid {
    if (!self.asset) {
        return;
    }
    
    if (self.startTime < 0) {
        return;
    }
    
    if (self.endTime < self.startTime) {
        return;
    }
    
    [self.videoPlayView pause];
    
    self.backButton.userInteractionEnabled = NO;
    self.addButton.userInteractionEnabled = NO;
    
    self.tipView.hidden = NO;

    if ([self.asset.URL.absoluteString hasPrefix:@"http://"] || [self.asset.URL.absoluteString hasPrefix:@"https://"]) {
        [self downloadWithUrl:self.asset.URL.absoluteString];
    }else {
        [self _creatNewVideoUrl:self.asset.URL];
    }
    
    
}

- (void)_creatNewVideoUrl:(NSURL *)videoUrl {
    
    AiWditVideoTimeRange range = {self.startTime,self.endTime - self.startTime};
    NSLog(@"startTime---%d  endTime---%d",self.startTime,self.endTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipView.textLabelText = @"正在裁剪视频\n请勿离开当前页面";
        self.tipView.progress = 1;
    });
    kWeakSelf
    [HYWditVideoCutTools sharedManager].videoAverageBitRate = 2000*1000;
    [HYWditVideoCutTools sharedManager].videoExpectedSourceFrameRate = 30;
    [HYWditVideoCutTools sharedManager].videoMAXSide = 1280;
    [[HYWditVideoCutTools sharedManager] creatNewVideoUrl:videoUrl progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tipView.progress = progress*100;
        });
    } captureVideoWithRange:range completion:^(NSURL * _Nonnull outPutUrl, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backButton.userInteractionEnabled = YES;
            weakSelf.addButton.userInteractionEnabled = YES;
            weakSelf.tipView.hidden = YES;
            
            if (outPutUrl && !error) {
                if (weakSelf.editVideoCompletionBlock) {
                    weakSelf.editVideoCompletionBlock(outPutUrl);
                }
                if (weakSelf.backButtonActionBlock) {
                    weakSelf.backButtonActionBlock();
                }
            }
            
            if (!outPutUrl && error) {
                NSLog(@"VideoCut error code %ld userInfo %@",(long)error.code,error.userInfo);
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"裁剪失败，请重试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [vc addAction:action];
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
        });
    }];
}

- (void)downloadWithUrl:(NSString *)url {
    NSString *saveToPath = [[[HYWditVideoCutTools sharedManager] creatEditVideoOutPutPath] stringByAppendingPathComponent:KdownloadVideoSaveToPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:saveToPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:saveToPath error:nil];
    }
    kWeakSelf
    [[ZYNetworking sharedZYNetworking] downloadWithUrl:url saveToPath:saveToPath progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        NSLog(@"Progress--%lld%@",bytesProgress*100/totalBytesProgress,@"%");
        weakSelf.tipView.hidden = NO;
        weakSelf.tipView.progress = bytesProgress*100/totalBytesProgress;
        weakSelf.tipView.textLabelText = @"正在准备中...\n请勿离开当前页面";
        } success:^(id response) {
            NSLog(@"downloadWithUrl success");
            [weakSelf _creatNewVideoUrl:[NSURL fileURLWithPath:saveToPath]];
        } failure:^(NSError *error) {
            NSLog(@"downloadWithUrl error");
            weakSelf.tipView.hidden = YES;
        } showHUD:YES];
}

- (void)backButtonDid {
    if (self.backButtonActionBlock) {
        self.backButtonActionBlock();
    }
}

@end
