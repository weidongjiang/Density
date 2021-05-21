//
//  HYFilePathTool.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYFilePathTool : NSObject

@property (nonatomic, readonly, strong)   NSString    *homePath;
@property (nonatomic, readonly, strong)   NSString    *docmentsPath;
@property (nonatomic, readonly, strong)   NSString    *dbPath;
@property (nonatomic, readonly, strong)   NSString    *libraryPath;
@property (nonatomic, readonly, strong)   NSString    *tmpPath;
@property (nonatomic, readonly, strong)   NSString    *cachesPath;
@property (nonatomic, readonly, strong)   NSString    *preferencesPath;
@property (nonatomic, readonly, strong)   NSString    *bundlePath;
@property (nonatomic, readonly, strong)   NSString    *downloadPath;
@property (nonatomic, readonly, strong)   NSString    *coredataPath;

+ (HYFilePathTool *)sharedInstance;
// 创建对应的本地路径
- (NSString *)createDirPathIfNeed:(NSString *)dirPath;
@end

NS_ASSUME_NONNULL_END
