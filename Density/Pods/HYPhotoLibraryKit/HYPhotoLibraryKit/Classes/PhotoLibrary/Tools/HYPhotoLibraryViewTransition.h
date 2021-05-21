//
//  HYPhotoLibraryViewTransition.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/23.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HYPhotoLibraryViewTransitionTypePush = 0,
    HYPhotoLibraryViewTransitionTypePop = 1,
} HYPhotoLibraryViewTransitionType;


@interface HYPhotoLibraryViewTransition : NSObject<UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionWithType:(HYPhotoLibraryViewTransitionType)type;
- (instancetype)initWithTransitionType:(HYPhotoLibraryViewTransitionType)type;

@end


