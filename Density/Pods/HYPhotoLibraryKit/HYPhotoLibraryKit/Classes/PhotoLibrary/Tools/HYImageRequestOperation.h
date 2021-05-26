//
//  HYImageRequestOperation.h
//  AIPhotos
//
//  Created by Json on 2021/4/13.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYImageRequestOperation : NSOperation
typedef void(^HYImageRequestCompletedBlock)(UIImage *__nullable photo, NSDictionary *info, BOOL isDegraded);
typedef void(^HYImageRequestProgressBlock)(double progress, NSError *error, BOOL *stop, NSDictionary *info);

@property (nonatomic, copy, nullable) HYImageRequestCompletedBlock completedBlock;
@property (nonatomic, copy, nullable) HYImageRequestProgressBlock progressBlock;
@property (nonatomic, strong, nullable) PHAsset *asset;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

- (instancetype)initWithAsset:(PHAsset *)asset completion:(HYImageRequestCompletedBlock)completionBlock progressHandler:(HYImageRequestProgressBlock)progressHandler;
- (void)done;
@end

NS_ASSUME_NONNULL_END
