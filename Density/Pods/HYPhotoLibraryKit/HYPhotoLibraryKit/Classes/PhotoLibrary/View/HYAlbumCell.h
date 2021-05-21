//
//  HYAlbumCell.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/18.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HYAlbumModel;

@interface HYAlbumCell : UITableViewCell
- (void)configCellWithAlbumModel : (HYAlbumModel *)albumModel;
@end


