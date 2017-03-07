//
//	History.m
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "History.h"

@interface History ()
@end
@implementation History




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"aqi"] isKindOfClass:[NSNull class]]){
		self.aqi = dictionary[@"aqi"];
	}	
	if(![dictionary[@"date"] isKindOfClass:[NSNull class]]){
		self.date = dictionary[@"date"];
	}	
	if(![dictionary[@"fengli"] isKindOfClass:[NSNull class]]){
		self.fengli = dictionary[@"fengli"];
	}	
	if(![dictionary[@"fengxiang"] isKindOfClass:[NSNull class]]){
		self.fengxiang = dictionary[@"fengxiang"];
	}	
	if(![dictionary[@"hightemp"] isKindOfClass:[NSNull class]]){
		self.hightemp = dictionary[@"hightemp"];
	}	
	if(![dictionary[@"lowtemp"] isKindOfClass:[NSNull class]]){
		self.lowtemp = dictionary[@"lowtemp"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	if(![dictionary[@"week"] isKindOfClass:[NSNull class]]){
		self.week = dictionary[@"week"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.aqi != nil){
		dictionary[@"aqi"] = self.aqi;
	}
	if(self.date != nil){
		dictionary[@"date"] = self.date;
	}
	if(self.fengli != nil){
		dictionary[@"fengli"] = self.fengli;
	}
	if(self.fengxiang != nil){
		dictionary[@"fengxiang"] = self.fengxiang;
	}
	if(self.hightemp != nil){
		dictionary[@"hightemp"] = self.hightemp;
	}
	if(self.lowtemp != nil){
		dictionary[@"lowtemp"] = self.lowtemp;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	if(self.week != nil){
		dictionary[@"week"] = self.week;
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
	if(self.aqi != nil){
		[aCoder encodeObject:self.aqi forKey:@"aqi"];
	}
	if(self.date != nil){
		[aCoder encodeObject:self.date forKey:@"date"];
	}
	if(self.fengli != nil){
		[aCoder encodeObject:self.fengli forKey:@"fengli"];
	}
	if(self.fengxiang != nil){
		[aCoder encodeObject:self.fengxiang forKey:@"fengxiang"];
	}
	if(self.hightemp != nil){
		[aCoder encodeObject:self.hightemp forKey:@"hightemp"];
	}
	if(self.lowtemp != nil){
		[aCoder encodeObject:self.lowtemp forKey:@"lowtemp"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}
	if(self.week != nil){
		[aCoder encodeObject:self.week forKey:@"week"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.aqi = [aDecoder decodeObjectForKey:@"aqi"];
	self.date = [aDecoder decodeObjectForKey:@"date"];
	self.fengli = [aDecoder decodeObjectForKey:@"fengli"];
	self.fengxiang = [aDecoder decodeObjectForKey:@"fengxiang"];
	self.hightemp = [aDecoder decodeObjectForKey:@"hightemp"];
	self.lowtemp = [aDecoder decodeObjectForKey:@"lowtemp"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	self.week = [aDecoder decodeObjectForKey:@"week"];
	return self;

}
@end