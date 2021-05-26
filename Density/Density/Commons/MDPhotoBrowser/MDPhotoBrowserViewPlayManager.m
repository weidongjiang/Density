//
//  MDPhotoBrowserViewPlayManager.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import "MDPhotoBrowserViewPlayManager.h"

@interface MDPhotoBrowserViewPlayManager ()

@property (nonatomic, strong) HYVideoPlayView *playView;

@end


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

- (void)initPlayViewWithFrame:(CGRect)frame
                          url:(NSURL *)url
                      context:(HYVideoPlayContext *)context
                    superView:(UIView *)superView {
                        if (!self.playView) {
                            self.playView = [[HYVideoPlayView alloc] initWithFrame:CGRectZero url:url context:context];
                            [superView addSubview:self.playView];
                        }
    [self.playView updatePlayViewFrame:frame];
    [self.playView updatePlayerWithUrl:url];
    [self.playView updatePlayContext:context];
    [self.playView pause];
}

- (void)updatePlayViewFrame:(CGRect)frame {
    [self.playView updatePlayViewFrame:frame];
}

- (void)updatePlayerWithUrl:(NSURL *)url {
    [self.playView updatePlayerWithUrl:url];
    [self.playView pause];
}

- (void)updatePlayContext:(HYVideoPlayContext *)context {
    [self.playView updatePlayContext:context];
}

- (void)pause {
    [self.playView pause];
}

- (void)play {
    [self pause];
    [self.playView play];
}

- (void)seekToTime:(double)time {
    [self.playView seekToTime:time];
}

@end
