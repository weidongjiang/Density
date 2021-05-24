//
//  MDTabBarTransitionDelegate.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDTabBarTransitionDelegate : NSObject<UITabBarControllerDelegate>
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@end

NS_ASSUME_NONNULL_END
