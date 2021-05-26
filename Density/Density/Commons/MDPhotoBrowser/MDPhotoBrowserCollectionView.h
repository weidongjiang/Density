//
//  MDPhotoBrowserCollectionView.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDPhotoBrowserCollectionView : NSObject

@property (nonatomic, strong) UICollectionView        *collectionView; ///< <#value#>
@property (nonatomic, strong) NSMutableArray        *collectionViewDataArray; ///< <#value#>

- (void)initCollectionViewFrame:(CGRect)frame itemSize:(CGSize)itemSize;

@end

NS_ASSUME_NONNULL_END
