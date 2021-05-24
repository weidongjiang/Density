//
//  MDRecordTableViewCellInputBoxView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordTableViewCellInputBoxView.h"

@implementation MDRecordTableViewCellInputBoxView
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
    self.backgroundColor = [UIColor hy_colorWithHex:@"#000000" alpha:0.3];
}

@end
