//
//  UIImage+HYBundleImage.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HYBundleImage)

/// 获取图片
/// @param name 图片名称
+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name;

/// 获取图片
/// @param name 图片名称
/// @param bundleName 所在工程bundleName
+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName;


/// 获取图片
/// @param name 图片名称
/// @param bundleForClass bundleForClass
+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name bundleForClass:(Class)bundleForClass;

/// 获取图片 在podfile 里面使用use_frameworks!
/// @param name 图片名称
/// @param bundleName bundleName description
+ (UIImage *)hy_getBundleFrameworksImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName;

/// 获取图片 在podfile 里面 没有 使用use_frameworks!
/// @param name 图片名称
/// @param bundleName bundleName description
+ (UIImage *)hy_getBundleNOFrameworksImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName;

/// 获取图片 兼容 在podfile 里面 有没有 使用use_frameworks! 都可以
/// @param name 图片名称
/// @param bundleName bundleName description
+ (UIImage *)hy_getBundleImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
