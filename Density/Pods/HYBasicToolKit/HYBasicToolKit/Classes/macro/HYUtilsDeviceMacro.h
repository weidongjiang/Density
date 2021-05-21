//
//  HYUtilsDeviceMacro.h
//  Pods
//
//  Created by 蒋伟东 on 2021/4/27.
//

#ifndef HYUtilsDeviceMacro_h
#define HYUtilsDeviceMacro_h

#define KHYDevice_code                 ([[[UIDevice currentDevice] identifierForVendor] UUIDString])
#define KHYVersion_Code                [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define KHYDevice_Model                [[UIDevice alloc] init].model
#define KHYDevice_SystemVersion        [[UIDevice alloc] init].systemVersion
#define KHYDevice_Name                 [[UIDevice alloc] init].name
#define KHYDevice_SystemName           [[UIDevice alloc] init].systemName
#define KHYVERSIONNAME                 [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]
#define KHYBUNDLENNAME                 [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"]
#define KHYAPPNNAME                    [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]

#define KHYISIOS9                      ([[UIDevice currentDevice].systemVersion intValue]>=9?YES:NO)
#define KHYISIOS10                     ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)
#define KHYISIOS11                     ([[UIDevice currentDevice].systemVersion intValue]>=11?YES:NO)
#define KHYISIOS13                     ([[UIDevice currentDevice].systemVersion intValue]>12?YES:NO)
#define KHYISIOS14                     ([[UIDevice currentDevice].systemVersion intValue]>13?YES:NO)
#define KHYSYSTEM_IS_IOS7              (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_0)
#define KHYSYSTEM_IS_IOS8              (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
#define KHYSYSTEM_IDFA                 [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define KHYSYSTEM_IDFV                 [[[UIDevice currentDevice] identifierForVendor] UUIDString]



#define KHYIPAD                      (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? YES : NO)

// 获取物理屏幕的尺寸
#define KHYIPhone4                   ([UIScreen mainScreen].bounds.size.height == 480)
#define KHYIPhone5                   ([UIScreen mainScreen].bounds.size.height == 568)
#define KHYIPhone6                   ([UIScreen mainScreen].bounds.size.height == 667)
#define KHYIPhone6P                  ([UIScreen mainScreen].bounds.size.height == 736)
#define KHYISPhoneFive               (([[UIScreen mainScreen] bounds].size.width < 375) ? YES : NO)


//判断iPhoneXK_
#define K_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define K_IS_IPHONE_Xr  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs
#define K_IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define K_IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone11
#define K_IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone11 pro
#define K_IS_IPHONE_11_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone11 pro max
#define K_IS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone12
#define K_IS_IPHONE_12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone12 mini
#define K_IS_IPHONE_12_Mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone12 pro
#define K_IS_IPHONE_12_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone12 pro max
#define K_IS_IPHONE_12_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)


// 是否是带刘海的全面屏
#define K_iPhone_FullScreen ((K_IS_IPHONE_X || K_IS_IPHONE_Xr || K_IS_IPHONE_Xs || K_IS_IPHONE_Xs_Max || K_IS_IPHONE_11 || K_IS_IPHONE_11_Pro || K_IS_IPHONE_11_Pro_Max || K_IS_IPHONE_12 || K_IS_IPHONE_12_Mini || K_IS_IPHONE_12_Pro || K_IS_IPHONE_12_Pro_Max) ? YES : NO)


#define KHYISIPhoneX                  K_iPhone_FullScreen
#define KHYWidthRatio                 (KHYScreenHeight == 812.0 ? 375.0/375.0 : KHYScreenWidth/375.0)
#define KHYHeightRatio                (KHYScreenHeight == 812.0 ? 700.0/667.0 : KHYScreenWidth/667.0)


#define KHYScreenHeight               [UIScreen mainScreen].bounds.size.height
#define KHYScreenWidth                [UIScreen mainScreen].bounds.size.width
#define KHYWidthRatio                 (KHYScreenHeight == 812.0 ? 375.0/375.0 : KHYScreenWidth/375.0)
#define KHYHeightRatio                (KHYScreenHeight == 812.0 ? 700.0/667.0 : KHYScreenWidth/667.0)
#define kScreenHeight                 KHYScreenHeight
#define kScreenWidth                  KHYScreenWidth

#define KHYHiddenStatusNavbarHeight   (K_iPhone_FullScreen ? 88 : 64)
#define kHYHomePageBottomIconWidth    (K_iPhone_FullScreen ? 26 : 24)
#define kHYHomePageSegementH          (K_iPhone_FullScreen ? 72 : 64)
#define kHYTabBarHeight               (K_iPhone_FullScreen ? 83 : 49)
#define kHYTabBarSafe                 (K_iPhone_FullScreen ? 29 : 0)


#define kHYItemPictureCompressSize      CGSizeMake(400,550)
#define kHYItemVideoPreviewCompressSize CGSizeMake(350,500)

/**
 取消自动适配 ScrollView 的 Insets 行为
 @param scrollView 滑动视图
 @param vc 所在控制器
 */
#define KHYDisbaleAutoAdjustScrollViewInsets(scrollView, vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
if (@available(iOS 11.0,*))  {\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop")\
} while (0);



#endif /* HYUtilsDeviceMacro_h */
