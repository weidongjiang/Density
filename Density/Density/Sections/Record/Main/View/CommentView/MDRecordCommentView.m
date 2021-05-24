//
//  MDRecordCommentView.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordCommentView.h"

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
}



@end
