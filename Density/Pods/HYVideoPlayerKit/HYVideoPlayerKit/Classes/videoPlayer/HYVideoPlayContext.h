//
//  HYVideoPlayContext.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYVideoPlayContext : NSObject

@property (nonatomic, assign) BOOL isShowSliderView;///< 是否显示 进度条 yes显示 no不显示 默认yes
@property (nonatomic, assign) BOOL isLoopPlay;///< 是否循环播放，yes循环播放 no不循环播放 默认no
@property (nonatomic, assign) BOOL isAutoPlay;///< 是否 自动播放，yes自动播放 no不自动播放 默认yes

@end

NS_ASSUME_NONNULL_END
