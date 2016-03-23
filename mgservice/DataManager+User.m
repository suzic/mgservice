//
//  DataManager+User.m
//  mgservice
//
//  Created by Sun Peng on 16/2/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DataManager+User.h"

@implementation DataManager (User)

// 根据任务编号查找本地是否存在
- (DBTaskList *)findWaiterRushByTaskCode:(NSString *)taskCode
{
    DBTaskList *taskList = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = %@", taskCode];
    NSArray *result = [self arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 ||result == nil)
    {
        taskList = (DBTaskList *)[self insertIntoCoreData:@"DBTaskList"];
        taskList.taskCode = taskCode;
    }else
        taskList = result[0];
    return taskList;
}

// 获取参数表
- (DBWaiterInfor *)getWaiterInfor
{
    DBWaiterInfor *waiterInfo = nil;
    NSArray *result = [self arrayFromCoreData:@"DBWaiterInfor" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count<= 0 || result == nil)
        waiterInfo = (DBWaiterInfor *)[self insertIntoCoreData:@"DBWaiterInfor"];
    else
        waiterInfo = result[0];
    return waiterInfo;
}

@end