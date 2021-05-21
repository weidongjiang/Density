//
//  HYUserDefaultTool.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import "HYUserDefaultTool.h"

@implementation HYUserDefaultTool
+ (BOOL)addObject:(NSObject*)obj forKey:(NSString*)key
{
    if (!obj || !key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    @synchronized(self){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:obj forKey:key];
        return [defaults synchronize];
    }
}

+ (NSObject*)getObjectFor:(NSString*)key
{
    if(!key || [key length] == 0 || (NSNull*)key == [NSNull null]){
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *object = [defaults objectForKey:key];
    return object;
}

+ (BOOL)removeObjectFor:(NSString*)key
{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    @synchronized(self){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:key];
        return [defaults synchronize];
    }
}

@end
