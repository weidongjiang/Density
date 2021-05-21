//
//  HYCostomPhotoModel.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/12.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYCostomPhotoModel.h"

@interface HYCostomPhotoModel ()
@property (copy, nonatomic) NSString *localImageName;
@end
@implementation HYCostomPhotoModel
+ (instancetype)assetWithLocaImageName:(NSString *)imageName selected:(BOOL)selected {
    return [[self alloc] initAssetWithLocaImageName:imageName selected:selected];
}

- (instancetype)initAssetWithLocaImageName:(NSString *)imageName selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.type = HYCustomAssetModelTypeLocalImage;
        self.localImageName = imageName;
        self.localImage = [UIImage imageNamed:imageName];
        self.selected = selected;
    }
    return self;
}

+ (instancetype)assetWithLocalImage:(UIImage *)image selected:(BOOL)selected {
    return [[self alloc] initAssetWithLocalImage:image selected:selected];
}

- (instancetype)initAssetWithLocalImage:(UIImage *)image selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.type = HYCustomAssetModelTypeLocalImage;
        self.localImage = image;
        self.selected = selected;
    }
    return self;
}

+ (instancetype)assetWithNetworkImageURL:(NSURL *)imageURL selected:(BOOL)selected {
    return [[self alloc] initAssetWithNetworkImageURL:imageURL selected:selected];
}

- (instancetype)initAssetWithNetworkImageURL:(NSURL *)imageURL selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.type = HYCustomAssetModelTypeNetWorkImage;
        self.networkImageURL = imageURL;
        self.selected = selected;
    }
    return self;
}

+ (instancetype)assetWithLocalVideoURL:(NSURL *)videoURL selected:(BOOL)selected {
    return [[self alloc] initAssetWithLocalVideoURL:videoURL selected:selected];
}

- (instancetype)initAssetWithLocalVideoURL:(NSURL *)videoURL selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.type = HYCustomAssetModelTypeLocalVideo;
        self.localVideoURL = videoURL;
        self.selected = selected;
    }
    return self;
}
@end
