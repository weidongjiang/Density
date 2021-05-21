//
//  HYCostomPhotoModel.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/12.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HYCustomAssetModelType) {
    HYCustomAssetModelTypeLocalImage = 1,   // 本地图片
    HYCustomAssetModelTypeLocalVideo = 2,   // 本地视频
    HYCustomAssetModelTypeNetWorkImage = 3  // 网络图片
};

@interface HYCostomPhotoModel : NSObject

@property (assign, nonatomic) HYCustomAssetModelType type;

/**
 网络图片地址
 */
@property (strong, nonatomic) NSURL *networkImageURL;

/**
 本地图片UIImage
 */
@property (strong, nonatomic) UIImage *localImage;

/**
 本地视频地址
 */
@property (strong, nonatomic) NSURL *localVideoURL;

/**
 是否选中
 */
@property (assign, nonatomic) BOOL selected;

/**
 根据本地图片名初始化
 
 @param imageName 本地图片名
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocaImageName:(NSString *)imageName selected:(BOOL)selected;

/**
 根据本地UIImage初始化
 
 @param image 本地图片
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocalImage:(UIImage *)image selected:(BOOL)selected;

/**
 根据网络图片地址初始化
 
 @param imageURL 网络图片地址
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithNetworkImageURL:(NSURL *)imageURL selected:(BOOL)selected;

/**
 根据本地视频地址初始化
 
 @param videoURL 本地视频地址
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocalVideoURL:(NSURL *)videoURL selected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
