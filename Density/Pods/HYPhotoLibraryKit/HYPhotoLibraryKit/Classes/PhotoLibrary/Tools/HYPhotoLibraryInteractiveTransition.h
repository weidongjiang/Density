//
//  HYPhotoLibraryInteractiveTransition.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/23.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPhotoLibraryInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interation;
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end


