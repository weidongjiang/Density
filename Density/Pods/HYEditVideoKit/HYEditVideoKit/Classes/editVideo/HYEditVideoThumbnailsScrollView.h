//
//  HYEditVideoThumbnailsScrollView.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYEditVideoThumbnailsScrollView : UIView


@property (strong, nonatomic,readonly) UIScrollView *scrollView;

- (void)updateThumbnailsView:(NSArray *)thumbnails totalTime:(double)totalTime;

@end

NS_ASSUME_NONNULL_END
