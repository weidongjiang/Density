//
//  HYPhotoDownloadProgressView.h
//  HyWallPaper
//
//  Created by 朱玉 on 2018/10/17.
//  Copyright © 2018年 朱玉HyWallPaper. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HYPhotoDownloadProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
- (void)resetState;
- (void)startAnima;

@end


