//
//  HYVideoPlaySliderView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "HYVideoPlaySliderView.h"
#import "UIView+HYFrame.h"

/** 滑块的大小 */
static const CGFloat kSliderBtnWH = 19.0;
/** 间距 */
static const CGFloat kProgressMargin = 2.0;
/** 进度的高度 */
static const CGFloat kProgressH = 1.0;
/** 拖动slider动画的时间*/
static const CGFloat kAnimate = 0.3;

@implementation HYVideoPlaySliderButton
- (void)dealloc {
    NSLog(@"dealloc---HYVideoPlaySliderButton---dealloc");
}

// 重写此方法将按钮的点击范围扩大
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -20, -20);
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end

@interface HYVideoPlaySliderView ()

/** 进度背景 */
@property (nonatomic, strong) UIImageView *bgProgressView;
/** 缓存进度 */
@property (nonatomic, strong) UIImageView *bufferProgressView;
/** 滑动进度 */
@property (nonatomic, strong) UIImageView *sliderProgressView;
/** 滑块 */
@property (nonatomic, strong) HYVideoPlaySliderButton *sliderBtn;

@property (nonatomic, strong) UIView *loadingBarView;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
//add by wuna
@property (nonatomic, strong) UIPanGestureRecognizer *sliderGesture;


@end


@implementation HYVideoPlaySliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allowTapped = YES;
        self.animate = YES;
        [self addSubViews];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"dealloc---HYVideoPlaySliderView---dealloc");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.allowTapped = YES;
    self.animate = YES;
    [self addSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_w = min_view_w;
    min_y = 0;
    min_h = self.sliderHeight;
    self.bgProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.thumbSize.width;
    min_h = self.thumbSize.height;
    self.sliderBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.sliderBtn.hy_centerX = self.bgProgressView.hy_width * self.value;
    
    min_x = 0;
    min_y = 0;
    if (self.sliderBtn.hidden) {
        min_w = self.bgProgressView.hy_width * self.value;
    } else {
        min_w = self.sliderBtn.hy_centerX;
    }
    min_h = self.sliderHeight;
    self.sliderProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.bgProgressView.hy_width * self.bufferValue;
    min_h = self.sliderHeight;
    self.bufferProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 0.1;
    min_h = self.sliderHeight;
    min_x = (min_view_w - min_w)/2;
    min_y = (min_view_h - min_h)/2;
    self.loadingBarView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgProgressView.hy_centerY     = min_view_h * 0.5;
    self.bufferProgressView.hy_centerY = min_view_h * 0.5;
    self.sliderProgressView.hy_centerY = min_view_h * 0.5;
    self.sliderBtn.hy_centerY          = min_view_h * 0.5;
}

/**
 添加子视图
 */
- (void)addSubViews {
    self.thumbSize = CGSizeMake(kSliderBtnWH, kSliderBtnWH);
    self.sliderHeight = kProgressH;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    [self addSubview:self.loadingBarView];
    
    // 添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 添加滑动手势
    self.sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    [self addGestureRecognizer:self.sliderGesture];
}

//--add by wuna
- (void)suspendAllGesture {
    self.sliderGesture.enabled = NO;
    [self sliderBtnTouchEnded:self.sliderBtn];
    self.sliderGesture.enabled = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // Determine whether you can receive touch events
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    // Determine if the touch point is out of reach
    if (![self pointInside:point withEvent:event]) return nil;
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if (fitView) {
            return fitView;
        }
    }
    return self;
}

#pragma mark - Setter

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor {
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}

- (void)setLoadingTintColor:(UIColor *)loadingTintColor {
    _loadingTintColor = loadingTintColor;
    self.loadingBarView.backgroundColor = loadingTintColor;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}

- (void)setBufferTrackImage:(UIImage *)bufferTrackImage {
    _bufferTrackImage = bufferTrackImage;
    self.bufferProgressView.image = bufferTrackImage;
    self.bufferTrackTintColor = [UIColor clearColor];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setBackgroundImage:image forState:state];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setImage:image forState:state];
}

- (void)setValue:(float)value {
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    if (self.sliderBtn.hidden) {
        self.sliderProgressView.hy_width = self.bgProgressView.hy_width * value;
    } else {
        self.sliderBtn.hy_centerX = self.bgProgressView.hy_width * value;
        self.sliderProgressView.hy_width = self.sliderBtn.hy_centerX;
    }
}

- (void)setBufferValue:(float)bufferValue {
    if (isnan(bufferValue)) return;
    bufferValue = MIN(1.0, bufferValue);
    _bufferValue = bufferValue;
    self.bufferProgressView.hy_width = self.bgProgressView.hy_width * bufferValue;
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    if (isnan(sliderHeight)) return;
    _sliderHeight = sliderHeight;
    self.bgProgressView.hy_height     = sliderHeight;
    self.bufferProgressView.hy_height = sliderHeight;
    self.sliderProgressView.hy_height = sliderHeight;
}

- (void)setSliderRadius:(CGFloat)sliderRadius {
    if (isnan(sliderRadius)) return;
    _sliderRadius = sliderRadius;
    self.bgProgressView.layer.cornerRadius      = sliderRadius;
    self.bufferProgressView.layer.cornerRadius  = sliderRadius;
    self.sliderProgressView.layer.cornerRadius  = sliderRadius;
    self.bgProgressView.layer.masksToBounds     = YES;
    self.bufferProgressView.layer.masksToBounds = YES;
    self.sliderProgressView.layer.masksToBounds = YES;
}

- (void)setIsHideSliderBlock:(BOOL)isHideSliderBlock {
    _isHideSliderBlock = isHideSliderBlock;
    // 隐藏滑块，滑杆不可点击
    if (isHideSliderBlock) {
        self.sliderBtn.hidden = YES;
        self.bgProgressView.hy_left     = 0;
        self.bufferProgressView.hy_left = 0;
        self.sliderProgressView.hy_left = 0;
        self.allowTapped = NO;
    }
}

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating {
    if (self.isLoading) return;
    self.isLoading = YES;
    self.bufferProgressView.hidden = YES;
    self.sliderProgressView.hidden = YES;
    self.sliderBtn.hidden = YES;
    self.loadingBarView.hidden = NO;
    
    [self.loadingBarView.layer removeAllAnimations];
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = 0.4;
    animationGroup.beginTime = CACurrentMediaTime() + 0.4;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale.x";
    scaleAnimation.fromValue = @(1000.0f);
    scaleAnimation.toValue = @(self.hy_width * 10);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = @(1.0f);
    alphaAnimation.toValue = @(0.0f);
    
    [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
    [self.loadingBarView.layer addAnimation:animationGroup forKey:@"loading"];
}

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating {
    self.isLoading = NO;
    self.bufferProgressView.hidden = NO;
    self.sliderProgressView.hidden = NO;
    self.sliderBtn.hidden = self.isHideSliderBlock;
    self.loadingBarView.hidden = YES;
    [self.loadingBarView.layer removeAllAnimations];
}

#pragma mark - User Action

- (void)sliderGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan");
            [self sliderBtnTouchBegin:self.sliderBtn];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            NSLog(@"UIGestureRecognizerStateChanged");

            [self sliderBtnDragMoving:self.sliderBtn point:[gesture locationInView:self.bgProgressView]];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            NSLog(@"UIGestureRecognizerStateEnded");

            [self sliderBtnTouchEnded:self.sliderBtn];
        }
            break;
        default:
            break;
    }
}

- (void)sliderBtnTouchBegin:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
}

- (void)sliderBtnTouchEnded:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)sliderBtnDragMoving:(UIButton *)btn point:(CGPoint)touchPoint {
    // 点击的位置
    CGPoint point = touchPoint;
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    CGFloat value = (point.x - btn.hy_width * 0.5) / self.bgProgressView.hy_width;
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.value == value) return;
    self.isForward = self.value < value;
    //add by wuna
    NSLog(@"sliderBtnDragMoving:value = %f, self.suspendValue = %f, self.totalTime = %f", value, self.suspendValue, self.totalTime);
    if (self.totalTime < 0 || self.totalTime == 0) {
        return;
    }
    if (value>self.suspendValue/self.totalTime && self.suspendValue>0) {
        NSLog(@"越过了");
        value = self.suspendValue/self.totalTime;
        self.value = value;
        if (self.suspendCallback) {
            self.suspendCallback();
        }
        [self suspendAllGesture];
    }else{
        self.value = value;
        if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
            [self.delegate sliderValueChanged:value];
        }
    }
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.bgProgressView];
    // 获取进度
    CGFloat value = (point.x - self.sliderBtn.hy_width * 0.5) * 1.0 / self.bgProgressView.hy_width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

#pragma mark - getter

- (UIView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [UIImageView new];
        _bgProgressView.backgroundColor = [UIColor grayColor];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [UIImageView new];
        _bufferProgressView.backgroundColor = [UIColor whiteColor];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [UIImageView new];
        _sliderProgressView.backgroundColor = [UIColor redColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (HYVideoPlaySliderButton *)sliderBtn {
    if (!_sliderBtn) {
        _sliderBtn = [HYVideoPlaySliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _sliderBtn;
}

- (UIView *)loadingBarView {
    if (!_loadingBarView) {
        _loadingBarView = [[UIView alloc] init];
        _loadingBarView.backgroundColor = [UIColor whiteColor];
        _loadingBarView.hidden = YES;
    }
    return _loadingBarView;
}

// add by wuna
- (void)setCancelAllGesture:(BOOL)cancelAllGesture {
    _cancelAllGesture = cancelAllGesture;
    if (cancelAllGesture) {
        self.sliderGesture.enabled = NO;
        self.tapGesture.enabled = NO;
    } else {
        self.sliderGesture.enabled = YES;
        self.tapGesture.enabled = YES;
    }
}

@end
