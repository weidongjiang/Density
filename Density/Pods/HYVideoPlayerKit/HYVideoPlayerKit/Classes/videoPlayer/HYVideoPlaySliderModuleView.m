//
//  HYVideoPlaySliderModuleView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "HYVideoPlaySliderModuleView.h"
#import "HYVideoPlaySliderView.h"
#import "NSDateFormatter+HYUtilities.h"
#import "HYUtilsMacro.h"
#import "UIImage+HYBundleImage.h"

@interface HYVideoPlaySliderModuleView ()<HYVideoPlaySliderViewDelegate>

@property (nonatomic, strong) HYVideoPlaySliderView  *sliderView;
@property (nonatomic, strong) UILabel               *currentTimeLabel;
@property (nonatomic, strong) UILabel               *totalTimeLabel;
@property (nonatomic, strong) UIButton              *playButton;

@property (nonatomic, assign) double               sliderCurrentTime;
@property (nonatomic, assign) double               sliderTotalTime;
@property (nonatomic, assign) double               playSeekToTime;


@end


@implementation HYVideoPlaySliderModuleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    CGFloat moduleView_h = self.frame.size.height;
    CGFloat moduleView_w = self.frame.size.width;

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, moduleView_w, moduleView_h)];
    UIImage *image = [UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_img_xq_bg_xia" bundleName:@"HYVideoPlayerKit"];
    backImageView.image = image;
    [backImageView  setContentScaleFactor:[[UIScreen mainScreen] scale]];
    backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:backImageView];
    
    CGFloat interval = 16;
    CGFloat playButton_x = 20;
    CGFloat playButton_w = 32;
    CGFloat playButton_h = 32;
    CGFloat playButton_y = (moduleView_h-playButton_h)*0.5;
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(playButton_x, playButton_y, playButton_w, playButton_h)];
    [playButton setImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_bfq_zanting" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonDid:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    CGFloat currentTimeLabel_w = 45;
    CGFloat currentTimeLabel_h = 15;
    CGFloat currentTimeLabel_x = playButton.frame.origin.x + playButton.frame.size.width + interval;
    CGFloat currentTimeLabel_y = (currentTimeLabel_w - currentTimeLabel_h)*0.5;
    UILabel *currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentTimeLabel_x, currentTimeLabel_y, currentTimeLabel_w, currentTimeLabel_h)];
    currentTimeLabel.font = [UIFont systemFontOfSize:14];
    currentTimeLabel.text = @"00:00";
    currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel = currentTimeLabel;
    [self addSubview:currentTimeLabel];
    
    CGFloat totalTime_w = 45;
    CGFloat totalTime_h = 15;
    CGFloat totalTime_x = KHYScreenWidth - totalTime_w - interval;
    CGFloat totalTime_y = (totalTime_w - totalTime_h)*0.5;
    UILabel *totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalTime_x, totalTime_y, totalTime_w, totalTime_h)];
    totalTimeLabel.font = [UIFont systemFontOfSize:14];
    totalTimeLabel.text = @"00:00";
    totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel = totalTimeLabel;
    [self addSubview:totalTimeLabel];
    
    CGFloat sliderView_w = KHYScreenWidth - playButton_x - playButton_w - interval - currentTimeLabel_w - interval - totalTime_w - interval - interval;
    CGFloat sliderView_h = 32;
    CGFloat sliderView_x = currentTimeLabel.frame.origin.x + currentTimeLabel.frame.size.width + interval;
    CGFloat sliderView_y = (moduleView_h-sliderView_h)*0.5;
    self.sliderView = [[HYVideoPlaySliderView alloc] initWithFrame:CGRectMake(sliderView_x, sliderView_y, sliderView_w, sliderView_h)];
    [self.sliderView.sliderBtn setBackgroundColor:[UIColor whiteColor]];
    self.sliderView.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.sliderView.minimumTrackTintColor = [UIColor whiteColor];
    self.sliderView.sliderHeight = 4;
    self.sliderView.sliderRadius = 2;
    self.sliderView.thumbSize = CGSizeMake(16, 16);
    self.sliderView.sliderBtn.layer.cornerRadius = 8;
    self.sliderView.sliderBtn.layer.masksToBounds = YES;
    self.sliderView.delegate = self;
    [self addSubview:self.sliderView];
    
}

- (void)playButtonDid:(UIButton *)button {
    if (button.isSelected) {
        button.selected = NO;
        
        [button setImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_bfq_zanting" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
        if (self.playButtonBlock) {
            self.playButtonBlock(HYVideoPlaySliderModulePlayButtonStatus_toPlay);
        }
    }else {
        button.selected = YES;
        [button setImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_bfq_play" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
        if (self.playButtonBlock) {
            self.playButtonBlock(HYVideoPlaySliderModulePlayButtonStatus_toPause);
        }
    }
}

- (void)setPlaySliderCurrentTime:(double)currentTime {
    self.sliderCurrentTime = currentTime;
    
    NSString *currentText = [self getStringTimeWithTimeInterval:currentTime];
    self.currentTimeLabel.text = currentText;
}

- (void)setPlaySliderTotalTime:(double)totalTime {
    self.sliderTotalTime = totalTime;
    
    self.sliderView.totalTime = totalTime;
    
    NSString *totalTimeText = [self getStringTimeWithTimeInterval:totalTime];
    self.totalTimeLabel.text = totalTimeText;
}

- (void)setSliderViewValue:(double)value {
    self.sliderView.value = value;
}

- (void)videoPlay {
    self.playButton.selected = NO;
    [self.playButton setImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_bfq_zanting" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
}

- (void)videoPause {
    self.playButton.selected = YES;
    [self.playButton setImage:[UIImage hy_getBundleImageWithImageName:@"HYVideoPlayerKit_icon_bfq_play" bundleName:@"HYVideoPlayerKit"] forState:UIControlStateNormal];
}

//HYVideoPlaySliderViewDelegate
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value {
    if (self.playButtonBlock) {
        self.playButtonBlock(HYVideoPlaySliderModulePlayButtonStatus_toPause);
    }
}

// 滑块滑动中
- (void)sliderValueChanged:(float)value {
    self.playSeekToTime = value * self.sliderTotalTime;
}

// 滑块滑动结束
- (void)sliderTouchEnded:(float)value {
    
    if (self.playSeekToTimeBlock) {
        self.playSeekToTimeBlock(self.playSeekToTime);
    }
    
    if (self.playButtonBlock) {
        self.playButtonBlock(HYVideoPlaySliderModulePlayButtonStatus_toPlay);
    }
}

- (NSString *)getStringTimeWithTimeInterval:(NSTimeInterval)nterval {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:nterval];
    NSDateFormatter *dateFormatter = [NSDateFormatter hy_dateFormateterForCurrentThread];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end
