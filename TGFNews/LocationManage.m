//
//  LocationManage.m
//  MVVMDemo
//
//  Created by 谭高丰 on 15/12/29.
//  Copyright © 2015年 谭高丰. All rights reserved.
//

#import "LocationManage.h"


@interface LocationManage () <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    LocationSuccess success;
    LocationFailure failure;
}

@end
@implementation LocationManage

+ (instancetype)sharedManage
{
    static LocationManage *locationManage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManage = [[LocationManage alloc] init];
    });
    return locationManage;
}

//定位
- (void)starLocationSuccess:(LocationSuccess)locSuccess Failure:(LocationFailure)locFailure {
    
    success = locSuccess;
    failure = locFailure;
    
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10.f;
        [locationManager requestAlwaysAuthorization]; //添加这句
        [locationManager startUpdatingLocation];
    }
    else {
        //提示用户无法进行定位操作
        failure(@"定位不成功 ,请确认开启定位");
    }
}

//结束定位
- (void)stopLocation {
    success = nil;
    failure = nil;
    [locationManager stopUpdatingLocation];
}

//定位成功会回调
#pragma mark -CLLocationManagerDelegate *******定位代理经纬度回调
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    [locationManager stopUpdatingLocation];
    NSLog(@"====didUpdateLocations=======");
    CLLocation* currLocation = [locations lastObject];
    if (currLocation.coordinate.longitude != 0 && currLocation.coordinate.latitude != 0) {
        // 初始化一个反向地理编码对象
        CLGeocoder* myGeocoder = [[CLGeocoder alloc] init];
        // 根据给定的经纬度来得到相应的地址信息
        [myGeocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray* placemarks, NSError* error) {
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark* placemark = [placemarks objectAtIndex:0];
                success(placemark);
            }
        }];
    }
}

//定位失败
- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSLog(@"====didFailWithError=======");
    if (error.code != 1) {
        failure(@"定位失败！");
    }
    [locationManager stopUpdatingLocation];
}

@end
