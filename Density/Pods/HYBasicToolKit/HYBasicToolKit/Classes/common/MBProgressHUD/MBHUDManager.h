//
//  MBHUDManager.h
//  Vpings
//
//  Created by 徐保学 on 2018/5/29.
//  Copyright © 2018年 朱玉Vpings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBHUDManager : NSObject

@property(nonatomic,assign)CGPoint offset;

+ (instancetype)sharedHUDManager;
- (void)showHUDInView:(UIView *)showToView;
- (void)hideHUDInView;



@end
