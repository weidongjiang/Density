//
//  MDTabBarTransitionDelegate.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDTabBarTransitionDelegate.h"
#import "MDTabBarTransition.h"

@implementation MDTabBarTransitionDelegate
- (nullable id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactive ? self.interactionController : nil;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {

    MDTabBarTransition *anmiator = [[MDTabBarTransition alloc] init];
    
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    anmiator.transitionType = toIndex < fromIndex ? MDTabBarTransitionOperationLeft : MDTabBarTransitionOperationRight;

    return  anmiator;
}
- (UIPercentDrivenInteractiveTransition *)interactionController {
    if (!_interactionController) {
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return _interactionController;
}
@end
