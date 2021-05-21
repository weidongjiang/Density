//
//  HYVideoThumbnail.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import "HYVideoThumbnail.h"

@implementation HYVideoThumbnail

+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time {
    return [[self alloc] initWithImage:image time:time];
}

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time {
    self = [super init];
    if (self) {
        _image = image;
        _time = time;
    }
    return self;
}

@end
