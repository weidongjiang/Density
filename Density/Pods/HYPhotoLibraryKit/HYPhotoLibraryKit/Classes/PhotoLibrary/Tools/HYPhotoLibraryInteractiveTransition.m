//
//  HYPhotoLibraryInteractiveTransition.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/23.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryInteractiveTransition.h"
#import "HYPhotoLibraryViewController.h"
#import "HYPhotoLibraryPreviewViewController.h"
#import "HYPhotoLibraryCell.h"
#import "HYPhotoLibraryPreviewCell.h"
#import "HYPhotoLibraryManager.h"
#import "UIColor+HYUtilities.h"
#import "HYUtilsDeviceMacro.h"
#import "HYUtilsMacro.h"

#define iOS11_Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

@interface HYPhotoLibraryInteractiveTransition()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIViewController *vc;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *bgView;
@property (weak, nonatomic) HYPhotoLibraryCell *tempCell;
@property (weak, nonatomic) HYPhotoLibraryPreviewCell *fromCell;
@property (strong, nonatomic) UIImageView *tempImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@property (nonatomic, assign) CGFloat beginX;
@property (nonatomic, assign) CGFloat beginY;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end
@implementation HYPhotoLibraryInteractiveTransition
#pragma mark ----- 添加手势方法
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}
- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat scale = 0;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGFloat transitionY = translation.y;
    HYDebugLog(@"%f transitionY -- --- -- ---",transitionY);
    scale = ABS(transitionY / ((gestureRecognizer.view.frame.size.height - 50) / 2)) ;
    if (scale > 1.f) {
        scale = 1.f;
    }
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (scale < 0) {
                [gestureRecognizer cancelsTouchesInView];
                return;
            }
            if ([(HYPhotoLibraryPreviewViewController *)self.vc isHide] && iOS11_Later) {
                [(HYPhotoLibraryPreviewViewController *)self.vc setSubviewAlphaAnimate:NO duration:0.3f];
            }
            self.beginX = [gestureRecognizer locationInView:gestureRecognizer.view].x;
            self.beginY = [gestureRecognizer locationInView:gestureRecognizer.view].y;
            self.interation = YES;
            [self.vc.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            if (self.interation) {
                if (scale < 0.f) {
                    scale = 0.f;
                }
                CGFloat imageViewScale = 1 - scale * 0.5;
                if (imageViewScale < 0.4) {
                    imageViewScale = 0.4;
                }
                self.tempImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x, self.transitionImgViewCenter.y + translation.y);
                self.tempImageView.transform = CGAffineTransformMakeScale(imageViewScale, imageViewScale);
                
                [self updateInterPercent:1 - scale * scale];
                
                [self updateInteractiveTransition:scale];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.interation) {
                if (scale < 0.f) {
                    scale = 0.f;
                }
                self.interation = NO;
                if (scale < 0.15f){
                    [self cancelInteractiveTransition];
                    [self interPercentCancel];
                }else {
                    [self finishInteractiveTransition];
                    [self interPercentFinish];
                }
            }
            break;
        default:
            if (self.interation) {
                self.interation = NO;
                [self cancelInteractiveTransition];
                [self interPercentCancel];
            }
            break;
    }
}

- (void)beginInterPercent{
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    HYPhotoLibraryViewController *toVC = (HYPhotoLibraryViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    HYPhotoModel *model = [fromVC.modelArray objectAtIndex:fromVC.currentModelIndex];
    
    HYPhotoLibraryPreviewCell *fromCell = [fromVC currentPreviewCell:model];
    HYPhotoLibraryCell *toCell = [toVC currentPreviewCell:model];
    self.fromCell = fromCell;
    
    UIView *containerView = [transitionContext containerView];
    CGRect tempImageViewFrame;
    self.tempImageView = fromCell.imageView;
    tempImageViewFrame = [fromCell.imageView convertRect:fromCell.imageView.bounds toView:containerView];
    
    self.tempImageView.clipsToBounds = YES;
    self.tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    BOOL contains = YES;
    if (!toCell) {
        contains = [toVC scrollToModel:model];
        toCell = [toVC currentPreviewCell:model];
    }
    self.bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    self.bgView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1];
    CGFloat scaleX;
    CGFloat scaleY;
    if (self.beginX < tempImageViewFrame.origin.x) {
        scaleX = 0;
    }else if (self.beginX > CGRectGetMaxX(tempImageViewFrame)) {
        scaleX = 1.0f;
    }else {
        scaleX = (self.beginX - tempImageViewFrame.origin.x) / tempImageViewFrame.size.width;
    }
    if (self.beginY < tempImageViewFrame.origin.y) {
        scaleY = 0;
    }else if (self.beginY > CGRectGetMaxY(tempImageViewFrame)){
        scaleY = 1.0f;
    }else {
        scaleY = (self.beginY - tempImageViewFrame.origin.y) / tempImageViewFrame.size.height;
    }
    self.tempImageView.layer.anchorPoint = CGPointMake(scaleX, scaleY);
    
    self.tempImageView.frame = tempImageViewFrame;
    self.transitionImgViewCenter = self.tempImageView.center;
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [toVC.view addSubview:self.bgView];
    [toVC.view addSubview:self.tempImageView];
    [toVC.view bringSubviewToFront:self.bgView];
    [toVC.view bringSubviewToFront:self.tempImageView];

    if (fromVC.isHide) {
        self.bgView.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [toVC.navigationController setNavigationBarHidden:NO];
        toVC.navigationController.navigationBar.alpha = 0;
    }else {
        self.bgView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:15 darkG:14 darkB:31 darkA:1];
    }
    toVC.navigationController.navigationBar.userInteractionEnabled = NO;
    fromVC.previewCollectionView.hidden = YES;
    toCell.hidden = YES;
    fromVC.view.backgroundColor = [UIColor clearColor];
    
    CGRect rect = [toCell.imageView convertRect:toCell.imageView.bounds toView: containerView];
    if (toCell) {
        [toVC scrollToPoint:toCell rect:rect];
    }
    self.tempCell = toCell;
}
- (void)updateInterPercent:(CGFloat)scale{
    HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.alpha = scale;
    self.bgView.alpha = fromVC.view.alpha;
    
    if (fromVC.isHide) {
        HYPhotoLibraryViewController *toVC = (HYPhotoLibraryViewController *)[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.navigationController.navigationBar.alpha = 1 - scale;
    }
}


- (void)interPercentCancel{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HYPhotoLibraryViewController *toVC = (HYPhotoLibraryViewController *)[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (fromVC.isHide) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [toVC.navigationController setNavigationBarHidden:YES];
        toVC.navigationController.navigationBar.alpha = 1;
    }
    [UIView animateWithDuration:0.2f animations:^{
        fromVC.view.alpha = 1;
        self.tempImageView.transform = CGAffineTransformIdentity;
        self.tempImageView.center = self.transitionImgViewCenter;
        self.bgView.alpha = 1;
//        if (!fromVC.bottomView.userInteractionEnabled) {
//            toVC.bottomView.alpha = 0;
//        }
    } completion:^(BOOL finished) {
        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
        fromVC.previewCollectionView.hidden = NO;
        if (fromVC.isHide) {
            fromVC.view.backgroundColor = [UIColor blackColor];
        }else {
            fromVC.view.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:15 darkG:14 darkB:31 darkA:1];
        }
        self.tempCell.hidden = NO;
        self.tempCell = nil;
        [self.tempImageView removeFromSuperview];
        self.tempImageView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self.fromCell againAddImageView];
        self.playerLayer = nil;
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

//完成
- (void)interPercentFinish {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIView *containerView = [transitionContext containerView];
    HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HYPhotoLibraryViewController *toVC = (HYPhotoLibraryViewController *)[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = fromVC.manager.configuration.popInteractiveTransitionDuration;
    UIViewAnimationOptions option = fromVC.manager.configuration.transitionAnimationOption;
    
    CGRect tempImageViewFrame = self.tempImageView.frame;
    self.tempImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.tempImageView.transform = CGAffineTransformIdentity;
    self.tempImageView.frame = tempImageViewFrame;
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:option animations:^{
        if (self.tempCell) {
            self.tempImageView.frame = [self.tempCell.imageView convertRect:self.tempCell.imageView.bounds toView: containerView];
        }else {
            self.tempImageView.center = self.transitionImgViewCenter;
            self.tempImageView.alpha = 0;
            self.tempImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        }
        fromVC.view.alpha = 0;
        self.bgView.alpha = 0;
        toVC.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.tempCell bottomViewPrepareAnimation];
        self.tempCell.hidden = NO;
        [self.tempCell bottomViewStartAnimation];
        self.playerLayer = nil;
        [self.tempImageView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [self beginInterPercent];
}

@end
