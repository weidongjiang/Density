//
//  HYLocationTool.h
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * _Nonnull const HYUpdateLocationSuccess_Notification;
extern NSString * _Nonnull const HYUpdateLocationFailed_Notification;
extern NSString * _Nonnull const HYUpdateLocationAuthorizationStatus_Notification;
extern NSString * _Nonnull const HYUpdateLocationAuthorizationStatusKey;

NS_ASSUME_NONNULL_BEGIN

@interface HYLocationTool : NSObject
@property (nonatomic, readonly) CLLocation *currentLocation;//当前位置
@property (nonatomic, readonly) NSString *province;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, assign) NSUInteger refreshLocationInterval;//定位器刷新间隔
@property (nonatomic, assign) NSInteger distanceFilter;//距离回调间隔

+ (instancetype) sharedManager;

/**
 是否可以定位

 @return 是否可以定位
 */
+ (BOOL)locationServicesEnabled;

/**
 定位权限状态

 @return 定位权限
 */
+ (CLAuthorizationStatus)authorizationStatus;


/**
 是否可以定位
 
 @return 允许定位
 */
+ (BOOL)authorizationStatusAllowed;

/**
 开始定位
 */
- (void)startPosition;

/**
 停止定位
 */
- (void)stopPostion;


@end

NS_ASSUME_NONNULL_END
