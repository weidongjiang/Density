//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;

+ (void)showSuccessMessageInViewWithMessage:(NSString *)Message;
+ (void)showErrorMessageInViewWithMessage:(NSString *)Message;
+ (void)showInfoMessageInViewWithMessage:(NSString *)Message;
+ (void)showWarnMessageInViewWithMessage:(NSString *)Message;

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message completionBlock : (void (^)(void))completionBlock;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message completionBlock : (void (^)(void))completionBlock;


+ (void)hideHUD;

+ (void)hideHUDWithCompletionBlock : (void (^)(void))completionBlock;


+ (void)showSuccessMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showSuccessMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showErrorMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showErrorMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showInfoMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showInfoMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showWarnMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;
+ (void)showWarnMessageInViewWithMessage:(NSString *)Message completionBlock : (void (^)(void))completionBlock;



@end
