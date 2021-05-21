//
//  HYPhotoConfiguration.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/9/28.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoConfiguration.h"
#import "HYPhotoTools.h"
#import "HYUtilsDeviceMacro.h"

@implementation HYPhotoConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.open3DTouchPreview = YES;
    self.openCamera = YES;
    self.lookLivePhoto = NO;
    self.lookGifPhoto = YES;
    self.selectTogether = YES;
    self.maxNum = 50;
    self.photoMaxNum = 50;
    self.videoMaxNum = 1;
    
    self.downloadICloudAsset = YES;
    self.videoMaxDuration = 0.f;
    self.videoMinDuration = 0.f;

    if ([UIScreen mainScreen].bounds.size.width != 320) {
        self.cameraCellShowPreview = YES;
    }
    self.customAlbumName = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    self.horizontalRowCount = 6;
    
    self.pushTransitionDuration = 0.45f;
    self.popTransitionDuration = 0.35f;
    self.popInteractiveTransitionDuration = 0.35f;
    self.transitionAnimationOption = UIViewAnimationOptionCurveEaseOut;
    if (KHYISIPhoneX) {
        self.clarityScale = 2.4f;
    }else if ([UIScreen mainScreen].bounds.size.width == 320) {
        self.clarityScale = 1.2;
    }else if ([UIScreen mainScreen].bounds.size.width == 375) {
        self.clarityScale = 1.8;
    }else {
        self.clarityScale = 2.0;
    }
    
    self.singleJumpEdit = YES;
    self.requestImageAfterFinishingSelection = YES;
    self.canVideoPreview = NO;
    self.canSlideSelectMoreItem = YES;
}

- (void)setClarityScale:(CGFloat)clarityScale {
    if (clarityScale <= 0.f) {
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            _clarityScale = 0.8;
        }else if ([UIScreen mainScreen].bounds.size.width == 375) {
            _clarityScale = 1.4;
        }else {
            _clarityScale = 1.7;
        }
    }else {
        _clarityScale = clarityScale;
    }
}
- (UIColor *)themeColor {
    if (!_themeColor) {
        _themeColor =  [UIColor colorWithRed:0/255.0 green:220/255.0 blue:66/255.0 alpha:1/1.0];
    }
    return _themeColor;
}



@end
