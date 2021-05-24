//
//  MDTabBarTransition.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MDTabBarTransitionOperationType) {
    MDTabBarTransitionOperationLeft,
    MDTabBarTransitionOperationRight,
};

@interface MDTabBarTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) MDTabBarTransitionOperationType transitionType;

@end

NS_ASSUME_NONNULL_END
