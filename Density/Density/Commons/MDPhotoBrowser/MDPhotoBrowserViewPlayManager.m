//
//  MDPhotoBrowserViewPlayManager.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDPhotoBrowserViewPlayManager.h"

@implementation MDPhotoBrowserViewPlayManager

+ (instancetype)sharedManager {
    static MDPhotoBrowserViewPlayManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MDPhotoBrowserViewPlayManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


@end
