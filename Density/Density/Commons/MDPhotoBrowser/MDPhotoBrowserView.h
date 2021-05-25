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

@class MDPhotoBrowserView;
@protocol MDPhotoBrowserViewDelegate <NSObject>
@optional
- (void)bannerView:(MDPhotoBrowserView *)bannerView didSelectAtIndex:(NSInteger)index;
- (void)bannerView:(MDPhotoBrowserView *)bannerView didShowAtIndex:(NSInteger)index;

@end

@interface MDPhotoBrowserView : UIView

@property (nonatomic, strong) MDPhotoBrowserConfigure *configure;
@property (nonatomic, strong) NSArray<MDPhotoBrowserModel *> *browserDataArray;


@property(nonatomic, weak) id<MDPhotoBrowserViewDelegate> bannerDelegate;
@property(nonatomic, strong, readonly) SMPageControl *pageControl;
@property(nonatomic) NSInteger currentPage; //default is 0.
@property(nonatomic) BOOL autoScroll; //default is YES.
@property(nonatomic) NSTimeInterval animationDuration; //default is 3s.
@property(nonatomic, strong) UIImage *placeholderImage;

- (void)continueTimerLater;

- (void)pauseTimer;
/**
 *  do NOT use ".pageControl.frame = " to change frame of pageControl. Default is CGRectMake(0,
 *  self.frame.size.height - 22, self.frame.size.width, 22).
 */
@property(nonatomic) CGRect pageControlFrame;

//  object in "imageUrls" must be kind of NSString or NSURL class"
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls;
- (void)reloadWithImageUrls:(NSArray *)imageUrls;

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
