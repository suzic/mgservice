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
    
//    if([ident isEqualToString:@URI_CHECKUKEY])//验证验证码
//    {
//        datas =  [self parserVerificationCode:dict];
//    }
    
    //存储数据
    [dataManager saveContext];
    return datas;
}


@end
