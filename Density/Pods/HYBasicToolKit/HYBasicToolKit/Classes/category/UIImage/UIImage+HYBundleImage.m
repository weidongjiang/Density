//
//  UIImage+HYBundleImage.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/27.
//

#import "UIImage+HYBundleImage.h"

@implementation UIImage (HYBundleImage)

+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName {
    //屏幕比例
    NSInteger scale = [UIScreen mainScreen].scale;
    //拼接图片名称
    NSString *imageName = [NSString stringWithFormat:@"%@@%zdx",name,scale];
    NSString *bundleNamePath = [NSString stringWithFormat:@"%@.bundle",bundleName];
    //路径
    NSString *bundlepath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",bundleNamePath]];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlepath];
    UIImage *image = [UIImage imageNamed:imageName inBundle:resource_bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name {
    //获取当前所在bundle
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSDictionary *dic = currentBundle.infoDictionary;
    //获取bundle名
    NSString *bundleName = dic[@"CFBundleExecutable"];
    
    return [UIImage hy_getmainBundleImageWithImageName:name bundleName:bundleName];
}


+ (UIImage *)hy_getmainBundleImageWithImageName:(NSString *)name bundleForClass:(Class)bundleForClass {
    
    //获取当前所在bundle
    NSBundle *currentBundle = [NSBundle bundleForClass:bundleForClass];
    NSDictionary *dic = currentBundle.infoDictionary;
    //获取bundle名
    NSString *bundleName = dic[@"CFBundleExecutable"];
    
    //屏幕比例
    NSInteger scale = [UIScreen mainScreen].scale;
    //拼接图片名称
    NSString *imageName = [NSString stringWithFormat:@"%@@%zdx",name,scale];
    NSString *bundleNamePath = [NSString stringWithFormat:@"%@.bundle",bundleName];
    //路径
    NSString *bundlepath = [[NSBundle bundleForClass:bundleForClass].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",bundleNamePath]];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlepath];
    UIImage *image = [UIImage imageNamed:imageName inBundle:resource_bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (UIImage *)hy_getBundleFrameworksImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName {
    
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:bundleName];
    associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    if (!associateBundleURL) {
        return nil;
    }
    NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
    associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    if (!associateBundleURL) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (UIImage *)hy_getBundleNOFrameworksImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName {
    NSURL *associateBundleURL = [NSBundle mainBundle].resourceURL;
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",bundleName]];

    if (!associateBundleURL) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

+ (UIImage *)hy_getBundleImageWithImageName:(NSString *)name bundleName:(NSString *)bundleName {
    UIImage *image = [UIImage hy_getBundleFrameworksImageWithImageName:name bundleName:bundleName];
    if (image) {
        return image;
    }
    
    return [UIImage hy_getBundleNOFrameworksImageWithImageName:name bundleName:bundleName];
}

@end
