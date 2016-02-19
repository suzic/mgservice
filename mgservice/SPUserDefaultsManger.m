//
//  SPUserDefaultsManger.m
//  MangroveService
//
//  Created by Sun Peng on 16/1/22.
//  Copyright © 2016年 Sun Peng. All rights reserved.
//

#import "SPUserDefaultsManger.h"

@implementation SPUserDefaultsManger

/**
 *  NSuserDefaults 能存储: NSNumber NSArray  NSdata NSString NSdate  不能存储自定义的对象(数组里包括也不行),自定义对象需实现<NSCoding>
 *  转Data
 */

+ (NSObject *)getValue:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:key];
}


+ (void)setValue:(NSObject *)value forKey:(NSString *)key
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    
    [defaluts setObject:value forKey:key];
    
    [defaluts synchronize];
    
}

+ (void)setBool:(BOOL)vaule forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:vaule forKey:key];
    
    [defaults synchronize];
    
}

+ (BOOL)getBool:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults boolForKey:key];
    
}

+ (void)setMutableDictionary:(NSMutableDictionary *)value keyName:(NSString *)key{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:data forKey:key];
}

+ (NSMutableDictionary *)getMutableDictionary:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    
    NSMutableDictionary *dic = [(NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (dic == nil) {
        dic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return dic;
}

@end
