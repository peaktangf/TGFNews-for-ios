//
//  LocationManage.h
//  MVVMDemo
//
//  Created by 谭高丰 on 15/12/29.
//  Copyright © 2015年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATIONMANAGER [LocationManage sharedManage]

typedef void (^LocationSuccess)(CLPlacemark *locationInfo);
typedef void (^LocationFailure)(NSString *failureMessage);

@interface LocationManage : NSObject

+ (instancetype)sharedManage;

/**
 *  开始定位
 *
 *  @param locSuccess 成功回调
 *  @param locFailure 失败回调
 */
- (void)starLocationSuccess:(LocationSuccess)locSuccess Failure:(LocationFailure)locFailure;

/**
 *  结束定位
 */
- (void)stopLocation;

@end
