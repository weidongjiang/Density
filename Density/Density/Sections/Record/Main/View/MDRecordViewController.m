//
//  MDRecordViewController.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/21.
//

#import "MDRecordViewController.h"
#import "MDRecordTableViewCell.h"
#import "MDPhotoBrowserView.h"

@interface MDRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UITableView                         *recordTableView; ///<
@property (nonatomic, strong) NSArray                         *dataArray; ///<

@end

@implementation MDRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blueColor];

    [self _addNavigationView];
    
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHYHiddenStatusNavbarHeight, KHYScreenWidth, KHYScreenHeight-kHYTabBarHeight-KHYHiddenStatusNavbarHeight)];
    self.recordTableView.backgroundColor = [UIColor hy_colorWithHex:@"#f7f7f7"];
    self.recordTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    [self.view addSubview:self.recordTableView];

    
    
}


- (void)_addNavigationView {
    self.navigationController.navigationBar.hidden = YES;

    UIView *navigationView = [[UIView alloc] init];
    self.navigationView = navigationView;
    navigationView.backgroundColor = [UIColor hy_colorWithHex:@"#ffffff"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(KHYScreenWidth);
        make.height.mas_equalTo(KHYHiddenStatusNavbarHeight);
    }];
    
    UILabel *navigationView_tileLabel = [[UILabel alloc] init];
    navigationView_tileLabel.text = @"记录";
    navigationView_tileLabel.textColor = [UIColor hy_colorWithHex:@"#000000"];
    navigationView_tileLabel.font = [UIFont hy_mediumFontSize:20 sizeRatio:1];
    [navigationView addSubview:navigationView_tileLabel];
    [navigationView_tileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView).offset(15);
        make.bottom.equalTo(navigationView).offset(-15);
    }];
    
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MDRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MDRecordTableViewCellID];
    if (cell == nil) {
        cell = [[MDRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDRecordTableViewCellID];
    }
    [cell setbrowserViewData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MDRecordTableViewCellHeight;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

@end
