//
//  HYAlbumPopView.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/18.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYAlbumPopView : UIView
@property (nonatomic,strong) NSArray *albumsArray;
@property(nonatomic, assign) CGSize intrinsicContentSize; //重写 intrinsicContentSize 属性
@property (nonatomic, copy) void (^selectedAtIndex)(int index);

#pragma mark ----- 隐藏和展现相册
- (void)hideMenu;
- (void)showMenu;
- (void)dissmissMenu;
- (void)setTitleContent : (NSString *)content;
@end


