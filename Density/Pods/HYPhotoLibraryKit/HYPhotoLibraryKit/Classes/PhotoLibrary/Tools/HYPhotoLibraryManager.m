//
//  HYPhotoLibraryManager.m
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/10.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import "HYPhotoLibraryManager.h"
#import "HYPhotoTools.h"
#import "NSMutableArray+AIThread.h"
#import "HYUtilsDeviceMacro.h"
#import "HYUtilsMacro.h"

@interface HYPhotoLibraryManager()
@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSMutableArray *allVideos;
@property (strong, nonatomic) NSMutableArray *allObjs;
//@property (assign, nonatomic) BOOL hasLivePhoto;
//------// 当要删除的已选中的图片或者视频的时候需要在对应的end数组里面删除
@property (strong, nonatomic) NSMutableArray *selectedList;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (strong, nonatomic) NSMutableArray *selectedVideos;
@property (strong, nonatomic) NSMutableArray *cameraList;
@property (strong, nonatomic) NSMutableArray *cameraPhotos;
@property (strong, nonatomic) NSMutableArray *cameraVideos;
@property (strong, nonatomic) NSMutableArray *endCameraList;
@property (strong, nonatomic) NSMutableArray *endCameraPhotos;
@property (strong, nonatomic) NSMutableArray *endCameraVideos;
@property (strong, nonatomic) NSMutableArray *selectedCameraList;
@property (strong, nonatomic) NSMutableArray *selectedCameraPhotos;
@property (strong, nonatomic) NSMutableArray *selectedCameraVideos;
@property (strong, nonatomic) NSMutableArray *endSelectedCameraList;
@property (strong, nonatomic) NSMutableArray *endSelectedCameraPhotos;
@property (strong, nonatomic) NSMutableArray *endSelectedCameraVideos;
@property (strong, nonatomic) NSMutableArray *endSelectedList;
@property (strong, nonatomic) NSMutableArray *endSelectedPhotos;
@property (strong, nonatomic) NSMutableArray *endSelectedVideos;

@property (assign, nonatomic) BOOL isOriginal;
@property (assign, nonatomic) BOOL endIsOriginal;
@property (copy, nonatomic) NSString *photosTotalBtyes;
@property (copy, nonatomic) NSString *endPhotosTotalBtyes;
@property (strong, nonatomic) NSMutableArray *iCloudUploadArray;
@property (strong, nonatomic) NSMutableArray *albums;

@end
@implementation HYPhotoLibraryManager
#pragma mark - < 初始化 >
- (instancetype)initWithType:(HYPhotoLibraryManagerSelectedType)type {
    if (self = [super init]) {
        self.type = type;
        [self setup];
    }
    return self;
}
- (instancetype)init {
    if ([super init]) {
        self.type = HYPhotoLibraryManagerSelectedTypePhoto;
        [self setup];
        
    }
    return self;
}


#pragma mark ----- 设置属性
- (void)setup {
    self.albums = [NSMutableArray array];
    self.selectedList = [NSMutableArray array];
    self.selectedPhotos = [NSMutableArray array];
    self.selectedVideos = [NSMutableArray array];
    self.endSelectedList = [NSMutableArray array];
    self.endSelectedPhotos = [NSMutableArray array];
    self.endSelectedVideos = [NSMutableArray array];
    self.cameraList = [NSMutableArray array];
    self.cameraPhotos = [NSMutableArray array];
    self.cameraVideos = [NSMutableArray array];
    self.endCameraList = [NSMutableArray array];
    self.endCameraPhotos = [NSMutableArray array];
    self.endCameraVideos = [NSMutableArray array];
    self.selectedCameraList = [NSMutableArray array];
    self.selectedCameraPhotos = [NSMutableArray array];
    self.selectedCameraVideos = [NSMutableArray array];
    self.endSelectedCameraList = [NSMutableArray array];
    self.endSelectedCameraPhotos = [NSMutableArray array];
    self.endSelectedCameraVideos = [NSMutableArray array];
    self.iCloudUploadArray = [NSMutableArray array];
    //    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}


- (void)addCustomAssetModel:(NSArray<HYCostomPhotoModel *> *)assetArray {
    if (!assetArray.count) return;
    if (![assetArray.firstObject isKindOfClass:[HYCostomPhotoModel class]]) {
        HYDebugLog(@"请传入装着HYCostomPhotoModel对象的数组");
        return;
    }
    NSInteger photoMaxCount = self.configuration.photoMaxNum;
    NSInteger videoMaxCount = self.configuration.videoMaxNum;
    NSInteger photoCount = 0;
    NSInteger videoCount = 0;
    BOOL canAddPhoto;
    BOOL canAddVideo;
    BOOL selectTogether = self.configuration.selectTogether;
    HYPhotoModel *firstModel;
    for (HYCostomPhotoModel *model in assetArray) {
        canAddPhoto = !(photoCount >= photoMaxCount);
        canAddVideo = !(videoCount >= videoMaxCount);
        if (!selectTogether && firstModel) {
            if (firstModel.subType == HYPhotoModelMediaSubTypePhoto) {
                canAddVideo = NO;
            }else if (firstModel.subType == HYPhotoModelMediaSubTypeVideo) {
                canAddPhoto = NO;
            }
        }
        
        if (model.type == HYCustomAssetModelTypeLocalImage && model.localImage) {
            if (self.type == HYPhotoModelMediaSubTypeVideo) {
                continue;
            }
            HYPhotoModel *photoModel = [HYPhotoModel photoModelWithImage:model.localImage];
            photoModel.selected = canAddPhoto ? model.selected : NO;
            if (model.selected && canAddPhoto) {
                [self.endCameraPhotos addObject:photoModel];
                [self.endSelectedCameraPhotos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
                [self.endSelectedCameraList addObject:photoModel];
                [self.endSelectedPhotos ai_addObject:photoModel];
                [self.endSelectedList ai_addObject:photoModel];
                firstModel = photoModel;
                photoCount++;
            }else {
                [self.endCameraPhotos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
            }
        }else if (model.type == HYCustomAssetModelTypeNetWorkImage && model.networkImageURL) {
            if (self.type == HYPhotoModelMediaSubTypeVideo) {
                continue;
            }
            HYPhotoModel *photoModel = [HYPhotoModel photoModelWithImageURL:model.networkImageURL];
            photoModel.selected = canAddPhoto ? model.selected : NO;
            if (model.selected && canAddPhoto) {
                [self.endCameraPhotos addObject:photoModel];
                [self.endSelectedCameraPhotos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
                [self.endSelectedCameraList addObject:photoModel];
                [self.endSelectedPhotos ai_addObject:photoModel];
                [self.endSelectedList ai_addObject:photoModel];
                firstModel = photoModel;
                photoCount++;
            }else {
                [self.endCameraPhotos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
            }
        }else if (model.type == HYCustomAssetModelTypeLocalVideo) {
            if (self.type == HYPhotoModelMediaSubTypePhoto) {
                continue;
            }
            // 本地视频
            HYPhotoModel *photoModel = [HYPhotoModel photoModelWithVideoURL:model.localVideoURL];
            photoModel.selected = canAddVideo ? model.selected : NO;
            if (model.selected && canAddVideo) {
                [self.endCameraVideos addObject:photoModel];
                [self.endSelectedCameraVideos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
                [self.endSelectedCameraList addObject:photoModel];
                [self.endSelectedVideos ai_addObject:photoModel];
                [self.endSelectedList ai_addObject:photoModel];
                firstModel = photoModel;
                videoCount++;
            }else {
                [self.endCameraVideos addObject:photoModel];
                [self.endCameraList addObject:photoModel];
            }
        }
    }
}

- (void)fetchAlbums:(void (^)(HYAlbumModel *selectedModel))selectedModel albums:(void(^)(NSArray *albums))albums {
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    if (self.albums.count > 0) [self.albums removeAllObjects];
    [self.iCloudUploadArray removeAllObjects];
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.type == HYPhotoLibraryManagerSelectedTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.type == HYPhotoLibraryManagerSelectedTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0 && ![[HYPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
            HYAlbumModel *albumModel = [[HYAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.result = result;
            if ([[HYPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] || [[HYPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                [self.albums insertObject:albumModel atIndex:0];
                if (selectedModel) {
                    selectedModel(albumModel);
                }
            }else {
                [self.albums addObject:albumModel];
            }
        }
    }];
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.type == HYPhotoLibraryManagerSelectedTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.type == HYPhotoLibraryManagerSelectedTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            HYAlbumModel *albumModel = [[HYAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = [HYPhotoTools transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.albums addObject:albumModel];
        }
    }];
    for (int i = 0 ; i < self.albums.count; i++) {
        HYAlbumModel *model = self.albums[i];
        model.index = i;
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"currentAlbumIndex = %d", i];
        //        NSArray *newArray = [self.selectedList filteredArrayUsingPredicate:pred];
        //        model.selectedCount = newArray.count;
    }
    if (!self.albums.count &&
        [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        HYPhotoModel *photoMd = self.cameraList.firstObject;
        HYAlbumModel *albumModel = [[HYAlbumModel alloc] init];
        albumModel.count = self.cameraList.count;
        albumModel.albumName = @"所有照片";
        albumModel.index = 0;
        albumModel.tempImage = photoMd.thumbPhoto;
        [self.albums addObject:albumModel];
    }
    if (albums) {
        albums(self.albums);
    }
}

/**
 获取系统所有相册
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void(^)(NSArray *albums))albums isFirst:(BOOL)isFirst {
        
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    if (self.type == HYPhotoLibraryManagerSelectedTypePhoto) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }else if (self.type == HYPhotoLibraryManagerSelectedTypeVideo) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    }
//
//    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *streamAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    NSArray *arrAllAlbums = @[smartAlbums, streamAlbums, userAlbums, syncedAlbums , sharedAlbums];


    NSMutableArray<HYAlbumModel *> *arrAlbum = [NSMutableArray array];
    for (PHFetchResult<PHAssetCollection *> *album in arrAllAlbums) {
        [album enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            //过滤PHCollectionList对象
            if (![collection isKindOfClass:PHAssetCollection.class]) return;
            //过滤最近删除和已隐藏
            if (collection.assetCollectionSubtype > 215 ||
                collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden || collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) return;
            //获取相册内asset result
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (!result.count) return;

            HYAlbumModel *albumModel = [[HYAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.result = result;
            
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                // 全部照片的相册分组
                [arrAlbum insertObject:albumModel atIndex:0];

            } else {
                [arrAlbum addObject:albumModel];
            }
        }];
    }
    
    self.albums = arrAlbum;
    [self.iCloudUploadArray removeAllObjects];

    /** 给每个model加上index标签 */
    for (int i = 0 ; i < self.albums.count; i++) {
        HYAlbumModel *model = self.albums[i];
        model.index = i;
    }
    
    if (!self.albums.count &&
        [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        HYPhotoModel *photoMd = self.cameraList.firstObject;
        HYAlbumModel *albumModel = [[HYAlbumModel alloc] init];
        albumModel.count = self.cameraList.count;
        albumModel.albumName = @"所有照片";
        albumModel.index = 0;
        albumModel.tempImage = photoMd.thumbPhoto;
        [self.albums addObject:albumModel];
    }
    
    if (albums) {
        albums(self.albums);
    }
}

- (void)getPhotoListWithAlbumModel:(HYAlbumModel *)albumModel complete:(void (^)(NSArray *allList , NSArray *previewList,NSArray *photoList ,NSArray *videoList ,NSArray *dateList , HYPhotoModel *firstSelectModel))complete {
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *previewArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];
    
//    __block HYPhotoDateModel *dateModel;
    __block HYPhotoModel *firstSelectModel;
//    __block BOOL already = NO;
    NSMutableArray *selectList = [NSMutableArray arrayWithArray:self.selectedList];
    if (self.configuration.reverseDate) {
        [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HYPhotoModel *photoModel = [[HYPhotoModel alloc] init];
            photoModel.clarityScale = self.configuration.clarityScale;
            photoModel.asset = asset;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                if (self.iCloudUploadArray.count) {
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"localIdentifier = %@", asset.localIdentifier];
                    NSArray *newArray = [self.iCloudUploadArray filteredArrayUsingPredicate:pred];
                    if (!newArray.count) {
                        photoModel.isICloud = YES;
                    }
                }else {
                    photoModel.isICloud = YES;
                }
            }
            if (selectList.count > 0) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"localIdentifier = %@", asset.localIdentifier];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    HYPhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if ((model.type == HYPhotoModelMediaTypePhoto || model.type == HYPhotoModelMediaTypePhotoGif) || (model.type == HYPhotoModelMediaTypeLivePhoto || model.type == HYPhotoModelMediaTypeCameraPhoto)) {
                        if (model.type == HYPhotoModelMediaTypeCameraPhoto) {
                            [self.selectedCameraPhotos replaceObjectAtIndex:[self.selectedCameraPhotos indexOfObject:model] withObject:photoModel];
                        }else {
                            [self.selectedPhotos ai_replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                        }
                    }else {
                        if (model.type == HYPhotoModelMediaTypeCameraVideo) {
                            [self.selectedCameraVideos replaceObjectAtIndex:[self.selectedCameraVideos indexOfObject:model] withObject:photoModel];
                        }else {
                            [self.selectedVideos ai_replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                        }
                    }
                    [self.selectedList ai_replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.selectIndexStr = model.selectIndexStr;
                    if (!firstSelectModel) {
                        firstSelectModel = photoModel;
                    }
                }
            }
            if (asset.mediaType == PHAssetMediaTypeImage) {
                photoModel.subType = HYPhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.configuration.singleSelected) {
                        photoModel.type = HYPhotoModelMediaTypePhoto;
                    }else {
                        photoModel.type = self.configuration.lookGifPhoto ? HYPhotoModelMediaTypePhotoGif : HYPhotoModelMediaTypePhoto;
                    }
                }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive  || asset.mediaSubtypes == 10){
                    if (KHYISIOS9) {
                        if (!self.configuration.singleSelected) {
                            photoModel.type = self.configuration.lookLivePhoto ? HYPhotoModelMediaTypeLivePhoto : HYPhotoModelMediaTypePhoto;
                        }else {
                            photoModel.type = HYPhotoModelMediaTypePhoto;
                        }
                    }else {
                        photoModel.type = HYPhotoModelMediaTypePhoto;
                    }
                    [photoArray addObject:photoModel];
                }else {
                    photoModel.type = HYPhotoModelMediaTypePhoto;
                    [photoArray addObject:photoModel];
                }
                
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = HYPhotoModelMediaSubTypeVideo;
                photoModel.type = HYPhotoModelMediaTypeVideo;
                [videoArray addObject:photoModel];
                // 默认视频都是可选的
                [self changeModelVideoState:photoModel];
            }
            photoModel.currentAlbumIndex = albumModel.index;
            
            BOOL canAddPhoto = YES;
            if (self.configuration.filtrationICloudAsset) {
                if (!photoModel.isICloud) {
                    [allArray addObject:photoModel];
                    [previewArray addObject:photoModel];
                }else {
                    canAddPhoto = NO;
                }
            }else {
                [allArray addObject:photoModel];
                if (photoModel.isICloud) {
                    if (self.configuration.downloadICloudAsset) {
                        [previewArray addObject:photoModel];
                    }
                }else {
                    [previewArray addObject:photoModel];
                }
            }
            photoModel.dateItem = allArray.count - 1;
            photoModel.dateSection = 0;
            
            
        }];
    }else {
        NSInteger index = 0;
        for (PHAsset *asset in albumModel.result) {
            HYPhotoModel *photoModel = [[HYPhotoModel alloc] init];
            photoModel.asset = asset;
            photoModel.clarityScale = self.configuration.clarityScale;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                if (self.iCloudUploadArray.count) {
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"localIdentifier = %@", asset.localIdentifier];
                    NSArray *newArray = [self.iCloudUploadArray filteredArrayUsingPredicate:pred];
                    if (!newArray.count) {
                        photoModel.isICloud = YES;
                    }
                }else {
                    photoModel.isICloud = YES;
                }
            }
            if (selectList.count > 0) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"localIdentifier = %@", asset.localIdentifier];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    HYPhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if ((model.type == HYPhotoModelMediaTypePhoto || model.type == HYPhotoModelMediaTypePhotoGif) || (model.type == HYPhotoModelMediaTypeLivePhoto || model.type == HYPhotoModelMediaTypeCameraPhoto)) {
                        if (model.type == HYPhotoModelMediaTypeCameraPhoto) {
                            [self.selectedCameraPhotos replaceObjectAtIndex:[self.selectedCameraPhotos indexOfObject:model] withObject:photoModel];
                        }else {
                            [self.selectedPhotos ai_replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                        }
                    }else {
                        if (model.type == HYPhotoModelMediaTypeCameraVideo) {
                            [self.selectedCameraVideos replaceObjectAtIndex:[self.selectedCameraVideos indexOfObject:model] withObject:photoModel];
                        }else {
                            [self.selectedVideos ai_replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                        }
                    }
                    [self.selectedList ai_replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.selectIndexStr = model.selectIndexStr;
                    if (!firstSelectModel) {
                        firstSelectModel = photoModel;
                    }
                }
            }
            if (asset.mediaType == PHAssetMediaTypeImage) {
                photoModel.subType = HYPhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.configuration.singleSelected) {
                        photoModel.type = HYPhotoModelMediaTypePhoto;
                    }else {
                        photoModel.type = self.configuration.lookGifPhoto ? HYPhotoModelMediaTypePhotoGif : HYPhotoModelMediaTypePhoto;
                    }
                }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 10){
                    if (KHYISIOS9) {
                        if (!self.configuration.singleSelected) {
                            photoModel.type = self.configuration.lookLivePhoto ? HYPhotoModelMediaTypeLivePhoto : HYPhotoModelMediaTypePhoto;
                        }else {
                            photoModel.type = HYPhotoModelMediaTypePhoto;
                        }
                    }else {
                        photoModel.type = HYPhotoModelMediaTypePhoto;
                    }
                    [photoArray addObject:photoModel];
                }else {
                    photoModel.type = HYPhotoModelMediaTypePhoto;
                    [photoArray addObject:photoModel];
                }
                //                if (!photoModel.isICloud) {
                //                }
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = HYPhotoModelMediaSubTypeVideo;
                photoModel.type = HYPhotoModelMediaTypeVideo;
                //                if (!photoModel.isICloud) {
                [videoArray addObject:photoModel];
                //                }
                // 默认视频都是可选的
                [self changeModelVideoState:photoModel];
            }
            photoModel.currentAlbumIndex = albumModel.index;
            BOOL canAddPhoto = YES;
            if (self.configuration.filtrationICloudAsset) {
                if (!photoModel.isICloud) {
                    [allArray addObject:photoModel];
                    [previewArray addObject:photoModel];
                }else {
                    canAddPhoto = NO;
                }
            }else {
                [allArray addObject:photoModel];
                if (photoModel.isICloud) {
                    if (self.configuration.downloadICloudAsset) {
                        [previewArray addObject:photoModel];
                    }
                }else {
                    [previewArray addObject:photoModel];
                }
            }
            photoModel.dateItem = allArray.count - 1;
            photoModel.dateSection = 0;
            
            index++;
        }
    }
    
    NSInteger cameraIndex = self.configuration.openCamera ? 1 : 0;
    
    if (self.cameraList.count > 0) {
        NSInteger index = 0;
        NSInteger photoIndex = 0;
        NSInteger videoIndex = 0;
        for (HYPhotoModel *model in self.cameraList) {
            if ([self.selectedCameraList containsObject:model]) {
                model.selected = YES;
                model.selectedIndex = [self.selectedList indexOfObject:model];
                model.selectIndexStr = [NSString stringWithFormat:@"%tu",model.selectedIndex + 1];
            }else {
                model.selected = NO;
                model.selectIndexStr = @"";
                model.selectedIndex = 0;
            }
            model.currentAlbumIndex = albumModel.index;
            if (self.configuration.reverseDate) {
                [allArray insertObject:model atIndex:cameraIndex + index];
                [previewArray insertObject:model atIndex:index];
                if (model.subType == HYPhotoModelMediaSubTypePhoto) {
                    [photoArray insertObject:model atIndex:photoIndex];
                    photoIndex++;
                }else {
                    [videoArray insertObject:model atIndex:videoIndex];
                    videoIndex++;
                }
            }else {
                NSInteger count = allArray.count;
                NSInteger atIndex = (count - cameraIndex) < 0 ? 0 : count - cameraIndex;
                [allArray insertObject:model atIndex:atIndex];
                [previewArray addObject:model];
                if (model.subType == HYPhotoModelMediaSubTypePhoto) {
                    [photoArray addObject:model];
                }else {
                    [videoArray addObject:model];
                }
            }
      
            model.dateSection = 0;
            index++;
        }
    }
    
    if (complete) {
        complete(allArray,previewArray,photoArray,videoArray,dateArray,firstSelectModel);
    }
}

// 删除选择的图片或者视频到选择数组
- (void)beforeSelectedListdeletePhotoModel:(HYPhotoModel *)model {
    model.selected = NO;
    model.selectIndexStr = @"";
    if (model.subType == HYPhotoModelMediaSubTypePhoto) {
        [self.selectedPhotos ai_removeObject:model];
        model.thumbPhoto = nil;
        model.previewPhoto = nil;
        
    }else if (model.subType == HYPhotoModelMediaSubTypeVideo) {
        [self.selectedVideos ai_removeObject:model];
        model.thumbPhoto = nil;
        model.previewPhoto = nil;
    }
    [self.selectedList ai_removeObject:model];
    int i = 0;
    @synchronized (self) {
        for (HYPhotoModel *model in self.selectedList) {
            model.selectIndexStr = [NSString stringWithFormat:@"%d",i + 1];
            i++;
        }
    }
}

// 添加选择的图片或者视频到选择数组
- (void)beforeSelectedListAddPhotoModel:(HYPhotoModel *)model {
    if (model.subType == HYPhotoModelMediaSubTypePhoto) {
        [self.selectedPhotos ai_addObject:model];
    }else if (model.subType == HYPhotoModelMediaSubTypeVideo) {
        [self.selectedVideos ai_addObject:model];
    }
    [self.selectedList ai_addObject:model];
    model.selected = YES;
    @synchronized (self) {
        model.selectIndexStr = [NSString stringWithFormat:@"%tu",[self.selectedList indexOfObject:model] + 1];
    }
}


- (void)beforeExchangeListPhotoModelWithIndex : (NSInteger)fromIndex toIndex : (NSInteger)toIndex {
    
    HYPhotoModel *model = [self.selectedList ai_objectAtIndex:fromIndex];
    //先把移动的这个model移除
    [self.selectedList ai_removeObject:model];
    //再把这个移动的model插入到相应的位置
    [self.selectedList ai_insertObject:model atIndex:toIndex];
    int i = 0;
    @synchronized (self) {
        for (HYPhotoModel *model in self.selectedList) {
            model.selectIndexStr = [NSString stringWithFormat:@"%d",i + 1];
            i++;
        }
    }
}

- (void)afterSelectedListdeletePhotoModel:(HYPhotoModel *)model {
    if (model.subType == HYPhotoModelMediaSubTypePhoto) {
        [self.endSelectedPhotos ai_removeObject:model];
    }else if (model.subType == HYPhotoModelMediaSubTypeVideo) {
        [self.endSelectedVideos ai_removeObject:model];
    }
    [self.endSelectedList ai_removeObject:model];
    
    int i = 0;
    @synchronized (self) {
        for (HYPhotoModel *model in self.selectedList) {
            model.selectIndexStr = [NSString stringWithFormat:@"%d",i + 1];
            i++;
        }
    }
}
- (void)afterSelectedListAddPhotoModel:(HYPhotoModel *)model {
    // 默认视频都是可选的
    [self changeModelVideoState:model];
    
    if (model.subType == HYPhotoModelMediaSubTypePhoto) {
        [self.endSelectedPhotos ai_addObject:model];
    }else {
        [self.endSelectedVideos ai_addObject:model];
    }
    [self.endSelectedList ai_addObject:model];
}

// 添加icloud 照片
- (void)addICloudModel:(HYPhotoModel *)model {
    if (![self.iCloudUploadArray containsObject:model]) {
        [self.iCloudUploadArray addObject:model];
    }
}
#pragma mark -  改变模型的视频状态
- (void)changeModelVideoState:(HYPhotoModel *)model {
    if (self.configuration.specialModeNeedHideVideoSelectBtn) {
        if (self.videoSelectedType == HYPhotoLibraryManagerVideoSelectedTypeSingle && model.subType == HYPhotoModelMediaSubTypeVideo) {
            model.needHideSelectBtn = YES;
        }
    }
    if (model.subType == HYPhotoModelMediaSubTypeVideo) {
        if (model.type == HYPhotoModelMediaTypeVideo) {
            if (model.asset.duration < 3) {
                model.videoState = HYPhotoModelVideoStateUndersize;
            }else if (model.asset.duration >= self.configuration.videoMaxDuration + 1) {
                model.videoState = HYPhotoModelVideoStateOversize;
            }
        }else if (model.type == HYPhotoModelMediaTypeCameraVideo) {
            if (model.videoDuration < 3) {
                model.videoState = HYPhotoModelVideoStateUndersize;
            }else if (model.videoDuration >= self.configuration.videoMaxDuration + 1) {
                model.videoState = HYPhotoModelVideoStateOversize;
            }
        }
    }
}

- (NSString *)maximumOfJudgment:(HYPhotoModel *)model {
    if ([self beforeSelectCountIsMaximum]) {
        // 已经达到最大选择数 [NSString stringWithFormat:@"最多只能选择%ld个",manager.maxNum]
        return [NSString stringWithFormat:@"最多选择%ld张图片",self.configuration.maxNum];
    }
    if (self.type == HYPhotoLibraryManagerSelectedTypePhotoAndVideo) {
        if ((model.type == HYPhotoModelMediaTypePhoto || model.type == HYPhotoModelMediaTypePhotoGif) || (model.type == HYPhotoModelMediaTypeCameraPhoto || model.type == HYPhotoModelMediaTypeLivePhoto)) {
            if (self.configuration.videoMaxNum > 0) {
                if (!self.configuration.selectTogether) { // 是否支持图片视频同时选择
                    if (self.selectedVideos.count > 0 ) {
                        // 已经选择了视频,不能再选图片
                        return @"图片不能和视频同时选择";
                    }
                }
            }
            if (self.selectedPhotos.count == self.configuration.photoMaxNum) {
                // 已经达到图片最大选择数
                
                return [NSString stringWithFormat:@"最多只能选择%ld张图片",self.configuration.photoMaxNum];
            }
        }else if (model.type == HYPhotoModelMediaTypeVideo || model.type == HYPhotoModelMediaTypeCameraVideo) {
            if (self.configuration.photoMaxNum > 0) {
                if (!self.configuration.selectTogether) { // 是否支持图片视频同时选择
                    if (self.selectedPhotos.count > 0 ) {
                        // 已经选择了图片,不能再选视频
                        return @"视频和图片不能同时选择";
                    }
                }
            }
            if ([self beforeSelectVideoCountIsMaximum]) {
                // 已经达到视频最大选择数
                
                return [NSString stringWithFormat:@"最多只能选择%ld个视频",self.configuration.videoMaxNum];
            }
        }
    }else if (self.type == HYPhotoLibraryManagerSelectedTypePhoto) {
        if ([self beforeSelectPhotoCountIsMaximum]) {
            // 已经达到图片最大选择数
            return [NSString stringWithFormat:@"最多只能选择%ld张图片",self.configuration.photoMaxNum];
        }
    }else if (self.type == HYPhotoLibraryManagerSelectedTypeVideo) {
        if ([self beforeSelectVideoCountIsMaximum]) {
            // 已经达到视频最大选择数
            return [NSString stringWithFormat:@"最多只能选择%ld个视频",self.configuration.videoMaxNum];
        }
    }
    if (model.type == HYPhotoModelMediaTypeVideo) {
        if (model.asset.duration < 3) {
            return @"视频少于3秒,无法选择";
        }else if (model.asset.duration >= self.configuration.videoMaxDuration + 1) {
            return @"视频过大,无法选择";
        }
    }else if (model.type == HYPhotoModelMediaTypeCameraVideo) {
        if (model.videoDuration < 3) {
            return @"视频少于3秒,无法选择";
        }else if (model.videoDuration >= self.configuration.videoMaxDuration + 1) {
            return @"视频过大,无法选择";
        }
    }
    return nil;
}
#pragma mark ----- 判断选择的数量
- (BOOL)beforeSelectCountIsMaximum {
    if (self.selectedList.count >= self.configuration.maxNum) {
        return YES;
    }
    return NO;
}
- (BOOL)beforeSelectPhotoCountIsMaximum {
    if (self.selectedPhotos.count >= self.configuration.photoMaxNum) {
        return YES;
    }
    return NO;
}
- (BOOL)beforeSelectVideoCountIsMaximum {
    if (self.selectedVideos.count >= self.configuration.videoMaxNum) {
        return YES;
    }
    return NO;
}

#pragma mark ----- 返回选择的数组
- (NSArray *)selectedArray {
    return self.selectedList;
}
- (NSArray *)selectedPhotoArray {
    return self.selectedPhotos;
}
- (NSArray *)selectedVideoArray {
    return self.selectedVideos;
}
#pragma mark ----- 懒加载
- (HYPhotoConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[HYPhotoConfiguration alloc] init];
    }
    return _configuration;
}

@end
