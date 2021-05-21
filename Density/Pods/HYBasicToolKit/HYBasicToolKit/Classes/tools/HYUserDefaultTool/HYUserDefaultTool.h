//
//  HYUserDefaultTool.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYUserDefaultTool : NSObject

+ (BOOL)addObject:(NSObject *)obj forKey:(NSString *)key;
+ (BOOL)removeObjectFor:(NSString *)key;
+ (NSObject *)getObjectFor:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
