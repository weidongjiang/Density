//
//  UIResponder+HYCurrentViewController.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/12.
//

#import "UIResponder+HYCurrentViewController.h"

@implementation UIResponder (HYCurrentViewController)

- (UIViewController *)hy_currentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
