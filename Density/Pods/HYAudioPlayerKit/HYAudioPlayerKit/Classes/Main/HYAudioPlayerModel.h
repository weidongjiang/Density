//
//  HYAudioPlayerModel.h
//  HyWallPaper
//
//  Created by Json on 2020/2/10.
//  Copyright © 2020 朱玉HyWallPaper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAudioPlayerModel : NSObject

// 标识当前音频在数组中的位置
@property (nonatomic, assign) NSUInteger audioIndex;

// 音频地址
@property (nonatomic, strong) NSURL *audioUrl;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ringName;
@property (nonatomic, strong) NSString *singer;
@property (nonatomic, strong) NSString *icon;

@end



