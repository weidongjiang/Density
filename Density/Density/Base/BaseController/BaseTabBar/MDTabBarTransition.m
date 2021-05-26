//
//  MDTabBarTransition.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDTabBarTransition.h"

@implementation MDTabBarTransition
- (void)setTransitionType:(MDTabBarTransitionOperationType)transitionType {
    _transitionType = transitionType;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *contrainerView = [transitionContext containerView];
    
    
    CGFloat transition  = contrainerView.frame.size.width;
    switch (_transitionType) {
        case MDTabBarTransitionOperationLeft:
            transition = transition;
            break;
        case MDTabBarTransitionOperationRight:
            transition = -transition;
            break;
            
        default:
            break;
    }
    
    [contrainerView addSubview:toVc.view];
    CGAffineTransform toViewTransform = CGAffineTransformMakeTranslation(-transition, 0);
    CGAffineTransform fromViewTransform = CGAffineTransformMakeTranslation(transition, 0);
    toVc.view.transform = toViewTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.transform = fromViewTransform;
        toVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromVc.view.transform = CGAffineTransformIdentity;
        toVc.view.transform = CGAffineTransformIdentity;
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isCancelled];
    }];
}

@end
