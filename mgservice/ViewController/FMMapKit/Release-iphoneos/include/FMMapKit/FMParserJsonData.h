//
// Created by fengmap on 16/9/18.
// Copyright (c) 2016 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMParserJsonData : NSObject

+ (NSBundle *)getFMBundel;
+ (NSArray *)parserActs;
+ (NSArray *)parserIndoorMapInfos;
+ (NSArray *)parseGPSIgnoreData;
+ (NSArray *)parseWifiIgnoreData;
+ (NSArray *)parseLocationBorder;//解析定位边界数据
@end
