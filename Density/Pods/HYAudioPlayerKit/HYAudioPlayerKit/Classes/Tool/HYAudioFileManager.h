//
//  HYAudioFileTool.h
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HYAudioFileManager : NSObject

+ (void)hy_saveUserId:(NSString *)userId;

// 创建临时文件
+ (BOOL)hy_createTempFile;

// 往临时文件写入数据
+ (void)hy_writeDataToAudioFileTempPathWithData:(NSData *)data;

// 读取临时文件数据
+ (NSData *)hy_readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;

// 保存临时文件到缓存文件夹
+ (BOOL)hy_moveAudioFileFromTempPathToCachePath:(NSURL *)audioUrl;

// 音频缓存路径
+ (NSString *)hy_cachePath:(NSURL *)audioUrl;

// 缓存大小
+ (CGFloat)hy_cacheSize:(BOOL)currentUser;

// 清除音频缓存
+ (BOOL)hy_clearAudioCache:(NSURL *)audioUrl;

// 清除用户缓存
+ (BOOL)hy_clearUserCache:(BOOL)currentUser;

@end

static NSMutableDictionary *_archiverDic;
/**
 HYAudioPlayer归档管理器
 */
@interface HYAudioPlayerArchiverManager : NSObject

// 已经归档的数据
+ (NSMutableDictionary *)hy_hasArchivedFileDictionary;

// 归档
+ (BOOL)hy_archiveValue:(id)value forKey:(NSString *)key;

// 如果已经归档则删除该路径归档
+ (void)deleteKeyValueIfHaveArchivedWithUrl:(NSURL *)url;

@end

