//
//  HYVideoThumbnail.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYVideoThumbnail : NSObject

+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time;

@property (nonatomic, readonly) CMTime time;
@property (strong, nonatomic, readonly) UIImage *image;

@end

NS_ASSUME_NONNULL_END
