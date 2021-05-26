//
//  MDBaseTabBarController.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "MDBaseTabBarController.h"
#import <Masonry/Masonry.h>
#import "MDTabBarTransitionDelegate.h"

@interface MDBaseTabBarController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger subControllerCount;
@property (nonatomic, strong) MDTabBarTransitionDelegate *tabBarTrasitionDelegate;

@end

@implementation MDBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarTrasitionDelegate = [[MDTabBarTransitionDelegate alloc] init];
    self.tabBarTrasitionDelegate.interactive = YES;
    self.delegate = self.tabBarTrasitionDelegate;
    
    self.tabBar.tintColor = [UIColor greenColor];

    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc] init];
    [panGr addTarget:self action:@selector(handlerPanGr:)];
    [self.view addGestureRecognizer:panGr];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.subControllerCount = self.viewControllers.count;

}

- (void)viewControllershandlerPanNotification:(NSNotification *)noti {
    HYDebugLog(@"noti--%@",noti);
    NSString *dragging = [noti.userInfo hy_stringForKey:@"Dragging"];
    if ([dragging isEqual:@"left"]) {
        if (self.selectedIndex > 0) {
            self.selectedIndex -= 1;
        }
    }
    if ([dragging isEqual:@"right"]) {
        if (self.selectedIndex < self.subControllerCount) {
            self.selectedIndex += 1;
        }
    }
}

- (void)handlerPanGr:(UIPanGestureRecognizer *)pan {

    CGFloat transitionX = [pan translationInView:self.view].x;
    CGFloat transtionAbs = transitionX > 0 ? transitionX : -transitionX;
    CGFloat progress = transtionAbs / self.view.frame.size.width;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint velocity = [pan velocityInView:self.view];
            if (velocity.x < 0) {
                if (self.selectedIndex < self.subControllerCount) {
                    self.selectedIndex += 1;
                }
            }else {
            
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.tabBarTrasitionDelegate.interactionController updateInteractiveTransition:progress];
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            if (progress > 0.3) {
                self.tabBarTrasitionDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarTrasitionDelegate.interactionController finishInteractiveTransition];
            }else {
            
                self.tabBarTrasitionDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarTrasitionDelegate.interactionController cancelInteractiveTransition ];
            }
            self.tabBarTrasitionDelegate.interactive = NO;
            break;
            
        default:
            break;
    }
}


@end
