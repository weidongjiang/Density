//
//  MDPhotoBrowserConfigure.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDPhotoBrowserConfigure.h"

@implementation MDPhotoBrowserConfigure
- (instancetype)init {
    if (self = [super init]) {
        _isHiddenPageControl = NO;
        _configureStyle = MDPhotoBrowserConfigureStyleAll;
        _isAddZoomGesture = YES;
        _isVideoAutoPlay = YES;
    }
    return self;
}

@end
