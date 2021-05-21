//
//  HYLocationTool.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import "HYLocationTool.h"
#import <UIKit/UIKit.h>
#import "HYUserDefaultTool.h"

#define AD_SECRET_KEY        180150000

@interface HYLocationTool ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL updatingLocation;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *country;

@end

@implementation HYLocationTool

+ (instancetype)sharedManager
{
    static HYLocationTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYLocationTool alloc] init];
        [instance loadLocation];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.distanceFilter = 300;
        _refreshLocationInterval = 0;
    }
    return self;
}

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)authorizationStatusAllowed{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    }else{
        return NO;
    }
    return NO;
}

+ (CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

- (void)startPosition
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    self.updatingLocation = NO;
    [self.locationManager startUpdatingLocation];
    if (_refreshLocationInterval > 0) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshLocationInterval target:self selector:@selector(startUploadLocationTimer:) userInfo:nil repeats:YES];
    }
    
}

- (void)setDistanceFilter:(NSInteger)distanceFilter
{
    _distanceFilter = distanceFilter;
    self.locationManager.distanceFilter = distanceFilter;
}

- (void)stopPostion
{
    [self.locationManager stopUpdatingLocation];
    [_timer invalidate];
}

- (void)startUploadLocationTimer:(NSTimer*)timer
{
    self.updatingLocation = NO;
    [self.locationManager startUpdatingLocation];
}

//混淆坐标 ifneed
- (NSString *)locationData
{
    CLLocation *location = [self currentLocation];
    
    NSString *strLong = [NSString stringWithFormat:@"%f",location.coordinate.longitude];//经度
    NSString *strLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];//纬度
    
    NSArray *arrLon = [strLong componentsSeparatedByString:@"."];
    
    int longFisrt = 0;
    int longSecond = 0;
    
    if ([arrLon count] > 1)
    {
        longFisrt = [[arrLon objectAtIndex:0] intValue];
        
        longFisrt = longFisrt^AD_SECRET_KEY;
        
        longSecond = [[arrLon objectAtIndex:1] intValue];
        
        longSecond = longSecond^AD_SECRET_KEY;
        
        strLong = [NSString stringWithFormat:@"%d.%d",longFisrt,longSecond];
    }
    
    NSArray *arrLat = [strLat componentsSeparatedByString:@"."];
    
    int latFisrt = 0;
    int latSecond = 0;
    
    if ([arrLat count] > 1)
    {
        latFisrt = [[arrLat objectAtIndex:0] intValue];
        
        latFisrt = latFisrt^AD_SECRET_KEY;
        
        latSecond = [[arrLat objectAtIndex:1] intValue];
        
        latSecond = latSecond^AD_SECRET_KEY;
        
        strLat = [NSString stringWithFormat:@"%d.%d",latFisrt,latSecond];
    }
    
    return [NSString stringWithFormat:@"%@_%@",strLong,strLat];
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
    if (self.updatingLocation == YES) {
        return;
    }
    self.currentLocation = [locations lastObject];
    self.updatingLocation = YES;
//    NSLog(@"定位成功-->%@",[NSString stringWithFormat:@"经度:%f,纬度:%f", _currentLocation.coordinate.longitude, _currentLocation.coordinate.latitude]);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
//         BOOL isFirstUpdateLocation = NO;
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             //获取城市
             NSString *city = placemark.locality;
             
             self.province = placemark.administrativeArea;
             
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             if (!self.province) {
                 //18.8.10号修改，获取北京定位时administrativeArea属性为nil locality为北京市，与之前注释不符
                 self.province = placemark.locality;
             }
             //广告需求传‘北京’，非‘北京市’
             self.province = [self.province stringByReplacingOccurrencesOfString:@"省" withString:@""];
             self.province = [self.province stringByReplacingOccurrencesOfString:@"市" withString:@""];
             self.address = city;
             
             self.country = placemark.country;
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:HYUpdateLocationSuccess_Notification object:nil];

         [self saveLoaction];
     }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    if (self.updatingLocation == YES) {
        return;
    }
    self.updatingLocation = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HYUpdateLocationFailed_Notification object:error];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:HYUpdateLocationAuthorizationStatus_Notification object:self userInfo:@{HYUpdateLocationAuthorizationStatusKey: @(status)}];
}

#pragma mark 本地记录定位信息
- (void)saveLoaction
{
    [HYUserDefaultTool addObject:self.province forKey:@"kHYLocationProvince"];
    [HYUserDefaultTool addObject:self.address forKey:@"kHYLocationAddress"];
    [HYUserDefaultTool addObject:self.country forKey:@"kHYLocationCountry"];
}

- (void)loadLocation
{
    self.province = (NSString *)[HYUserDefaultTool getObjectFor:@"kHYLocationProvince"];
    self.address = (NSString *)[HYUserDefaultTool getObjectFor:@"kHYLocationAddress"];
    self.country = (NSString *)[HYUserDefaultTool getObjectFor:@"kHYLocationCountry"];
}

@end


NSString *const HYUpdateLocationSuccess_Notification = @"HYUpdateLocationSuccess_Notification";
NSString *const HYUpdateLocationFailed_Notification = @"HYUpdateLocationFailed_Notification";
NSString *const HYUpdateLocationAuthorizationStatus_Notification = @"HYUpdateLocationAuthorizationStatus_Notification";
NSString *const HYUpdateLocationAuthorizationStatusKey = @"HYUpdateLocationAuthorizationStatusKey";
