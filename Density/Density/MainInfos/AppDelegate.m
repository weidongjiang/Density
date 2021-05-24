//
//  AppDelegate.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "AppDelegate.h"
#import "MDRootViewController.h"
#import "MDBaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
    MDBaseNavigationController *vc = [MDRootViewController appRootViewController];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    return YES;
}

@end
