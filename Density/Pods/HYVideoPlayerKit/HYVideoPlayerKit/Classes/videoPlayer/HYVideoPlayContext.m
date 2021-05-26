//
//  HYVideoPlayContext.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/2.
//

#import "HYVideoPlayContext.h"

@implementation HYVideoPlayContext

- (instancetype)init {
    if (self = [super init]) {
        _isLoopPlay = NO;
        _isShowSliderView = YES;
        _isAutoPlay = YES;
    }
    return self;
}

@end
