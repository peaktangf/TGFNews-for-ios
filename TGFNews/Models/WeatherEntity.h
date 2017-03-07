//
//	WeatherEntity.h
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "Forecast.h"
#import "History.h"
#import "Today.h"

@interface WeatherEntity : NSObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * cityid;
@property (nonatomic, strong) NSArray * forecast;
@property (nonatomic, strong) NSArray * history;
@property (nonatomic, strong) Today * today;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end