//
//	WeatherEntity.m
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "WeatherEntity.h"

@interface WeatherEntity ()
@end
@implementation WeatherEntity




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
		self.city = dictionary[@"city"];
	}	
	if(![dictionary[@"cityid"] isKindOfClass:[NSNull class]]){
		self.cityid = dictionary[@"cityid"];
	}	
	if(dictionary[@"forecast"] != nil && [dictionary[@"forecast"] isKindOfClass:[NSArray class]]){
		NSArray * forecastDictionaries = dictionary[@"forecast"];
		NSMutableArray * forecastItems = [NSMutableArray array];
		for(NSDictionary * forecastDictionary in forecastDictionaries){
			Forecast * forecastItem = [[Forecast alloc] initWithDictionary:forecastDictionary];
			[forecastItems addObject:forecastItem];
		}
		self.forecast = forecastItems;
	}
	if(dictionary[@"history"] != nil && [dictionary[@"history"] isKindOfClass:[NSArray class]]){
		NSArray * historyDictionaries = dictionary[@"history"];
		NSMutableArray * historyItems = [NSMutableArray array];
		for(NSDictionary * historyDictionary in historyDictionaries){
			History * historyItem = [[History alloc] initWithDictionary:historyDictionary];
			[historyItems addObject:historyItem];
		}
		self.history = historyItems;
	}
	if(![dictionary[@"today"] isKindOfClass:[NSNull class]]){
		self.today = [[Today alloc] initWithDictionary:dictionary[@"today"]];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.city != nil){
		dictionary[@"city"] = self.city;
	}
	if(self.cityid != nil){
		dictionary[@"cityid"] = self.cityid;
	}
	if(self.forecast != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(Forecast * forecastElement in self.forecast){
			[dictionaryElements addObject:[forecastElement toDictionary]];
		}
		dictionary[@"forecast"] = dictionaryElements;
	}
	if(self.history != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(History * historyElement in self.history){
			[dictionaryElements addObject:[historyElement toDictionary]];
		}
		dictionary[@"history"] = dictionaryElements;
	}
	if(self.today != nil){
		dictionary[@"today"] = [self.today toDictionary];
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:@"city"];
	}
	if(self.cityid != nil){
		[aCoder encodeObject:self.cityid forKey:@"cityid"];
	}
	if(self.forecast != nil){
		[aCoder encodeObject:self.forecast forKey:@"forecast"];
	}
	if(self.history != nil){
		[aCoder encodeObject:self.history forKey:@"history"];
	}
	if(self.today != nil){
		[aCoder encodeObject:self.today forKey:@"today"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.city = [aDecoder decodeObjectForKey:@"city"];
	self.cityid = [aDecoder decodeObjectForKey:@"cityid"];
	self.forecast = [aDecoder decodeObjectForKey:@"forecast"];
	self.history = [aDecoder decodeObjectForKey:@"history"];
	self.today = [aDecoder decodeObjectForKey:@"today"];
	return self;

}
@end