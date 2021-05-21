//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString *)message isWindiw:(BOOL)isWindow
{
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    if (message) {
        hud.detailsLabel.text = message;
    }
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message
{
    [self showTipMessage:message isWindow:true timer:1];
}
+ (void)showTipMessageInView:(NSString*)message
{
    [self showTipMessage:message isWindow:false timer:1];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer
{
    [self showTipMessage:message isWindow:true timer:aTimer];
}
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer
{
    [self showTipMessage:message isWindow:false timer:aTimer];
}
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
}

#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message
{
    [self showActivityMessage:message isWindow:true timer:0];
}
+ (void)showActivityMessageInView:(NSString*)message
{
    [self showActivityMessage:message isWindow:false timer:0];
}
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer
{
    [self showActivityMessage:message isWindow:true timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer
{
    [self showActivityMessage:message isWindow:false timer:aTimer];
}

+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{

        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (aTimer > 0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }
    });
}
#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Success";
    [self showCustomIconInWindow:name message:Message completionBlock:nil];
}
+ (void)showSuccessMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Success";
    [self showCustomIconInWindow:name message:Message completionBlock:completionBlock];
}


+ (void)showSuccessMessageInViewWithMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Success";
    [self showCustomIconInView:name message:Message completionBlock:nil];
}

+ (void)showSuccessMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Success";
    [self showCustomIconInView:name message:Message completionBlock:completionBlock];
}

+ (void)showErrorMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Error";
    [self showCustomIconInWindow:name message:Message completionBlock:nil];
}
+ (void)showErrorMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Error";
    [self showCustomIconInWindow:name message:Message completionBlock:completionBlock];
}


+ (void)showErrorMessageInViewWithMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Error";
    [self showCustomIconInView:name message:Message completionBlock:nil];
}

+ (void)showErrorMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Error";
    [self showCustomIconInView:name message:Message completionBlock:completionBlock];
}

+ (void)showInfoMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Info";
    [self showCustomIconInWindow:name message:Message completionBlock:nil];
}
+ (void)showInfoMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Info";
    [self showCustomIconInWindow:name message:Message completionBlock:completionBlock];
}


+ (void)showInfoMessageInViewWithMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Info";
    [self showCustomIconInView:name message:Message completionBlock:nil];
}
+ (void)showInfoMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Info";
    [self showCustomIconInView:name message:Message completionBlock:completionBlock];
}


+ (void)showWarnMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Warn";
    [self showCustomIconInWindow:name message:Message completionBlock:nil];
}
+ (void)showWarnMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Warn";
    [self showCustomIconInWindow:name message:Message completionBlock:completionBlock];
}


+ (void)showWarnMessageInViewWithMessage:(NSString *)Message
{
    NSString *name =@"MBHUD_Warn";
    [self showCustomIconInView:name message:Message completionBlock:nil];
}
+ (void)showWarnMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock
{
    NSString *name =@"MBHUD_Warn";
    [self showCustomIconInView:name message:Message completionBlock:completionBlock];
}



+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message completionBlock : (void (^)(void))completionBlock
{
    [self showCustomIcon:iconName message:message isWindow:true completionBlock:completionBlock];
    
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message completionBlock : (void (^)(void))completionBlock
{
    
    [self showCustomIcon:iconName message:message isWindow:false completionBlock:completionBlock];
}

+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow completionBlock : (void (^)(void))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{

    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
   
    [hud hideAnimated:YES afterDelay:1.0f];
    if (completionBlock) {
        hud.completionBlock = completionBlock;;
    }
    });
}

+ (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIView  *winView =(UIView *)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:winView animated:YES];
    [self hideHUDForView:[self getCurrentUIVC].view animated:YES];
    });

}

+ (void)hideHUDWithCompletionBlock:(void (^)(void))completionBlock{
  
    UIView  *view =(UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud == nil) {
        view = [self getCurrentUIVC].view;
        hud = [self HUDForView:view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hud) {
            hud.completionBlock = completionBlock;
        }
    });

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
    });
    NSLog(@"隐藏hud");
}


+ (void)hideHUDDelay:(double)time{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((NSTimeInterval)time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
        [self hideHUDForView:winView animated:YES];
        [self hideHUDForView:[self getCurrentUIVC].view animated:YES];
    });
}

//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentWindowVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    if ([window subviews].count != 0) {
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            result = nextResponder;
        }
        else
        {
            result = window.rootViewController;
        }
        return  result;
    }else{
        return window.rootViewController;
    }
}

+(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}




@end
