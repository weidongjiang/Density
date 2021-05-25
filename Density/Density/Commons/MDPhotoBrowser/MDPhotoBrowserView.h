//
//  MDPhotoBrowserView.h
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import <UIKit/UIKit.h>
#import "MDPhotoBrowserConfigure.h"
#import "MDPhotoBrowserModel.h"
#import "SMPageControl.h"

NS_ASSUME_NONNULL_BEGIN


@interface MDPhotoBrowserView : UIView

@property (nonatomic, strong) MDPhotoBrowserConfigure *configure;
@property (nonatomic, strong) NSArray<MDPhotoBrowserModel *> *browserDataArray;




@end

NS_ASSUME_NONNULL_END
