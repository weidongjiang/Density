//
//  HYEditVideoModuleView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "HYEditVideoModuleView.h"
#import "HYEditVideoThumbnailsScrollView.h"
#import "HYVideoPlaySliderView.h"
#import "HYUtilsMacro.h"
#import "UIImage+HYBundleImage.h"
#import "UIView+HYFrame.h"

typedef enum {
    HYEditVideoModuleViewimageType_left,
    HYEditVideoModuleViewimageType_right,
}HYEditVideoModuleViewimageType;


@interface HYEditVideoModuleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) HYEditVideoThumbnailsScrollView     *thumbnailsScrollView;
@property (nonatomic, strong) UIImageView                         *sliderLeftImageView;
@property (nonatomic, strong) UIImageView                         *sliderrRightImageView;
//正在操作开始或者结束指示器的类型
@property (nonatomic, assign) HYEditVideoModuleViewimageType chooseType;

@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, strong) UIView  *topLineView;
@property (nonatomic, strong) UIView  *bottomLineView;
@property (nonatomic, strong) HYVideoPlaySliderView  *sliderView;


@end

static CGFloat sliderLeftRight_w = 31;
static CGFloat sliderLeftRight_h = 60;

static CGFloat KtotalTimeDefaut = 600;  //本页全长代表的视频时间 默认

static CGFloat moveLineView_w = 2;



@implementation HYEditVideoModuleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = [UIColor blackColor];
    
    self.thumbnailsScrollView = [[HYEditVideoThumbnailsScrollView alloc] initWithFrame:self.bounds];
    self.thumbnailsScrollView.scrollView.delegate = self;
    [self addSubview:self.thumbnailsScrollView];

    CGFloat sliderView_w = KHYScreenWidth - 2*sliderLeftRight_w;
    CGFloat sliderView_h = sliderLeftRight_h;
    CGFloat sliderView_x = sliderLeftRight_w;
    CGFloat sliderView_y = 0;
    self.sliderView = [[HYVideoPlaySliderView alloc] initWithFrame:CGRectMake(sliderView_x, sliderView_y, sliderView_w, sliderView_h)];
    [self.sliderView.sliderBtn setBackgroundColor:[UIColor whiteColor]];
    self.sliderView.maximumTrackTintColor = [UIColor clearColor];
    self.sliderView.minimumTrackTintColor = [UIColor clearColor];
    self.sliderView.sliderHeight = 4;
    self.sliderView.sliderRadius = 2;
    self.sliderView.thumbSize = CGSizeMake(moveLineView_w, sliderLeftRight_h);
    self.sliderView.userInteractionEnabled = NO;
    [self addSubview:self.sliderView];
    
    
    self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(sliderLeftRight_w, 0, KHYScreenWidth - 2*sliderLeftRight_w, 3)];
    self.topLineView.backgroundColor = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:255/255.0 alpha:1];
    [self addSubview:self.topLineView];
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(self.topLineView.hy_origin.x, self.bounds.size.height - 3,self.topLineView.frame.size.width, 3)];
    self.bottomLineView.backgroundColor = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:255/255.0 alpha:1];
    [self addSubview:self.bottomLineView];
    
    
    self.sliderLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sliderLeftRight_w, sliderLeftRight_h)];
    self.sliderLeftImageView.image = [UIImage hy_getBundleImageWithImageName:@"HYEditVideoKit_icon_video_left" bundleName:@"HYEditVideoKit"];
    self.sliderLeftImageView.userInteractionEnabled = YES;
    self.sliderLeftImageView.tag = 100;
    [self addSubview:self.sliderLeftImageView];
    
    UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    recognizer1.maximumNumberOfTouches = 1;
    recognizer1.minimumNumberOfTouches = 1;
    [self.sliderLeftImageView addGestureRecognizer:recognizer1];
    
    
    self.sliderrRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KHYScreenWidth - sliderLeftRight_w, 0, sliderLeftRight_w, sliderLeftRight_h)];
    self.sliderrRightImageView.image = [UIImage hy_getBundleImageWithImageName:@"HYEditVideoKit_icon_video_right" bundleName:@"HYEditVideoKit"];
    self.sliderrRightImageView.userInteractionEnabled = YES;
    self.sliderrRightImageView.tag = 101;
    [self addSubview:self.sliderrRightImageView];
    
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    recognizer2.maximumNumberOfTouches = 1;
    recognizer2.minimumNumberOfTouches = 1;
    [self.sliderrRightImageView addGestureRecognizer:recognizer2];
    
    self.startTime = 0.0;
    
}

- (void)setThumbnailImages:(NSArray *)images totalTime:(double)totalTime {
    
    self.totalTime = totalTime > KtotalTimeDefaut ? KtotalTimeDefaut : totalTime;
    self.endTime = totalTime > KtotalTimeDefaut ? KtotalTimeDefaut : totalTime;
    
    [self.thumbnailsScrollView updateThumbnailsView:images totalTime:totalTime];
}

- (void)sliderGesture:(UIPanGestureRecognizer *)gesture {
    
    UIView *view = gesture.view;
    CGPoint point = [gesture translationInView:self.superview];
    CGPoint oldOrigin = view.frame.origin;
    CGFloat view_x = oldOrigin.x + point.x;
    
    switch (view.tag) {
        case 100:
        {
            _chooseType = HYEditVideoModuleViewimageType_left;
            if(view_x <= CGRectGetMaxX(self.sliderrRightImageView.frame) - self.bounds.size.width/3.0f
               && view_x >= 0) {
                view.frame = CGRectMake(view_x, 0, sliderLeftRight_w, self.bounds.size.height);
                [UIView animateWithDuration:0.15 animations:^{
                    [view.superview layoutSubviews];
                }];
            }
        }
            break;
        case 101:
        {
            _chooseType = HYEditVideoModuleViewimageType_right;
            if (view_x + sliderLeftRight_w - self.sliderLeftImageView.frame.origin.x >= self.bounds.size.width/3.0f
                && view_x + sliderLeftRight_w <= self.bounds.size.width) {
                view.frame = CGRectMake(view_x, 0, sliderLeftRight_w, self.bounds.size.height);
                [UIView animateWithDuration:0.15 animations:^{
                    [view.superview layoutSubviews];
                }];
            }
        }
            break;
        default:
            break;
    }
    
    CGFloat topLineView_x = self.sliderLeftImageView.frame.origin.x + 15;
    CGFloat topLineView_w = self.sliderrRightImageView.frame.origin.x - self.sliderLeftImageView.frame.origin.x;
    self.topLineView.frame = CGRectMake(topLineView_x, 0, topLineView_w, 3);
    self.bottomLineView.frame = CGRectMake(self.topLineView.frame.origin.x, self.bounds.size.height - 3, self.topLineView.frame.size.width, 3);
    [UIView animateWithDuration:0.15 animations:^{
        [self.topLineView.superview layoutSubviews];
        [self.bottomLineView.superview layoutSubviews];
    }];
    
    CGFloat moveLineBackView_x = self.sliderLeftImageView.frame.origin.x + sliderLeftRight_w;
    CGFloat moveLineBackView_w = self.sliderrRightImageView.frame.origin.x  - self.sliderLeftImageView.frame.origin.x - sliderLeftRight_w;
    self.sliderView.frame = CGRectMake(moveLineBackView_x, 0, moveLineBackView_w, sliderLeftRight_h);
    
    
    [self calculateForTimeNodes];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.cutWhenDragBegan) {
            self.cutWhenDragBegan();
        }
        self.sliderView.hidden = YES;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        [gesture setTranslation:CGPointZero inView:self.superview];
        if (self.cutWhenDragChanged) {
            self.cutWhenDragChanged();
        }
        self.sliderView.hidden = YES;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.cutWhenDragEnd) {
            self.cutWhenDragEnd();
        }
        self.sliderView.hidden = NO;
        self.sliderView.value = 0;
    }
}

//计算开始结束时间点
- (void)calculateForTimeNodes {
    
    CGPoint offset = self.thumbnailsScrollView.scrollView.contentOffset;
    
    //可滚动范围分摊滚动范围代表的剩下时间
    self.startTime = (offset.x + self.sliderLeftImageView.frame.origin.x) * self.totalTime * 1.0f/self.bounds.size.width;
    self.endTime = (offset.x + self.sliderrRightImageView.frame.origin.x + sliderLeftRight_w) * self.totalTime * 1.0f/self.bounds.size.width;
    
    //预览时间点
    CGFloat imageTime = self.startTime;
    if (_chooseType == HYEditVideoModuleViewimageType_right) {
        imageTime = self.endTime;
    }
    
    if (self.getTimeRange) {
        self.getTimeRange(self.startTime,self.endTime,imageTime);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _chooseType = HYEditVideoModuleViewimageType_left;
    [self calculateForTimeNodes];
    
    if (self.cutWhenDragBegan) {
        self.cutWhenDragBegan();
    }
    self.sliderView.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.cutWhenDragEnd) {
        self.cutWhenDragEnd();
    }
    self.sliderView.hidden = NO;
    self.sliderView.value = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.cutWhenDragEnd) {
        self.cutWhenDragEnd();
    }
    self.sliderView.hidden = NO;
    self.sliderView.value = 0;
}


- (void)updateMoveLineViewCurrentTime:(double)currentTime duration:(double)duration {

    CGFloat durationTime = self.endTime - self.startTime;
    CGFloat value = (currentTime - self.startTime)/durationTime;// 跑动的值 0-1
    self.sliderView.value = value;
}

@end
