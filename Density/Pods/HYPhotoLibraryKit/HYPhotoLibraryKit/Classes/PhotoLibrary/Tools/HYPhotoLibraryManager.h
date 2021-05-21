//
//  HYPhotoLibraryManager.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/10.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "HYPhotoConfiguration.h"
#import "HYPhotoModel.h"
#import "HYCostomPhotoModel.h"
#import "HYAlbumModel.h"

/**
 *  照片选择器的管理类, 使用照片选择器时必须先懒加载此类,然后赋值给对应的对象
 */
typedef NS_ENUM(NSUInteger, HYPhotoLibraryManagerSelectedType) {
    HYPhotoLibraryManagerSelectedTypePhoto = 0,        // 只显示图片
    HYPhotoLibraryManagerSelectedTypeVideo = 1,        // 只显示视频
    HYPhotoLibraryManagerSelectedTypePhotoAndVideo     // 图片和视频一起显示
};

typedef NS_ENUM(NSUInteger, HYPhotoLibraryManagerVideoSelectedType) {
    HYPhotoLibraryManagerVideoSelectedTypeNormal = 0,  // 普通状态显示选择按钮
    HYPhotoLibraryManagerVideoSelectedTypeSingle       // 单选不显示选择按钮
};

@interface HYPhotoLibraryManager : NSObject

@property (assign, nonatomic) HYPhotoLibraryManagerSelectedType type;
/**
 @param type 选择类型
 @return self
 */
- (instancetype)initWithType:(HYPhotoLibraryManagerSelectedType)type;
/**
 配置信息
 */
@property (strong, nonatomic) HYPhotoConfiguration *configuration;
/**
 videoSelected
 */
@property (assign, nonatomic) HYPhotoLibraryManagerVideoSelectedType videoSelectedType;

/**
@param assetArray 模型数组
*/
- (void)addCustomAssetModel:(NSArray<HYCostomPhotoModel *> *)assetArray;

/**
 相册列表
 */
@property (strong, nonatomic,readonly) NSMutableArray *albums;
/**
 源对象信息
 */
@property (strong, nonatomic) id sourceObject;

/**
 获取系统所有相册
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void(^)(NSArray *albums))albums isFirst:(BOOL)isFirst ;

- (void)fetchAlbums:(void (^)(HYAlbumModel *selectedModel))selectedModel albums:(void(^)(NSArray *albums))albums;

/**
 根据某个相册模型获取照片列表
 
 @param albumModel 相册模型
 @param complete 照片列表和首个选中的模型
 */
- (void)getPhotoListWithAlbumModel:(HYAlbumModel *)albumModel complete:(void (^)(NSArray *allList , NSArray *previewList,NSArray *photoList ,NSArray *videoList ,NSArray *dateList , HYPhotoModel *firstSelectModel))complete;

/**
 将下载好的iCloud上的资源模型添加到数组中
 */
- (void)addICloudModel:(HYPhotoModel *)model;

/**
 判断最大值
 */
- (NSString *)maximumOfJudgment:(HYPhotoModel *)model;

- (NSInteger)cameraCount;


/**  关于选择好之前的一些方法  **/

/**
 选好之前选择的所有数组
 */
- (NSArray *)selectedArray;
/**
 选好之前选择的照片数组
 */
- (NSArray *)selectedPhotoArray;
/**
 选好之前选择的视频数组
 */
- (NSArray *)selectedVideoArray;

/**
 选好之前的照片数组是否达到最大数
 @return yes or no
 */
- (BOOL)beforeSelectPhotoCountIsMaximum;
/**
 选好之前的视频数组是否达到最大数
 @return yes or no
 */
- (BOOL)beforeSelectVideoCountIsMaximum;
/**
 选好之前从已选数组中删除某个模型
 */
- (void)beforeSelectedListdeletePhotoModel:(HYPhotoModel *)model;
/**
 选好之前添加某个模型到已选数组中
 */
- (void)beforeSelectedListAddPhotoModel:(HYPhotoModel *)model;
/**
 选好之前交换数组内模型的顺序
 */
- (void)beforeExchangeListPhotoModelWithIndex : (NSInteger)fromIndex toIndex : (NSInteger)toIndex;




@end

