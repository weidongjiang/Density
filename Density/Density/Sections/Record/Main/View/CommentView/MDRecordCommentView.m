//
//  MDRecordCommentView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordCommentView.h"
#import "MDRecordCommentViewCell.h"

@interface MDRecordCommentView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *commentTableView; ///<
@property (nonatomic, strong) NSArray        *dataArray;

@end

@implementation MDRecordCommentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)dealloc {
    HYDebugLog(@"%s",__FUNCTION__);
}

- (void)initSubViews {
    self.backgroundColor = [UIColor greenColor];
    
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHYHiddenStatusNavbarHeight, KHYScreenWidth, KHYScreenHeight-kHYTabBarHeight-KHYHiddenStatusNavbarHeight)];
    self.commentTableView.backgroundColor = [UIColor hy_colorWithHex:@"#f7f7f7"];
    self.commentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self addSubview:self.commentTableView];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MDRecordCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MDRecordCommentViewCellID];
    if (cell == nil) {
        cell = [[MDRecordCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDRecordCommentViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MDRecordCommentModel *model = [[MDRecordCommentModel alloc] init];
    [cell updateCommentModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;//MDRecordTableViewCellHeight;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}


@end
