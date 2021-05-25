//
//  MDPhotoBrowserConfigure.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 图片浏览器的显示方式
typedef NS_ENUM(NSUInteger, MDPhotoBrowserConfigureStyle) {
    MDPhotoBrowserConfigureStyleImage = 0,       // 只显示图片，即使有视频也会过滤
    MDPhotoBrowserConfigureStyleVideo = 1,       // 只显示视频，即使有图片也会过滤
    MDPhotoBrowserConfigureStyleAll  = 2       // 图片 视频 都可以显示
};

@interface MDPhotoBrowserConfigure : UIView

@property (nonatomic, assign) BOOL isHiddenPageControl;// 是否隐藏 PageControl YES隐藏，NO显示，默认显示

@property (nonatomic, assign) MDPhotoBrowserConfigureStyle configureStyle;// 默认MDPhotoBrowserConfigureStyleAll
@property (nonatomic, assign) BOOL isAddZoomGesture;// 是否添加浏览图片时缩放的手势，YES添加，NO 不添加，默认添加
@property (nonatomic, assign) BOOL isVideoAutoPlay;// 浏览到视频时 是否自动播放，YES自动播放，NO 不自动播放，默认YES


@end

NS_ASSUME_NONNULL_END
