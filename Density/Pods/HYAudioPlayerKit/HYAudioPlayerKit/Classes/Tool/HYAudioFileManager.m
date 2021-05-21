//
//  HYAudioFileTool.m
//  HyWallPaper
//
//  Created by Json on 2020/2/11.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import "HYAudioFileManager.h"
#import "HYAudioPlayerTool.h"


static NSString *HYPlayer_UserId = @"HYAudioPlayerUserId";

static NSString * HYCachePath(BOOL currentUser){
    // 所有缓存文件都放在了沙盒Cache文件夹下HYAudioPlayerCache文件夹里,然后再根据userId分文件夹缓存
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"HYAudioPlayerCache"];
    if (currentUser) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:HYPlayer_UserId];
        NSString *name = [NSString stringWithFormat:@"user_%@",userId];
        path = [path stringByAppendingPathComponent:name];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return success ? path : nil;
}

static NSString * HYTempPath(){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"MusicTemp.mp4"];
}

static NSString * HYArchiverPath(){
    return [HYCachePath(YES) stringByAppendingPathComponent:@"HYAudioPlayer.archiver"];
}


@implementation HYAudioFileManager

+ (void)hy_saveUserId:(NSString *)userId{
    NSString *uniqueId = @"public";
    if (![userId hy_isEmpty]) {
        uniqueId = userId;
    }
    [[NSUserDefaults standardUserDefaults] setObject:uniqueId forKey:HYPlayer_UserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hy_createTempFile{
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *path = HYTempPath();
    if ([mgr fileExistsAtPath:path]) {
        [mgr removeItemAtPath:path error:nil];
    }
    return [mgr createFileAtPath:path contents:nil attributes:nil];
}

+ (void)hy_writeDataToAudioFileTempPathWithData:(NSData *)data{
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:HYTempPath()];
    [handle seekToEndOfFile];
    [handle writeData:data];
}

+ (NSData *)hy_readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:HYTempPath()];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}

+ (BOOL)hy_moveAudioFileFromTempPathToCachePath:(NSURL *)audioUrl{
    NSString *path = [HYAudioFileManager audioCachedPath:audioUrl];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:path]) {
        NSNumber *numberId = [NSNumber numberWithInt:[HYPlayer_UserId intValue]];
        [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{NSFileOwnerAccountID:numberId} error:nil];
    }
    NSString *audioName = [audioUrl.path lastPathComponent];
    NSString *cacheFilePath = [path stringByAppendingPathComponent:audioName];
    NSError *error;
    BOOL success = [mgr moveItemAtPath:HYTempPath() toPath:cacheFilePath error:&error];
    if (!success) {//安全性处理 如果没有保存成功，删除归档文件中的对应键值对
        [HYAudioPlayerArchiverManager deleteKeyValueIfHaveArchivedWithUrl:audioUrl];
    }
    return success;
}

+ (NSString *)hy_cachePath:(NSURL *)audioUrl{
    NSString *path = [HYAudioFileManager audioCachedPath:audioUrl];
    NSString *audioName = [audioUrl.path lastPathComponent];
    NSString *cachePath = [path stringByAppendingPathComponent:audioName];
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePath] ? cachePath : nil;
}

+ (NSString *)audioCachedPath:(NSURL *)audioUrl{
    NSString *backStr = [[audioUrl.absoluteString componentsSeparatedByString:@"//"].lastObject stringByDeletingLastPathComponent];
    return [HYCachePath(YES) stringByAppendingPathComponent:backStr];
}

+ (CGFloat)hy_cacheSize:(BOOL)currentUser{
    NSString *path = HYCachePath(currentUser);
    NSArray *fileArray = [[NSFileManager defaultManager] subpathsAtPath:path];
    CGFloat size = 0;
    for (NSString *file in fileArray) {
        NSString *filePath = [path stringByAppendingPathComponent:file];
        size += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return size / 1000.0 / 1000.0;
}

+ (BOOL)hy_clearAudioCache:(NSURL *)audioUrl{
    NSString *path = [self hy_cachePath:audioUrl];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)hy_clearUserCache:(BOOL)currentUser{
    return [[NSFileManager defaultManager] removeItemAtPath:HYCachePath(currentUser) error:nil];
}

@end

@implementation HYAudioPlayerArchiverManager

+ (NSMutableDictionary *)hy_hasArchivedFileDictionary{
    _archiverDic = [NSKeyedUnarchiver unarchiveObjectWithFile:HYArchiverPath()];
    if (!_archiverDic){
        _archiverDic = [NSMutableDictionary dictionary];
    }
    return _archiverDic;
}

+ (BOOL)hy_archiveValue:(id)value forKey:(NSString *)key{
    NSMutableDictionary *dic = [HYAudioPlayerArchiverManager hy_hasArchivedFileDictionary];
    [dic setValue:value forKey:key];
    return [NSKeyedArchiver archiveRootObject:dic toFile:HYArchiverPath()];
}

+ (void)deleteKeyValueIfHaveArchivedWithUrl:(NSURL *)url{
    NSMutableDictionary *dic = [HYAudioPlayerArchiverManager hy_hasArchivedFileDictionary];
    __block BOOL isHave = NO;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:url.absoluteString]) {
            [dic removeObjectForKey:key];
            isHave = YES;
            *stop = YES;
        }
    }];
    if (isHave) {
        [NSKeyedArchiver archiveRootObject:dic toFile:HYArchiverPath()];
    }
}

@end


