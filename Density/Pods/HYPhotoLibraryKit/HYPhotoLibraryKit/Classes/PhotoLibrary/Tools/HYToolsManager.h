//
//  HYToolsManager.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/25.
//  Copyright © 2018 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPhotoTools.h"
#import "HYPhotoModel.h"

typedef enum : NSUInteger {
    HYPhotoToolManagerRequestTypeHD = 0, // 高清
    HYPhotoToolManagerRequestTypeOriginal // 原图
} HYPhotoToolManagerRequestType;

typedef void (^ HYPhotoToolManagerWriteSuccessHandler)(NSMutableArray<NSString *> *allURLNSString,NSMutableArray<NSString *> *photoURLNSString, NSMutableArray<NSString *> *videoURLNSString,NSMutableArray<UIImage *> *writeImageArray);
typedef void (^ HYPhotoToolManagerWriteFailedHandler)(void);

typedef void (^ HYPhotoToolManagerGetImageListSuccessHandler)(NSMutableArray<UIImage *> *imageList);
typedef void (^ HYPhotoToolManagerGetImageListFailedHandler)(void);

@interface HYToolsManager : NSObject
/**
 根据模型数组获取与之对应的image数组
 如果有网络图片时，会先判断是否已经下载完成了，未下载完则重新下载。
 @param modelList 模型数组
 @param requestType 请求类型
 @param success 成功回调
 @param failed 失败回调
 */
- (void)getSelectedImageList:(NSArray<HYPhotoModel *> *)modelList
                 requestType:(HYPhotoToolManagerRequestType)requestType
                     success:(HYPhotoToolManagerGetImageListSuccessHandler)success
                      failed:(HYPhotoToolManagerGetImageListFailedHandler)failed;

- (void)writeSelectModelListToTempPathWithList:(NSArray<HYPhotoModel *> *)modelList requestType:(HYPhotoToolManagerRequestType)requestType success:(HYPhotoToolManagerWriteSuccessHandler)success failed:(HYPhotoToolManagerWriteFailedHandler)failed ;

/**
 取消获取image
 */
- (void)cancelGetImageList;

@end


