//
//  UIResponder+HYCurrentViewController.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/12.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (HYCurrentViewController)
//获取当前view的superView对应的控制器
- (UIViewController *)hy_currentViewController;
@end

NS_ASSUME_NONNULL_END
