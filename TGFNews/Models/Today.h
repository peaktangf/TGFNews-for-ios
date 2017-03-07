//
//	Today.h
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "Index.h"

@interface Today : NSObject

@property (nonatomic, strong) NSString * aqi;
@property (nonatomic, strong) NSString * curTemp;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * fengli;
@property (nonatomic, strong) NSString * fengxiang;
@property (nonatomic, strong) NSString * hightemp;
@property (nonatomic, strong) NSArray * index;
@property (nonatomic, strong) NSString * lowtemp;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * week;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end