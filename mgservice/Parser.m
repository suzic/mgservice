/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description:网络数据解析
 */

#import "Parser.h"
#import "DataManager.h"

@implementation Parser


/*************************************************
 Function:       // parser
 Description:    // 解析方法
 Input:          // ident 接口标示 dict 要解析的数据
 Return:         //
 Others:         //
 *************************************************/
- (NSMutableArray*)parser:(NSString *)ident fromData:(NSData *)dict
{
    
    DataManager* dataManager = [DataManager defaultInstance];
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    
    if ([ident isEqualToString:@URI_MESSAGE_BASETIME]) //获取后台时间
    {
        datas = [self parseAllMessageTimeData:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_CHECKSTATUS]) //获取服务员状态
    {
        datas = [self parseWaiterinfo:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_ISWORK]) // 设置服务员上下班状态
    {
        datas = [self parseWaiterIsWork:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_WORKSTATUS]) // 设置服务员工作状态
    {
        datas = [self parseWaiterWorkStatus:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_LOGIN])  // 服务员登录
    {
        datas = [self parseWaiterLogin:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_LOGOUT])  // 服务员登出
    {
        datas = [self parseWaiterLogout:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_CHECKINFO])  // 获取服务员信息
    {
        datas = [self parseWaiterInfoSelect:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_GETSERVICELIST]) // 服务员获取订单列表
    {
        datas = [self parSeserviceRequestList:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_RUSHTASK]) // 服务员抢单
    {
        datas = [self parseWaiterGetIndent:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_FINISHTASK])  // 服务员提交完成订单
    {
        datas = [self parseWaiterFinishTask:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_CANCELORDER])   //服务员取消订单
    {
        datas = [self parseWaiterCancelTask:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_REPASTORDERS]) // 获取菜单详情
    {
        datas = [self parseMenuDetailList:dict];
    }
    else if ([ident isEqualToString:@URL_ACHIEVE_USERID]) //登录IM
    {
        datas = [self parseReloadIM:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_TASkSTATUS]) //通过任务号，获取统计信息
    {
        datas = [self parseWaiterStatisticalInfoTaskStatus:dict];
    }
    else if ([ident isEqualToString:@URI_WAITER_TASkSTATUS]) //通过任务号，获得任务信息
    {
        datas = [self parseWaiterTaskStatus:dict];
    }
//    else if ([ident isEqualToString:@URL_TASKSTATISTICAL]) //服务员任务统计
//    {
//        datas = [self parseTaskStatistical:dict];
//    }
    else if ([ident isEqualToString:@URL_TASKLIST]) //根据条件查询任务列表
    {
        datas = [self parseTaskList:dict];
    }
    else if ([ident isEqualToString:@URL_TASKACTIVATE]) //获取正在进行中的任务
    {
        datas = [self parseTaskActivate:dict];
    }
    //存储数据
    [dataManager saveContext];
    return datas;
}

#pragma mark - 时间获取
// 获取后台时间
- (NSMutableArray *)parseAllMessageTimeData:(id)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    [array addObject:dic[@"sysDateTime"]];
    
    return array;
    
}

#pragma mark - 服务员状态获取
// 获取服务员状态
- (NSMutableArray *)parseWaiterinfo:(id)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    
    DBWaiterInfor *waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance] getWaiterInfor];

    waiterInfo.workStatus = dic[@"workingState"];
    waiterInfo.attendanceState = dic[@"attendanceState"];
    
    [array addObject:waiterInfo];
    
    return array;
}

#pragma mark - 服务员状态设置
// 设置服务员上下班状态
- (NSMutableArray *)parseWaiterIsWork:(id)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    
    DBWaiterInfor *waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance] getWaiterInfor];
    
    waiterInfo.attendanceState = dic[@"attendanceState"];
    
    [array addObject:dic[@"retOk"]];
    
    [array addObject:waiterInfo];
    
    return array;
}

#pragma mark - 服务员工作状态设置
// 服务员工作状态设置
- (NSMutableArray *)parseWaiterWorkStatus:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    DBWaiterInfor *waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance] getWaiterInfor];
    waiterInfo.workStatus = dic[@"workingState"];
    [array addObject:dic[@"retOk"]];
    return array;
}

#pragma mark - 服务员登录
// 服务员登录
- (NSMutableArray *)parseWaiterLogin:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
   
    [array addObject:dic[@"retOk"]];
    [array addObject:dic[@"message"]];
    [array addObject:dic[@"waiterId"]];
    DBWaiterInfor * waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance] getWaiterInfor];
    waiterInfo.waiterId = dic[@"waiterId"];
    [array addObject:waiterInfo];
    return array;
}

#pragma mark - 服务员登出
// 服务员登出
- (NSMutableArray *)parseWaiterLogout:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    [array addObject:dic[@"retOk"]];
    [array addObject:dic[@"message"]];
    
    return array;
}

#pragma mark - 服务员信息查询
// 服务员信息查询
- (NSMutableArray *)parseWaiterInfoSelect:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    DBWaiterInfor * waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance]getWaiterInfor];
    waiterInfo.workNum =            dic[@"workNum"];
    waiterInfo.hotelCode =          dic[@"hotelCode"];
    waiterInfo.deviceId =           dic[@"deviceId"];
    waiterInfo.deviceToken =        dic[@"deviceToken"];
    waiterInfo.name =               dic[@"name"];
    waiterInfo.gender =             dic[@"gender"];
    waiterInfo.birth =              dic[@"birth"];
    waiterInfo.nay =                dic[@"nav"];
    waiterInfo.idNo =               dic[@"idNo"];
    waiterInfo.dutyin =             dic[@"dutyIn"];
    waiterInfo.dutyout =            dic[@"dutyOut"];
    waiterInfo.dutyLevel =          dic[@"dutyLevel"];
    waiterInfo.workStatus =         dic[@"workingState"];
    waiterInfo.attendanceState =    dic[@"attendanceState"];
    waiterInfo.currentLocation =    dic[@"currentLocation"];
    waiterInfo.currentArea =        dic[@"currentArea"];
    waiterInfo.incharge =           dic[@"incharge"];
    
    [array addObject:waiterInfo];
    return array;
}

#pragma mark - 服务员获取订单列表
// 服务员获取订单列表
- (NSMutableArray *)parSeserviceRequestList:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = 0"];
//    NSArray * listArray = [[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    for (NSDictionary * taskDic in dic[@"list"]) {
        DBTaskList * taskList = (DBTaskList *)[[DataManager defaultInstance]insertIntoCoreData:@"DBTaskList"];
        taskList.taskCode =             taskDic[@"taskCode"];
        taskList.userDiviceld =         taskDic[@"diviceId"];
        taskList.userDeviceToken =      taskDic[@"deviceToken"];
        taskList.phone =                taskDic[@"Phone"];
        taskList.userLocation =         taskDic[@"location"];
        taskList.userLocationDesc =     taskDic[@"locationDesc"];
        taskList.userLocationArea =     taskDic[@"locationArea"];
        taskList.timeLimit =            taskDic[@"timeLimit"];
        taskList.priority =             taskDic[@"priority"];
        taskList.patternInfo =          taskDic[@"patternInfo"];
        taskList.category =             taskDic[@"category"];
        taskList.userMessageInfo =      taskDic[@"messageInfo"];
        taskList.drOrderNo =            taskDic[@"drOrderNo"];

        [array addObject:taskList];
    }
    
    return array;
}

#pragma mark - 服务员抢单
// 服务员抢单
- (NSMutableArray *)parseWaiterGetIndent:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = %@", dic[@"taskInfo"][@"taskCode"]];
    DBTaskList * waiterTask  = (DBTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil]lastObject];
    waiterTask.taskCode =             dic[@"taskInfo"][@"taskCode"];
    waiterTask.userDiviceld =         dic[@"taskInfo"][@"diviceId"];
    waiterTask.userDeviceToken =      dic[@"taskInfo"][@"deviceToken"];
    waiterTask.phone =                dic[@"taskInfo"][@"Phone"];
    waiterTask.userLocation =         dic[@"taskInfo"][@"location"];
    waiterTask.userLocationDesc =     dic[@"taskInfo"][@"locationDesc"];
    waiterTask.userLocationArea =     dic[@"taskInfo"][@"locationArea"];
    waiterTask.timeLimit =            dic[@"taskInfo"][@"timeLimit"];
    waiterTask.priority =             dic[@"taskInfo"][@"priority"];
    waiterTask.patternInfo =          dic[@"taskInfo"][@"patternInfo"];
    waiterTask.category =             dic[@"taskInfo"][@"category"];
    waiterTask.userMessageInfo =      dic[@"taskInfo"][@"messageInfo"];
    waiterTask.drOrderNo =            dic[@"taskInfo"][@"drOrderNo"];
    waiterTask.accepTime =            dic[@"progreeInfo"][@"acceptTime"];
    waiterTask.finishTime =           dic[@"progreeInfo"][@"finishTime"];
    waiterTask.cancelTime =           dic[@"cancelTime"];
    waiterTask.status =               dic[@"status"];
    [SPUserDefaultsManger setValue:waiterTask.taskCode forKey:@"taskCode"];
    [array addObject:waiterTask];
    [array addObject:dic];
    return array;
}

#pragma mark - 服务员提交完成
// 服务员提交完成
- (NSMutableArray *)parseWaiterFinishTask:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = %@", dic[@"taskInfo"][@"taskCode"]];
    NSArray *result = [[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
//    NSArray *result1 = [[DataManager defaultInstance] arrayFromCoreData:@"DBStatisticalInfoList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 || result == nil)
    {
        return nil;
    }
    else
    {
        for (DBTaskList * waiterTask in result) {
            waiterTask.status = dic[@"status"];
            waiterTask.createTime =
            waiterTask.finishTime = dic[@"progreeInfo"][@"finishTime"];
            waiterTask.accepTime = dic[@"progreeInfo"][@"acceptTime"];
            [array addObject:waiterTask];
        }
//        for (DBStatisticalInfoList * statisticalInfo in result1)
//        {
//            statisticalInfo.finishTime = dic[@"progreeInfo"][@"finishTime"];
//            [array addObject:statisticalInfo];
//        }
    }
    return array;
}

#pragma mark - 服务员取消订单
- (NSMutableArray *)parseWaiterCancelTask:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = %@", dic[@"taskInfo"][@"taskCode"]];
    NSArray *result = [[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 || result == nil)
    {
        return nil;
    }
    else
    {
        for (DBTaskList * waiterTask in result) {
            waiterTask.status = dic[@"status"];
            waiterTask.cancelTime = dic[@"cancelTime"];
            waiterTask.accepTime = dic[@"progreeInfo"][@"acceptTime"];
            [array addObject:waiterTask];
        }
    }
    return array;
}

//通过任务号，查询任务信息,如果taskStatus = @"9",那么证明客人已经取消订单
- (NSMutableArray *)parseWaiterTaskStatus:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
//    DBTaskList * waiterTask = [[[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil]lastObject];
    DBTaskList * waiterTask = (DBTaskList *)[[DataManager defaultInstance]insertIntoCoreData:@"DBTaskList"];
    waiterTask.taskStatus = [NSString stringWithFormat:@"%ld",[dic[@"status"] integerValue]];
    waiterTask.timeLimit = dic[@"taskInfo"][@"timeLimit"];      //要求完成时间(在送餐任务里提现)
    waiterTask.messageInfo = dic[@"taskInfo"][@"messageInfo"];
    waiterTask.createTime = dic[@"progressInfo"][@"createTime"];//创建时间
    waiterTask.finishTime = dic[@"progressInfo"][@"finishTime"];//任务完成时间
    waiterTask.accepTime = dic[@"progressInfo"][@"acceptTime"]; //任务领取时间
    [array addObject:waiterTask];
    return array;
}

//通过任务编号，插入统计信息
- (NSMutableArray *)parseWaiterStatisticalInfoTaskStatus:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    DBStatisticalInfoList * statisticalInfo = (DBStatisticalInfoList *)[[DataManager defaultInstance] insertIntoCoreData:@"DBStatisticalInfoList"];
    statisticalInfo.taskStatus = [NSString stringWithFormat:@"%ld",[dic[@"status"] integerValue]];
    statisticalInfo.timeLimit = dic[@"taskInfo"][@"timeLimit"];      //要求完成时间(在送餐任务里体现)
    statisticalInfo.messageInfo = dic[@"taskInfo"][@"messageInfo"];
    statisticalInfo.taskCode =    dic[@"taskInfo"][@"taskCode"];
    statisticalInfo.category =    dic[@"taskInfo"][@"category"];
    statisticalInfo.createTime = dic[@"progressInfo"][@"createTime"];//创建时间
    statisticalInfo.finishTime = dic[@"progressInfo"][@"finishTime"];//任务完成时间
    statisticalInfo.acceptTime = dic[@"progressInfo"][@"acceptTime"]; //任务领取时间
    statisticalInfo.cancelTime = dic[@"cancelTime"];                    //任务取消时间
    NSLog(@"%@",statisticalInfo.cancelTime);
    [array addObject:statisticalInfo];
    return array;
}

#pragma mark - 获取菜单列表
// 获取菜单列表
- (NSMutableArray *)parseMenuDetailList:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    NSLog(@"%@",dic);
    for (NSDictionary * list in dic[@"list"][0][@"menuList"]) {
        DBWaiterPresentList * presentList = (DBWaiterPresentList *)[[DataManager defaultInstance]insertIntoCoreData:@"DBWaiterPresentList"];
        presentList.count = list[@"count"];
        presentList.drName = list[@"drName"];
        presentList.menuName = list[@"menuName"];
        presentList.sellPrice = list[@"sellPrice"];//单价
        presentList.orderNo = dic[@"list"][0][@"orderNo"];
        presentList.menuOrderMoney = dic[@"list"][0][@"menuOrderMoney"];//菜单总价（未计服务费的）
        presentList.targetTelephone = dic[@"list"][0][@"targetInfo"][@"targetTelephone"];
        presentList.deliverStartTime = dic[@"list"][0][@"targetInfo"][@"deliverStartTime"];//要求送达的 起始时间
        presentList.deliverEndTime = dic[@"list"][0][@"targetInfo"][@"deliverEndTime"];    //要求送达的 结束时间
        presentList.ready = @"0";
        [array addObject:presentList];
    }
    return array;
}

#pragma mark - 获取IM userid
- (NSMutableArray *)parseReloadIM:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    DBTaskList * waiterTask = (DBTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil]lastObject];
    if (waiterTask.hasMessage == nil) {
        DBMessage * message = (DBMessage *)[[DataManager defaultInstance]insertIntoCoreData:@"DBMessage"];
        message.cAppkey = dic[@"cAppkey"];
        message.cUserId = dic[@"cUserId"];
        message.wUserId = dic[@"wUserId"];
        waiterTask.hasMessage = message;
    }
    [array addObject:waiterTask];
    return array;
}

//#pragma mark - 任务统计
//- (NSMutableArray *)parseTaskStatistical:(id)dict
//{
//    NSMutableArray * array = [NSMutableArray array];
//    NSDictionary * dic = (NSDictionary *)dict;
//    for (NSDictionary * list in dic[@"list"]) {
//        DBStatisticalList * statistical = (DBStatisticalList *)[[DataManager defaultInstance] insertIntoCoreData:@"DBStatisticalList"];
//        statistical.messageInfo = list[@"messageInfo"];
//        statistical.taskCode = list[@"taskCode"];
//        statistical.selectedState = @"0";
//        statistical.category = list[@"category"];
//        statistical.score =  list[@"score"];
//        [array addObject:statistical];
//    }
//    return array;
//}

#pragma mark - 根据条件查询任务列表
- (NSMutableArray *)parseTaskList:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    for (NSDictionary * list in dic[@"list"])
    {
        DBTaskStatisticalList * taskStatisticalList = (DBTaskStatisticalList *)[[DataManager defaultInstance] insertIntoCoreData:@"DBTaskStatisticalList"];
        taskStatisticalList.taskCode = list[@"taskCode"];
        taskStatisticalList.locationDesc = list[@"locationDesc"];
        taskStatisticalList.locationArea = list[@"locationArea"];
        taskStatisticalList.timeLimit = list[@"timeLimit"];//邀请完成时间
        taskStatisticalList.category = list[@"category"];
        taskStatisticalList.drOrderNo = list[@"drOrderNo"];
        taskStatisticalList.messageInfo = list[@"messageInfo"];
        taskStatisticalList.selectedState = @"0";
        taskStatisticalList.finishTime = list[@"finishTime"];
        taskStatisticalList.acceptTime = list[@"acceptTime"];
        taskStatisticalList.cancelTime = list[@"cancelTime"];
        taskStatisticalList.score = list[@"score"];
        taskStatisticalList.createTime = list[@"createTime"];
        [array addObject:taskStatisticalList];
    }
    return array;
}

#pragma mark - 服务员获取正在执行中的任务
- (NSMutableArray *)parseTaskActivate:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    DBWaiterInfor * waiterInfo = (DBWaiterInfor *)[[DataManager defaultInstance]getWaiterInfor];
    waiterInfo.status = dic[@"status"];
    waiterInfo.taskCode = dic[@"taskInfo"][@"taskCode"];
    [SPUserDefaultsManger setValue:waiterInfo.taskCode forKey:@"taskCode"];
    NSLog(@"%@",waiterInfo.status);
    
    return array;
}

@end
