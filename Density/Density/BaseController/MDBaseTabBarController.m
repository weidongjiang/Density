//
//  MDBaseTabBarController.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "MDBaseTabBarController.h"
#import <Masonry/Masonry.h>

@interface MDBaseTabBarController ()<UIScrollViewDelegate,UITabBarControllerDelegate>
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *backingViewControllers;
@property (nonatomic, assign) NSUInteger backingSelectedIndex;
@property (nonatomic, copy) NSArray *tabBarButtons;
@property (nonatomic, assign) BOOL initialized;

@end

@implementation MDBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces  = NO;
    self.scrollView.delegate = self;
    
    //将scrollView移动至tabbar下层
    [self.view insertSubview:self.scrollView belowSubview:self.tabBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.selectedIndex == 1) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.selectedIndex == 1) {
        UIViewController * vc = self.selectedViewController;
        [vc viewWillDisappear:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //给每个item加一个image和title滑动动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.initialized) {
                [self.tabBarButtons enumerateObjectsUsingBlock:^(UIView *tabBarButton, NSUInteger idx, BOOL *stop) {
                    [self addAnimationSelectImageViewAndTitleViewForBarButton:tabBarButton index:idx];
                }];

                self.selectedIndex = 1;
                self.initialized = YES;
            }
       
    });

}


// 暗黑模式改变的回调代理
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];

    NSArray * img_s = @[@"icon_tabbar_01_s",@"icon_tabbar_02_s",@"icon_tabbar_03_s"];
    NSArray * img_s_d = @[@"icon_tabbar_01_s-1",@"icon_tabbar_02_s-1",@"icon_tabbar_03_s-1"];
    
    if (@available(iOS 13.0, *)) {
        if([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]){
            
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                [self.tabBarButtons enumerateObjectsUsingBlock:^(UIView *tabBarButton, NSUInteger idx, BOOL *stop) {
                    UIImageView *tabBarImageView = tabBarButton.subviews.firstObject;
                    tabBarImageView.image = [UIImage imageNamed:img_s_d[idx]];
                }];
                
            }else{
                
                [self.tabBarButtons enumerateObjectsUsingBlock:^(UIView *tabBarButton, NSUInteger idx, BOOL *stop) {
                    UIImageView *tabBarImageView = tabBarButton.subviews.firstObject;
                    tabBarImageView.image = [UIImage imageNamed:img_s[idx]];
                }];
            }
        }
    } else {
        
    }
    

}


/// 添加动画所需要的image和title
- (void)addAnimationSelectImageViewAndTitleViewForBarButton:(UIView *)tabBarButton index:(NSInteger)idx
{
    
    //ios 13之后发生了一些变化
    UIImageView *tabBarImageView;
    if (@available(iOS 13.0, *)) {
        tabBarImageView= tabBarButton.subviews[1];
    }else{
        tabBarImageView = tabBarButton.subviews[0];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [tabBarButton insertSubview:imageView atIndex:0];
    
    CGFloat top = tabBarImageView.frame.origin.y;
    CGFloat left  = tabBarImageView.frame.origin.x;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tabBarButton).offset(left);
        make.top.equalTo(tabBarButton).offset(top);
        make.width.height.mas_equalTo(32);
    }];
    
    UITabBarItem  * tabBarItem = self.backingViewControllers[idx].tabBarItem;
    imageView.image = tabBarItem.selectedImage;

    [tabBarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tabBarButton);
        make.width.height.mas_equalTo(32);
    }];

    UILabel *tabBarLabel = tabBarButton.subviews[2];

    UILabel *label = [[UILabel alloc] init];
    [tabBarButton insertSubview:label atIndex:1];

    label.textColor = self.tabBar.tintColor;
    label.text = self.backingViewControllers[idx].tabBarItem.title;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [tabBarButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tabBarLabel]-width-[label(==tabBarLabel)]"
                                                                         options:0
                                                                         metrics:@{ @"width": @(-CGRectGetWidth(tabBarLabel.frame)) }
                                                                           views:NSDictionaryOfVariableBindings(tabBarLabel, label)]];
    [tabBarButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tabBarLabel]-height-[label(==tabBarLabel)]"
                                                                         options:0
                                                                         metrics:@{ @"height": @(-CGRectGetHeight(tabBarLabel.frame)) }
                                                                           views:NSDictionaryOfVariableBindings(tabBarLabel, label)]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.scrollView.delegate = nil;
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    self.scrollView.contentOffset = CGPointMake(size.width * self.backingSelectedIndex, 0);
    self.scrollView.contentSize = CGSizeMake(size.width * self.backingViewControllers.count, size.height);
    self.scrollView.delegate = self;
    
    [self.backingViewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        viewController.view.frame = CGRectMake(size.width * idx, 0, size.width, size.height);
    }];
}

#pragma mark - Getters and Setters

- (NSArray *)viewControllers {
    return nil;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    self.backingViewControllers = viewControllers;
}

- (UIViewController *)selectedViewController {
    return self.backingViewControllers[self.backingSelectedIndex];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    self.selectedIndex = [self.backingViewControllers indexOfObject:selectedViewController];
}

- (NSUInteger)selectedIndex {
    return self.backingSelectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _backingSelectedIndex = selectedIndex;
    
    CGRect rectToVisible = CGRectMake(CGRectGetWidth(self.view.frame) * selectedIndex, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
   
    self.scrollView.delegate = nil;
    [self.scrollView scrollRectToVisible:rectToVisible animated:NO];
    self.scrollView.delegate = self;
    
    [self.tabBarButtons enumerateObjectsUsingBlock:^(UIView *tabBarButton, NSUInteger idx, BOOL *stop) {
        [self tabBarButton:tabBarButton highlighted:(idx == selectedIndex) deltaAlpha:0];
    }];
    
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)setBackingViewControllers:(NSArray *)backingViewControllers {
    _backingViewControllers = backingViewControllers;
   
    [backingViewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * idx, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [self.scrollView addSubview:viewController.view];
    }];
   
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * backingViewControllers.count, CGRectGetHeight(self.view.frame));
}

- (NSArray *)tabBarButtons {
    if (_tabBarButtons == nil || !_tabBarButtons.count ) {
        NSMutableArray *tabBarButtons = [[NSMutableArray alloc] init];
        for (UIView *subview in self.tabBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtons addObject:subview];
            }
        };
        _tabBarButtons = tabBarButtons.copy;
    }
    return _tabBarButtons;
}

#pragma mark - UIScrollViewDelegate
//做渐隐动画。锁定所选item
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!scrollView.scrollEnabled) return;
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    CGFloat mod = fmod(scrollView.contentOffset.x, CGRectGetWidth(self.view.frame));
    CGFloat deltaAlpha = mod * (1.0 / CGRectGetWidth(self.view.frame));

    [self.tabBarButtons enumerateObjectsUsingBlock:^(UIView *tabBarButton, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            [self tabBarButton:tabBarButton highlighted:YES deltaAlpha:deltaAlpha];
        } else if (idx == index + 1) {
            [self tabBarButton:tabBarButton highlighted:NO deltaAlpha:deltaAlpha];
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _backingSelectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    UIViewController * svc = self.backingViewControllers[_backingSelectedIndex];
    [svc viewWillAppear:NO];

    for (int i = 0; i<self.backingViewControllers.count ; i++) {
        if (_backingSelectedIndex != i) {
            UIViewController * vc = self.backingViewControllers[i];
            [vc viewWillDisappear:NO];
        }
    }
}

#pragma mark - UITabBarControllerDelegate
///点击tabbar的时候
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([self.selectedViewController isEqual:viewController]) {
        return NO;
    }
    self.selectedViewController = viewController;
    NSLog(@"点击了第%td",self.selectedIndex);
    return NO;
}

- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController {
    return tabBarController.selectedViewController.supportedInterfaceOrientations;
}

#pragma mark - Private methods

- (void)tabBarButton:(UIView *)tabBarButton highlighted:(BOOL)highlighted deltaAlpha:(CGFloat)deltaAlpha {
    if (highlighted) {
        tabBarButton.subviews[0].alpha = 1 - deltaAlpha;
        tabBarButton.subviews[1].alpha = 1 - deltaAlpha;
        tabBarButton.subviews[2].alpha = 0 + deltaAlpha;
        tabBarButton.subviews[3].alpha = 0 + deltaAlpha;
    } else {
        tabBarButton.subviews[0].alpha = 0 + deltaAlpha;
        tabBarButton.subviews[1].alpha = 0 + deltaAlpha;
        tabBarButton.subviews[2].alpha = 1 - deltaAlpha;
        tabBarButton.subviews[3].alpha = 1 - deltaAlpha;
    }
}

@end
