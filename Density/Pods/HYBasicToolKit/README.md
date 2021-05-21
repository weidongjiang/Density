# HYBasicToolKit

## 作者

* wheatear, wheatear.jiang@qiffa.com


## 介绍

* HYBasicToolKit 是基础使用工具库，对一些常用工具的整体封装，避免重复造轮子。方便业务方使用，提高开发效率。


## 业务方接入

* podfile 添加source  git@192.168.56.62:iOSComponent/HYComponentSpecs.git  
* 通过 pod 'HYBasicToolKit' 接入


## 使用介绍
* 在使用HYBasicToolKit 时，只需要引用 HYBasicToolKitHeader.h 即可引入所有工具的头文件

* HYBasicToolKit 各个类使用介绍


## 版本迭代介绍

* 1.1.4  
稳定的基础版本

----
工具库里面的所有API都以 hy_ 开头，业务方在使用时，在对应的类后面直接 hy_调用，与系统的类API作为区分。后续新增的分类API命名都以 hy_ 开头。
---

category
---
* 1\. UIView
  - UIView+HYFrame.h  
  方便单独设置view的Frame  

  - UIView+HYViewRect.h  
  获取view在Window上的Rect、viewCenterY  


  - UIView+Toast.h （第三方库）  
  Toast 提示语显示  


* 2\. UIResponder

  - UIResponder+HYCurrentViewController.h  
  可以直接通过view调用，获取该view当前的ViewController  

* 3\. UIImage
  - UIImage+HYBundleImage  
  从Bundle中获取图片image
  - UIImage+HYCompress  
  图片缩放
  - UIImage+HYImageEffects  
  图片毛玻璃处理  
  - UIImage+HYImage
  设置 image 的浅色和深色

* 4\. UIButton
    - UIButton+HYEnlargeTouchArea  
    设置button的点击区域
    - UIButton+HYImagePosition  
    设置button的图片、文本位置、以及相对的间距
    - UIButton+HYUtilities  
    button的综合设置，根据注释来使用


* 5\. NSString
    - NSString+HYHash  
    获取对应的散列函数生成的字符串
    - NSString+HYDecimalsCalculation  
    数字字符比较,加、减、乘、初。数字四舍五入等
    - NSString+HYChineseCharacter  
    中文字符计算，长度截取、限宽截取字符串，主要用在中文显示的地方
    - NSString+HYSimpleMatching  
    判断字符串是否包含自定子串的工具方法
    - NSString+HYString
    基本字符串的处理
    - NSString+HYUtilities  
    通用字符串工具
    
    
    

* 6\. NSDateFormatter
    - NSDateFormatter+HYUtilities  
    多线程使用NSDateFormatter时 为了避免内存的增加以及创建 NSDateFormatter的耗时操作

* 7\. NSDate
    - NSDate+HYUtilities  
    时间相关的工具，传入对应的时间，生成一定格式的字符串

* 8\. NSObject
    - NSObject+HYAssociatedObject  
    添加 NSObject 设置，获取关联对象的工具方法。



* 9\. NSDictionary
    - NSDictionary 安全取值，set设值方法
    - NSDictionary+HYBlocksKit  
    - NSDictionary+HYTypeCast
    - NSDictionary+HYKeyValue  
```
    - (NSString *)hy_stringForKey:(NSString *)key;
    - (void)hy_setSafeObject:(id)obj forKey:(id<NSCopying>)key defaultObj:(id)defaultObj;
```  
上面的例子只是string的用法，根据对应的返回值类型来用对应的API


* 10\. NSArray
    - NSArray 安全取值
    - NSArray+HYBlocksKit
    - NSArray+HYTypeCast
    - NSArray+HYUtilities  
```
- (NSArray *)hy_stringArrayAtIndex:(NSUInteger)index;
- (void)hy_addSafeObject:(id)obj;
```
上面的例子只是string的用法，根据对应的返回值类型来用对应的API



* 11\. NSFileManager
    - NSFileManager+HYUtilities  
    文件相关操作，包括文件的相关路径的设置


* 12\. UIColor
    - UIColor+HYUtilities  
    相关色值的设置、包括深色浅色模式下 RGB、Hex 的颜色设置

* 13\. UIFont
    - UIFont+HYUtilities
    相关字号、字体的设置

* 14\. UINavigationController
    - UINavigationController+FDFullscreenPopGesture
    iOS 手势左滑 滑动退出对应的Controller



tools
-----
* 1\. HYUtilsMacro  
常用基本工具的宏集合

* 2\. HYUtilsDeviceMacro  
常用设备相关的宏集合


* 3\. HYGCDUtilsTool  
常用GCD工具方法


* 4\. HYWeakProxyTool  
创建NSTimer 的时候 避免循环引用
```
- (void)initTimer {
    HYWeakProxyTool *proxy = [HYWeakProxyTool proxyWithTarget:self];
   _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
}
```


* 5\. HYUtilitiesTools  
基础工具集合


* 6\. HYUserDefaultTool  
本地数据持久化工具，一句话做到增删改查


* 7\. HYFilePathTool  
创建本地对应的路径


* 8\. HYLocationTool  
获取定位相关的工具库

* 9\. wkWebView  
wkWebView


* 10\. HYUUHelpersTool  
获取deviceVersion 、getUUID


other
----
* 1\. HYTypeCastUtil  
对应对象的判空 操作

* 2\. SDAutoLayout  
SDAutoLayout

* 3\. MBProgressHUD  
MBProgressHUD 提示语




