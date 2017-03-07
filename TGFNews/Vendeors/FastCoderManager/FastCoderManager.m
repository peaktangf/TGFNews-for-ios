
#import "FastCoderManager.h"
#import <FastCoder.h>

@implementation NSObject (ObjectCoder)

- (void)setValueWithKey:(NSString *)key {
    [[FastCoderManager shareManager] setValue:self withKey:key];
}

+ (id)valueByKey:(NSString *)key {
    return [[FastCoderManager shareManager] valueWithKey:key];
}

@end

@implementation FastCoderManager

+ (FastCoderManager *)shareManager {
    static FastCoderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FastCoderManager alloc] init];
    });
    return manager;
}

- (void)setValue:(id)value withKey:(NSString *)key {
    
    NSParameterAssert(value);
    NSParameterAssert(key);
    NSData *data = [FastCoder dataWithRootObject:value];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (id)valueWithKey:(NSString *)key {
    
    NSParameterAssert(key);
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return [FastCoder objectWithData:data];
}
@end
