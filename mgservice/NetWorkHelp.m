//
//  NetWorkHelp.m
//  mgmanager
//
//  Created by 刘超 on 15/5/15.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "NetWorkHelp.h"

@implementation NetWorkHelp

- (BOOL)ComparingNetworkRequestTime:(NSString *)ident ByUser:(BOOL)byUser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        
    }
    else
    {
        //如果没有plist文件就自动创建
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
        //写入文件
        [dictplist writeToFile:plistPath atomically:YES];
    }
    
    BOOL refresh = YES;
    
    return refresh;

}

//获取时间差
/**
 * @param 1 超过一天活着主动刷新，2 超过十分钟小于一个小时，3 其他
 */
- (NSString *) detailDateStrFromDate:(NSDate *) date withByUser:(BOOL)byUser
{
    //现在时间
    NSDate *currentDate = [NSDate date];
    
    double seconds = [currentDate timeIntervalSinceDate:date];
    double minutes = seconds/60;
    double hours = minutes/60;
    double days = hours/24;
    
    if (byUser == NO)
    {
        if (date == nil || days >= 1 )
        {
            return @"1";
        }
    }
    
    if (byUser == YES)
    {
        return @"1";
    }

    if (minutes < 10)
    {
        return @"3";
    }
    if (minutes >= 10 && hours < 1)
    {
        return @"2";
    }
    if (days >= 1)
    {
        return @"1";
    }
    
    return @"3";
    
}

@end
