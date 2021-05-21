//
//  HYPhotoConfiguration.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/9/28.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYPhotoConfigurationCameraType) {
    HYPhotoConfigurationCameraTypePhoto = 0,        // 拍照
    HYPhotoConfigurationCameraTypeVideo = 1,        // 录制
    HYPhotoConfigurationCameraTypeTypePhotoAndVideo // 拍照和录制一起
};

@class HYPhotoLibraryManager;
@class HYPhotoModel;

@interface HYPhotoConfiguration : NSObject

/** 是否是用于上传 */
@property (nonatomic, assign) BOOL isUpload;

// 选择视频时候是否隐藏选择按钮
@property (assign, nonatomic) BOOL specialModeNeedHideVideoSelectBtn;

/**
 在照片列表选择照片完后点击完成时是否请求图片
 选中了原图则是原图，没选中则是高清图
 并赋值给model的 thumbPhoto 和 previewPhoto 属性
 */
@property (assign, nonatomic) BOOL requestImageAfterFinishingSelection;


/**
 过渡动画枚举
 时间函数曲线相关
 */
@property (assign, nonatomic) UIViewAnimationOptions transitionAnimationOption;

/**
 push动画时长 default 0.45f
 */
@property (assign, nonatomic) NSTimeInterval pushTransitionDuration;

/**
 po动画时长 default 0.35f
 */
@property (assign, nonatomic) NSTimeInterval popTransitionDuration;

/**
 手势松开时返回的动画时长 default 0.35f
 */
@property (assign, nonatomic) NSTimeInterval popInteractiveTransitionDuration;

#pragma mark - < UI相关 >

/**
 状态栏样式 默认 UIStatusBarStyleDefault
 */
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

/**
 cell选中时的背景颜色
 */
@property (strong, nonatomic) UIColor *cellSelectedBgColor;

/**
 cell选中时的文字颜色
 */
@property (strong, nonatomic) UIColor *cellSelectedTitleColor;

/**
 选中时数字的颜色
 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

/**
 主题颜色  默认 tintColor
 - 改变主题颜色后建议也改下原图按钮的图标
 */
@property (strong, nonatomic) UIColor *themeColor;

/**
 是否隐藏原图按钮  默认 NO
 */
@property (assign, nonatomic) BOOL hideOriginalBtn;

/**
 sectionHeader 是否显示照片的位置信息 默认 5、6不显示，其余的显示
 */
@property (assign, nonatomic) BOOL sectionHeaderShowPhotoLocation;

/**
 相机cell是否显示预览
 屏幕宽  320  ->  NO
 other  ->  YES
 */
@property (assign, nonatomic) BOOL cameraCellShowPreview;

/// 是否需要预览视频 YES预览，NO不预览. 默认NO
@property (assign, nonatomic) BOOL canVideoPreview;

/// 是否支持滑动手势选中取消多张图片或视频 YES支持 NO不支持 默认NO
@property (assign, nonatomic) BOOL canSlideSelectMoreItem;

/**
 横屏时是否隐藏状态栏 默认显示  暂不支持修改
 */
//@property (assign, nonatomic) BOOL horizontalHideStatusBar;

/**
 横屏时相册每行个数  默认6个
 */
@property (assign, nonatomic) NSInteger horizontalRowCount;

/**
 是否需要显示日期section  默认YES
 */
@property (assign, nonatomic) BOOL showDateSectionHeader;

/**
 照片列表按日期倒序 默认 NO
 */
@property (assign, nonatomic) BOOL reverseDate;

#pragma mark - < 基本配置 >
/**
 相册列表每行多少个照片 默认4个 iphone 4s / 5  默认3个
 */
@property (assign, nonatomic) NSInteger rowCount;

/**
 最大选择数 等于 图片最大数 + 视频最大数 默认30 - 必填
 */
@property (assign, nonatomic) NSInteger maxNum;

/**
 图片最大选择数 默认30 - 必填
 */
@property (assign, nonatomic) NSInteger photoMaxNum;

/**
 视频最大选择数 // 默认1 - 必填
 */
@property (assign, nonatomic) NSInteger videoMaxNum;

/**
 是否打开相机功能
 */
@property (assign, nonatomic) BOOL openCamera;

/**
 是否开启查看GIF图片功能 - 默认开启
 */
@property (assign, nonatomic) BOOL lookGifPhoto;

/**
 是否开启查看LivePhoto功能呢 - 默认 NO
 */
@property (assign, nonatomic) BOOL lookLivePhoto;

/**
 图片和视频是否能够同时选择 默认支持
 */
@property (assign, nonatomic) BOOL selectTogether;


/**
 拍摄的照片/视频保存到指定相册的名称  默认 BundleName
 (需9.0以上系统才可以保存到自定义相册 , 以下的系统只保存到相机胶卷...)
 */
@property (copy, nonatomic) NSString *customAlbumName;

/**
 *  视频能选择的最大秒数  -  默认 3分钟/180秒
 */
@property (assign, nonatomic) NSTimeInterval videoMaxDuration;


@property (assign, nonatomic) NSTimeInterval videoMinDuration;

/**
 是否为单选模式 默认 NO
 会自动过滤掉gif、livephoto
 */
@property (assign, nonatomic) BOOL singleSelected;

/**
 单选模式下选择图片时是否直接跳转到编辑界面  - 默认 YES
 */
@property (assign, nonatomic) BOOL singleJumpEdit;

/**
 是否开启3DTouch预览功能 默认 YES
 */
@property (assign, nonatomic) BOOL open3DTouchPreview;

/**
 下载iCloud上的资源  默认YES
 */
@property (assign, nonatomic) BOOL downloadICloudAsset;

/**
 是否过滤iCloud上的资源 默认NO
 */
@property (assign, nonatomic) BOOL filtrationICloudAsset;

/**
 是否是发图文再次添加照片
 */
@property (assign, nonatomic) BOOL sendImageTextAdd;
/**
 是否是制作Live Photo
 */
@property(nonatomic,assign)BOOL         isMakeLivePhoto;

/**
 是否是制作本地铃声
 */
//@property(nonatomic,assign)BOOL         isMakeRingtone;// 老照片业务 右侧按钮点击为下一步 
//
//@property (nonatomic, assign ,getter=isInRingTone) BOOL inRingTone;

/**
 小图照片清晰度 越大越清晰、越消耗性能
 设置太大的话获取图片资源时耗时长且内存消耗大可能会引起界面卡顿
 default：[UIScreen mainScreen].bounds.size.width
 320    ->  0.8
 375    ->  1.4
 other  ->  1.7
 */
@property (assign, nonatomic) CGFloat clarityScale;

#pragma mark - < block返回的视图 >
/**
 相片列表的collectionView
 - 旋转屏幕时也会调用
 */
@property (copy, nonatomic) void(^photoListCollectionView)(UICollectionView *collectionView);

/**
 预览界面的collectionView
 - 旋转屏幕时也会调用
 */
@property (copy, nonatomic) void(^previewCollectionView)(UICollectionView *collectionView);

@end


