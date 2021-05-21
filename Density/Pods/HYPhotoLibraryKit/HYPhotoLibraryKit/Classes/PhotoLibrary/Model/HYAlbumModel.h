//
//  HYAlbumModel.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/15.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAlbumModel : NSObject

/**
 相册名称
 */
@property (copy, nonatomic) NSString *albumName;

/**
 照片数量
 */
@property (assign, nonatomic) NSInteger count;

/**
 封面Asset
 */
@property (strong, nonatomic) PHAsset *asset;

/**
 照片集合对象
 */
@property (strong, nonatomic) PHFetchResult *result;

/**
 标记
 */
@property (assign, nonatomic) NSInteger index;

/**
 选中的个数
 */
@property (assign, nonatomic) NSInteger selectedCount;

@property (assign, nonatomic) NSUInteger cameraCount;

@property (strong, nonatomic) UIImage *tempImage;
@end

NS_ASSUME_NONNULL_END
