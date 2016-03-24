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
    else if ([ident isEqualToString:@URI_WAITER_GETSERVICELIST])
    {
        datas = [self parSeserviceRequestList:dict];
    }
    //存储数据
    [dataManager saveContext];
    NSLog(@"%@",[dataManager getWaiterInfor].attendanceState);
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

#pragma mark - 服务员登录
// 服务员登录
- (NSMutableArray *)parseWaiterLogin:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
   
    [array addObject:dic[@"retOk"]];
    [array addObject:dic[@"message"]];
    
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
    waiterInfo.workNum = dic[@"workNum"];
    waiterInfo.hotelCode = dic[@"hotelCode"];
    waiterInfo.deviceId = dic[@"deviceId"];
    waiterInfo.deviceToken = dic[@"deviceToken"];
    waiterInfo.name = dic[@"name"];
    waiterInfo.gender = dic[@"gender"];
    waiterInfo.birth = dic[@"birth"];
    waiterInfo.nay = dic[@"nav"];
    waiterInfo.idNo = dic[@"idNo"];
    waiterInfo.dutyin = dic[@"dutyIn"];
    waiterInfo.dutyout = dic[@"dutyOut"];
    waiterInfo.dutyLevel = dic[@"dutyLevel"];
    waiterInfo.workStatus = dic[@"workingState"];
    waiterInfo.attendanceState = dic[@"attendanceState"];
    waiterInfo.currentLocation = dic[@"currentLocation"];
    waiterInfo.currentArea = dic[@"currentArea"];
    waiterInfo.incharge = dic[@"incharge"];
    
    return array;
}

- (NSMutableArray *)parSeserviceRequestList:(id)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    NSLog(@"%@",dic);
    
    return array;
}

@end
