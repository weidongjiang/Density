# HYVideoPlayerKit

## 作者

* wheatear, wheatear.jiang@qiffa.com

## 业务方接入

* podfile 添加source  git@192.168.56.62:iOSComponent/HYVideoPlayerKit.git
* 通过 pod 'HYVideoPlayerKit' 接入


## HYVideoPlayerKit

* HYVideoPlayerKit 是基础使用工具库，对一些常用工具的整体封装，避免重复造轮子

## 介绍

视频播放器接入根据自己的需求选择使用：

1、播放器view ：HYVideoPlayView

2、播放器ViewController: HYVideoPlayViewController

## 依赖
##### 视频播放器库依赖基础工具库：HYBasicToolKit

## 示例代码:

**HYVideoPlayView**：

```
HYVideoPlayContext *context = [[HYVideoPlayContext alloc]init];
context.isShowSliderView = YES;
context.isLoopPlay = YES;
HYVideoPlayView *playView = [[HYVideoPlayView alloc]initWithFrame:frame url:self.playedURL context:context];
/// 开始播放
[playView play];
/// 暂停播放
[playView pause];
``` 

**HYVideoPlayViewController**：

```
HYVideoPlayContext *context = [[HYVideoPlayContext alloc] init];
context.isLoopPlay = YES;
context.isShowSliderView = YES;
    
__weak HYVideoPlayViewController *vc = [[HYVideoPlayViewController alloc] initWithUrl:[NSURL URLWithString:@"https://vd3.bdstatic.com//mda-ma5jqzcy8my15dxk//cae_h264_clips//1609916394//mda-ma5jqzcy8my15dxk.mp4"] context:context];
vc.backBlock = ^{
     [vc dismissViewControllerAnimated:YES completion:nil];
};
```

### 1、️ HYVideoPlayContext介绍:
两个属性：

**是否显示 进度条 yes显示 no不显示 默认yes**

```
@property (nonatomic, assign) BOOL isShowSliderView;
```

**是否循环播放，yes循环播放 no不循环播放 默认no**

```
@property (nonatomic, assign) BOOL isLoopPlay;
```

### 2、️ HYVideoPlayView介绍：
**初始化方法：两种初始化方法，可传入NSURL或AVAsset**

```
- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url context:(HYVideoPlayContext *)context;
```

```
- (instancetype)initWithFrame:(CGRect)frame asset:(AVAsset *)asset context:(HYVideoPlayContext *)context;
```
**开始播放**

```
- (void)play;
```
**暂停播放**

```
- (void)pause;
```
**停止播放，指定播放的位置为初始位置**

```
- (void)stop;
```
**指定播放的位置从某一时间开始**

```
- (void)seekToTime:(double)time;
```

**回调图片数组和总时间**

```
typedef void(^ HYVideoPlayThumbnailImagesBlock)(NSArray * _Nullable images,double totalTime);

@property (nonatomic, copy) HYVideoPlayThumbnailImagesBlock thumbnailImagesBlock;
```

**回调当前时间和总时间**

```
typedef void(^ HYVideoPlayCurrentTimeBlock)(double currentTime,double totalTime);

@property (nonatomic, copy) HYVideoPlayCurrentTimeBlock     currentTimeBlock;
```

### 3、️ HYVideoPlayViewController介绍：
**初始化方法：两种初始化方法，可传入NSURL或AVAsset**

```
- (instancetype)initWithUrl:(NSURL *)url context:(HYVideoPlayContext *)context;
```

```
- (instancetype)initWithAsset:(AVAsset *)asset context:(HYVideoPlayContext *)context;
```
**开始播放**

```
- (void)play;
```
**暂停播放**

```
- (void)pause;
```

**指定播放的位置从某一时间开始**

```
- (void)seekToTime:(double)time;
```

**播放器左上角返回按钮事件回调**

```
@property (nonatomic, copy)HYVideoPlayVCBackBlock backBlock;
```

