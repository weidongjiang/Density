//
//  HYEditVideoModuleView.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYEditVideoModuleView : UIView

//开始时间改变时的回调
@property (nonatomic,copy) void (^getTimeRange)(CGFloat startTime,CGFloat endTime,CGFloat imageTime);

//结束时间变化的回调
@property (nonatomic,copy) void (^cutWhenDragEnd)(void);
@property (nonatomic,copy) void (^cutWhenDragBegan)(void);
@property (nonatomic,copy) void (^cutWhenDragChanged)(void);

- (void)setThumbnailImages:(NSArray *)images totalTime:(double)totalTime;

- (void)updateMoveLineViewCurrentTime:(double)currentTime duration:(double)duration;

@end

NS_ASSUME_NONNULL_END
