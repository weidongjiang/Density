//
//  MBHUDManager.m
//  Vpings
//
//  Created by 徐保学 on 2018/5/29.
//  Copyright © 2018年 朱玉Vpings. All rights reserved.
//

#import "MBHUDManager.h"
#import "MBProgressHUD.h"

@interface MBHUDManager ()

//加载框
@property(nonatomic,strong)MBProgressHUD    *hud;
@property(nonatomic,strong)UIView           *showToView;

@end

@implementation MBHUDManager

+ (instancetype)sharedHUDManager
{
    static MBHUDManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MBHUDManager alloc]init];
    });
    return manager;
}


- (void)showHUDInView:(UIView *)showToView{
    self.showToView = showToView;
    [self hud];
}
- (void)hideHUDInView{
    [self dismissHud];
}

- (MBProgressHUD *)hud{
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.showToView animated:YES];
        _hud.removeFromSuperViewOnHide = YES;
        
//        if (!CGPointEqualToPoint(self.offset, CGPointZero))   _hud.offset = _offset;
        
    }
    return _hud;
}
- (void)dismissHud{
    [_hud hideAnimated:YES];
    _hud = nil;
}

@end
