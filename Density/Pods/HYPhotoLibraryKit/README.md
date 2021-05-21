# HYPhotoLibraryKit

## 作者

* wheatear, wheatear.jiang@qiffa.com

## 业务方接入

* podfile 添加source  git@192.168.56.62:iOSComponent/HYPhotoLibraryKit.git
* 通过 pod 'HYPhotoLibraryKit' 接入


## HYPhotoLibraryKit

* HYPhotoLibraryKit 是批量上传工具库

## 介绍

批量上传库

* 1、HYPhotoLibraryViewController ：该类是业务方统一调用入口

* 2、HYPhotoLibraryManager 为相册工具库的所有设置，其中configuration为对应的基本配置

## 依赖
##### 视频播放器库依赖基础工具库：HYBasicToolKit
##### SDWebImage
##### XHNetworkCache
##### HYVideoPlayerKit


## 示例代码
```
HYPhotoLibraryViewController *browerVc = [[HYPhotoLibraryViewController alloc] init];

HYPhotoLibraryManager *manager = [[HYPhotoLibraryManager alloc] initWithType:HYPhotoLibraryManagerSelectedTypePhoto];
manager.configuration.rowCount = 4;
manager.configuration.isUpload = YES;
manager.configuration.photoMaxNum = 20;

browerVc.manager = manager;
UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:browerVc];
nav2.modalPresentationStyle = UIModalPresentationFullScreen;
nav2.modalPresentationCapturesStatusBarAppearance = YES;
[self presentViewController:nav2 animated:YES completion:nil];

kWeakSelf
browerVc.selectedComplete = ^(NSArray *photoMoelArray) {
    
    // 对应回调的图片或视频资源
    
};

```
