//
//  HYPhotoLibraryViewTransition.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/23.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryViewTransition.h"
#import "HYPhotoLibraryViewController.h"
#import "HYPhotoLibraryPreviewViewController.h"
#import "HYPhotoTools.h"
#import "HYPhotoLibraryCell.h"
#import "HYPhotoLibraryManager.h"
#import "HYUtilsMacro.h"
#import "HYPhotoLibraryPreviewCell.h"
#import "UIColor+HYUtilities.h"
#import "HYUtilsDeviceMacro.h"

#define hyTopMargin (HYISIPhoneX ? 44 : 0)

@interface HYPhotoLibraryViewTransition()
@property (assign, nonatomic) HYPhotoLibraryViewTransitionType type;
@end
@implementation HYPhotoLibraryViewTransition

+ (instancetype)transitionWithType:(HYPhotoLibraryViewTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(HYPhotoLibraryViewTransitionType)type {
    self = [super init];
    if (self)  {
        self.type = type;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case HYPhotoLibraryViewTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        default:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    HYPhotoLibraryViewController *fromVC = (HYPhotoLibraryViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HYPhotoLibraryPreviewViewController *toVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    HYDebugLog(@"%tu",toVC.currentModelIndex);
    HYPhotoModel *model = [toVC.modelArray objectAtIndex:toVC.currentModelIndex];
    __weak typeof(self) weakSelf = self;
    [HYPhotoTools getHighQualityFormatPhotoForPHAsset:model.asset size:CGSizeMake(model.endImageSize.width * 0.8, model.endImageSize.height * 0.8) completion:^(UIImage *image, NSDictionary *info) {
        [weakSelf pushAnim:transitionContext image:image model:model fromVC:fromVC toVC:toVC];
    } error:^(NSDictionary *info) {
        [weakSelf pushAnim:transitionContext image:model.thumbPhoto model:model fromVC:fromVC toVC:toVC];
    }];
}
- (void)pushAnim:(id<UIViewControllerContextTransitioning>)transitionContext image:(UIImage *)image model:(HYPhotoModel *)model fromVC:(HYPhotoLibraryViewController *)fromVC toVC:(HYPhotoLibraryPreviewViewController *)toVC {
    model.tempImage = image;
    HYPhotoLibraryCell *fromCell = [fromVC currentPreviewCell:model];
    if (!image) {
        model.tempImage = fromCell.imageView.image;
        image = fromCell.imageView.image;
    }

    UIView *containerView = [transitionContext containerView];
    model.endDateImageSize = CGSizeZero;
    CGFloat imgWidht = model.endDateImageSize.width;
    CGFloat imgHeight = model.endDateImageSize.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width ;
//     - hxTopMargin - hxBottomMargin
    CGFloat height = [UIScreen mainScreen].bounds.size.height ;
 
    UIImageView *tempView = [[UIImageView alloc] initWithImage:image];
    UIView *tempBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    tempBgView.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1];
    tempView.clipsToBounds = YES;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (fromCell) {
        tempView.frame = [fromCell.imageView convertRect:fromCell.imageView.bounds toView: containerView];
    }else {
        tempView.center = CGPointMake(width / 2, height / 2);
    }
    
    [tempBgView addSubview:tempView];
    [fromVC.view insertSubview:tempBgView atIndex:0];
    [fromVC.view bringSubviewToFront:tempBgView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    toVC.previewCollectionView.hidden = YES;
    toVC.view.backgroundColor = [UIColor clearColor];
    fromCell.hidden = YES;
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    toVC.navigationController.navigationBar.userInteractionEnabled = NO;
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.9f initialSpringVelocity:0 options:option animations:^{
        tempView.frame = CGRectMake((width - imgWidht) / 2, (height - imgHeight + KHYHiddenStatusNavbarHeight) / 2 , imgWidht, imgHeight);
        tempBgView.backgroundColor = [[UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1] colorWithAlphaComponent:1];
    } completion:^(BOOL finished) {
        fromCell.hidden = NO;
        toVC.view.backgroundColor = [UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1];
        toVC.previewCollectionView.hidden = NO;
        [tempBgView removeFromSuperview];
        [tempView removeFromSuperview];
        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
        [transitionContext completeTransition:YES];
    }];
   
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HYPhotoLibraryViewController *toVC = (HYPhotoLibraryViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    HYPhotoModel *model = [fromVC.modelArray objectAtIndex:fromVC.currentModelIndex];
    
    HYPhotoLibraryPreviewCell *fromCell = [fromVC currentPreviewCell:model];
    HYPhotoLibraryCell *toCell = [toVC currentPreviewCell:model];
    UIImageView *tempView;
    tempView = [[UIImageView alloc] initWithImage:fromCell.imageView.image];
    tempView.clipsToBounds = YES;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    BOOL contains = YES;
    if (!toCell) {
        contains = [toVC scrollToModel:model];
        toCell = [toVC currentPreviewCell:model];
    }
    UIView *containerView = [transitionContext containerView];
    UIView *tempBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    [tempBgView addSubview:tempView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    if (transitionContext.interactive && fromVC.isHide) {
        tempBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        [toVC.navigationController setNavigationBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [containerView insertSubview:tempBgView belowSubview:fromVC.view];
    }else {
        [toVC.view insertSubview:tempBgView atIndex:0];
        [toVC.view bringSubviewToFront:tempBgView];
        tempBgView.backgroundColor = [[UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1] colorWithAlphaComponent:1];
    }
    

  
    
    toVC.navigationController.navigationBar.userInteractionEnabled = NO;
    
    fromVC.previewCollectionView.hidden = YES;
    toCell.hidden = YES;
    fromVC.view.backgroundColor = [UIColor clearColor];
    tempView.frame = [fromCell.imageView convertRect:fromCell.imageView.bounds toView:containerView];
    
    CGRect rect = [toCell.imageView convertRect:toCell.imageView.bounds toView: containerView];
    if (toCell) {
        [toVC scrollToPoint:toCell rect:rect];
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:option animations:^{
        if (!contains || !toCell) {
            tempView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            tempView.alpha = 0;
        }else {
            tempView.frame = [toCell.imageView convertRect:toCell.imageView.bounds toView: containerView];
        }
        fromVC.view.backgroundColor = [UIColor clearColor];
        if (fromVC.isHide) {
            tempBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            //            toVC.navigationController.navigationBar.alpha = 1;
            //            toVC.bottomView.alpha = 1;
        }else {
            tempBgView.backgroundColor = [[UIColor hy_rgbColorLightR:255 lightG:255 lightB:255 lightA:1 darkR:0 darkG:0 darkB:1 darkA:1] colorWithAlphaComponent:0];
        }
    }completion:^(BOOL finished) {
        //由于加入了手势必须判断
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            fromVC.previewCollectionView.hidden = NO;
            if (fromVC.isHide) {
                fromVC.view.backgroundColor = [UIColor blackColor];
                [toVC.navigationController setNavigationBarHidden:YES];
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            
        }
        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
        [toCell bottomViewPrepareAnimation];
        toCell.hidden = NO;
        [toCell bottomViewStartAnimation];
        [tempBgView removeFromSuperview];
        [tempView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == HYPhotoLibraryViewTransitionTypePush) {
//        HYPhotoLibraryViewController *fromVC = (HYPhotoLibraryViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        return 0.45f;
    }else {
//        HYPhotoLibraryPreviewViewController *fromVC = (HYPhotoLibraryPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        return 0.35f;
    }
}

@end
