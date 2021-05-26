//
//  MDPhotoBrowserViewPlayManager.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import <Foundation/Foundation.h>
#import "HYVideoPlayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDPhotoBrowserViewPlayManager : NSObject

+ (instancetype)sharedManager;
- (void)initPlayViewWithFrame:(CGRect)frame
                          url:(NSURL *)url
                      context:(HYVideoPlayContext *)context
                    superView:(UIView *)superView;

/// 当初始化后需要更新 时调用
/// @param frame frame description
- (void)updatePlayViewFrame:(CGRect)frame;

/// 当还是当前播放器，需要更换播放数据源的时候更新,新的数据源从0开始播放
/// @param url url description
- (void)updatePlayerWithUrl:(NSURL *)url;

- (void)updatePlayContext:(HYVideoPlayContext *)context;

- (void)pause;

- (void)play;

- (void)seekToTime:(double)time;

@end

NS_ASSUME_NONNULL_END
