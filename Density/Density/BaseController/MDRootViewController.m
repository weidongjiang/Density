//
//  MDRootViewController.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "MDRootViewController.h"
#import "MDBaseTabBarController.h"
#import "MDWordViewController.h"
#import "MDChatViewController.h"
#import "MDRecordViewController.h"

@implementation MDRootViewController

+ (MDBaseNavigationController *)appRootViewController {
    MDBaseNavigationController *navigationController = [[MDBaseNavigationController alloc] initWithRootViewController:[self rootTabBarController]];
    navigationController.navigationBar.hidden = YES;
    return navigationController;
}


+ (MDBaseTabBarController *)rootTabBarController {
    
    MDBaseTabBarController *tabBarController = [[MDBaseTabBarController alloc] init];
    
    MDChatViewController *chatVC = [[MDChatViewController alloc] init];
    UIImage *tabBarItem_chatVC_image = [UIImage imageNamed:@"icon_tabbar_01"];
    UIImage *tabBarItem_chatVC_selectedImage = [UIImage imageNamed:@"icon_tabbar_01_s"];
    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[tabBarItem_chatVC_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[tabBarItem_chatVC_selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    chatVC.tabBarItem.badgeValue = @"9";
    chatVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    
    MDRecordViewController *recordVC = [[MDRecordViewController alloc] init];
    UIImage *tabBarItem_recordVC_image = [UIImage imageNamed:@"icon_tabbar_02"];
    UIImage *tabBarItem_recordVC_selectedImage = [UIImage imageNamed:@"icon_tabbar_02_s"];
    recordVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[tabBarItem_recordVC_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[tabBarItem_recordVC_selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    recordVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    MDWordViewController *wordVC = [[MDWordViewController alloc] init];
    UIImage *tabBarItem_wordVC_image = [UIImage imageNamed:@"icon_tabbar_03"];
    UIImage *tabBarItem_wordVC_selectedImage = [UIImage imageNamed:@"icon_tabbar_03_s"];
    wordVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[tabBarItem_wordVC_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[tabBarItem_wordVC_selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    wordVC.tabBarItem.badgeValue = @"9";
    wordVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    tabBarController.viewControllers = @[chatVC,recordVC,wordVC];
    return tabBarController;
}


@end
