//
//  MDPhotoBrowserModel.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 图片浏览器的显示方式
typedef NS_ENUM(NSUInteger, MDPhotoBrowserModelType) {
    MDPhotoBrowserModelTypeImage = 0,       // 图片
    MDPhotoBrowserModelTypeVideo = 1,       // 视频
};

@interface MDPhotoBrowserModel : UIView

@property (nonatomic, assign) MDPhotoBrowserModelType type;
@property (nonatomic, strong) UIImage *image;// 展示图片 或 视频封面
@property (nonatomic, copy) NSString *imageUrlString;// 展示图片 或 视频封面 url
@property (nonatomic, copy) NSString *videoUrlString;// 展示视频的播放地址

@end

NS_ASSUME_NONNULL_END
