

#import <Foundation/Foundation.h>

@interface NSObject (ObjectCoder)

- (void)setValueWithKey:(NSString *)key;
+ (id)valueByKey:(NSString *)key;

@end

@interface FastCoderManager : NSObject

+ (FastCoderManager *)shareManager;

- (void)setValue:(id)value withKey:(NSString *)key;
- (id)valueWithKey:(NSString *)key;

@end
