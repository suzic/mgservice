//
//  SPUserDefaultsManger.h
//  MangroveService
//
//  Created by Sun Peng on 16/1/22.
//  Copyright © 2016年 Sun Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPUserDefaultsManger : NSObject
/**
 *  取出NSUserDefaults的值
 *
 *  @param key key
 */
+ (NSObject *)getValue:(NSString *)key;

/**
 *  存储userDefault
 *
 *  @param value value
 *  @param key   key
 */
+ (void)setValue:(NSObject *)value forKey:(NSString *)key;

+ (void)deleteforKey:(NSString *)key;
/**
 *  将BOOL 存入UserDefault
 *
 *  @param vaule BOOL
 *  @param key   KEY
 */
+ (void)setBool:(BOOL)vaule forKey:(NSString *)key;

/**
 *  取出BOOL值
 *
 *  @param key key
 *
 *  @return BOOL
 */
+ (BOOL)getBool:(NSString *)key;

/**
 *  存储MutableArray
 *
 *  @param value array
 *  @param key   key
 */
+ (void)setMutableDictionary:(NSMutableDictionary *)value keyName:(NSString *)key;

/**
 *  取出MutableArr
 *
 *  @param key key
 *
 *  @return array
 */
+ (NSMutableDictionary *)getMutableDictionary:(NSString *)key;

@end
