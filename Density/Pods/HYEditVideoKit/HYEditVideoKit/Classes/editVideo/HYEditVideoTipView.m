//
//  HYEditVideoTipView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/6.
//

#import "HYEditVideoTipView.h"

@interface HYEditVideoTipView ()
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *textLabel;
@end


@implementation HYEditVideoTipView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    CGFloat backView_w = 180;
    CGFloat backView_h = 150;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backView_w, backView_h)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 16;
    backView.layer.masksToBounds = YES;
    backView.center = self.center;
    [self addSubview:backView];

    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, backView_w, 50)];
    self.textLabel = textLabel;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor blackColor];
    textLabel.text = @"正在裁剪视频\n请勿离开当前页面";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    [backView addSubview:textLabel];
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, backView_w, 50)];
    self.progressLabel = progressLabel;
    progressLabel.font = [UIFont systemFontOfSize:20];
    progressLabel.textColor = [UIColor blackColor];
    self.progressLabel.text = @"1%";
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.numberOfLines = 0;
    [backView addSubview:progressLabel];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    int int_progress = (int)(progress);
    if (int_progress >= 1) {
        self.progressLabel.text = [NSString stringWithFormat:@"%d%@",int_progress,@"%"];
    }
}

- (void)setTextLabelText:(NSString *)textLabelText {
    _textLabelText = textLabelText;
    self.textLabel.text = textLabelText;
}

@end
