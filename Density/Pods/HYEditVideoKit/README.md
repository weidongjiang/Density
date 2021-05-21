# HYEditVideoKit

## 作者

* wheatear, wheatear.jiang@qiffa.com

## 业务方接入

* podfile 添加source  git@192.168.56.62:iOSComponent/HYEditVideoKit.git 
* 通过 pod 'HYEditVideoKit' 接入


## HYEditVideoKit

* HYEditVideoKit 是基础使用工具库，对一些常用工具的整体封装，避免重复造轮子

## HYEditVideoKit 使用介绍
* 在使用HYEditVideoKit 时，只需要引用 HYEditVideoViewController.h 即可引入所有工具的头文件

示例代码:

```
    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com//mda-ma5jqzcy8my15dxk//cae_h264_clips//1609916394//mda-ma5jqzcy8my15dxk.mp4"];
    HYEditVideoViewController *editVideoVc = [[HYEditVideoViewController alloc] initWithUrl:url];
    kWeakSelf
    editVideoVc.backButtonActionBlock = ^{
        [weakSelf.nav2 dismissViewControllerAnimated:YES completion:nil];
    };
    editVideoVc.editVideoCompletionBlock = ^(NSURL * _Nonnull outPutUrl) {
        UIImage *image = [HYWditVideoCutTools getCoverImage:outPutUrl atTime:0 isKeyImage:YES];
    };
```

### HYEditVideoViewController介绍:
初始化方法：初始化方法有两种，可传入AVURLAsset或NSURL

```
- (instancetype)initWithAsset:(AVURLAsset *)asset;
```
```
-(instancetype)initWithUrl:(NSURL *)url;
```

剪辑视频界面返回按钮事件

```
@property (nonatomic,copy) void (^backButtonActionBlock)(void);
```

视频剪辑输出路径地址

```
@property (nonatomic,copy) void (^editVideoCompletionBlock)(NSURL *outPutUrl);
```
