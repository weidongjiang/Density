//
//  MDWordViewController.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "MDWordViewController.h"

@interface MDWordViewController ()

@end

@implementation MDWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    [self _addNavigationView];
}

- (void)_addNavigationView {
    self.navigationController.navigationBar.hidden = YES;

    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff" alpha:0];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(KHYScreenWidth);
        make.height.mas_equalTo(KHYHiddenStatusNavbarHeight);
    }];
    
    UILabel *navigationView_tileLabel = [[UILabel alloc] init];
    navigationView_tileLabel.text = @"世界";
    navigationView_tileLabel.textColor = [UIColor hy_colorWithHex:@"#000000"];
    navigationView_tileLabel.font = [UIFont hy_mediumFontSize:20 sizeRatio:1];
    [navigationView addSubview:navigationView_tileLabel];
    [navigationView_tileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView).offset(15);
        make.bottom.equalTo(navigationView).offset(-15);
    }];
    
}

@end
