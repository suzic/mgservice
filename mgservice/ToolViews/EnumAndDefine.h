//
//  EnumAndDefine.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 16/4/26.
//  Copyright © 2016年 palmaplus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, searchType) {
    searchRightBarButton=0,
    searchStart,
    searchEnd,
    searchNone,
};
#define ratioX(x) ([UIScreen mainScreen].bounds.size.width/320.0 )* x
#define ratioY(y) ([UIScreen mainScreen].bounds.size.height/568.0 )* y
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define FitCGRectMake(x , y , z , w )  CGRectMake(kScreenWidth*((x)/320.0), kScreenWidth*((y)/320.0), kScreenWidth*((z)/320.0), kScreenWidth*((w)/320.0))
#define ButtonHeight 44
#define rgba(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

@interface EnumAndDefine : NSObject

@end


