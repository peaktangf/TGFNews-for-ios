//
//	Index.m
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Index.h"

@interface Index ()
@end
@implementation Index




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"code"] isKindOfClass:[NSNull class]]){
		self.code = dictionary[@"code"];
	}	
	if(![dictionary[@"details"] isKindOfClass:[NSNull class]]){
		self.details = dictionary[@"details"];
	}	
	if(![dictionary[@"index"] isKindOfClass:[NSNull class]]){
		self.index = dictionary[@"index"];
	}	
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"otherName"] isKindOfClass:[NSNull class]]){
		self.otherName = dictionary[@"otherName"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.code != nil){
		dictionary[@"code"] = self.code;
	}
	if(self.details != nil){
		dictionary[@"details"] = self.details;
	}
	if(self.index != nil){
		dictionary[@"index"] = self.index;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.otherName != nil){
		dictionary[@"otherName"] = self.otherName;
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
	if(self.code != nil){
		[aCoder encodeObject:self.code forKey:@"code"];
	}
	if(self.details != nil){
		[aCoder encodeObject:self.details forKey:@"details"];
	}
	if(self.index != nil){
		[aCoder encodeObject:self.index forKey:@"index"];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	if(self.otherName != nil){
		[aCoder encodeObject:self.otherName forKey:@"otherName"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.code = [aDecoder decodeObjectForKey:@"code"];
	self.details = [aDecoder decodeObjectForKey:@"details"];
	self.index = [aDecoder decodeObjectForKey:@"index"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.otherName = [aDecoder decodeObjectForKey:@"otherName"];
	return self;

}
@end