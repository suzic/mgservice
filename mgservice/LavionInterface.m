
//
//  LavionInterface.m
//  mgmanager
//
//  Created by 苏智 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "LavionInterface.h"
#import "NetWorkHelp.h"
#import "SHLoadingView.h"
@implementation LavionInterface
{
    SHLoadingView *loadingView;
}

@synthesize delegate;
@synthesize viewIdent;

// 封装http请求头 发起网络请求 json格式
- (void)getContent:(NSMutableDictionary*)params
         withUrlId:(NSString*)viewid
      withUrlRhead:(NSString*)rhead
        withByUser:(BOOL)byUser
{
    //网络加载符号的格式
    loadingView = [SHLoadingView loadingView];
    [loadingView showSynchronous];
    NetWorkHelp *netWorkHelp = [[NetWorkHelp alloc] init];
    
    // 判断查询间隔是否满足足够长的状态（当byUser为NO时，间隔不够时将不发送实际请求）
    BOOL sendNetWork = [netWorkHelp ComparingNetworkRequestTime:viewid ByUser:byUser];
    if (sendNetWork == NO)
    {
        if (loadingView.window)
            [loadingView disapper];
        return;
    }
    else
    {
        [loadingView showSynchronous];
        NSTimeInterval timestamp = [Util timestamp];
        requestType = @"local";
        
        // 如果用户已经登录，先获取好登录信息
        NSString* tokenid = @"";
        BOOL isLogIn = [[DataManager defaultInstance] findUserLogIn];
        if (isLogIn == YES )
        {
            DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
            tokenid = userLogin.ticker;
        }

        NSMutableDictionary* header = [[NSMutableDictionary alloc]init];
        [header setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
        [header setObject:tokenid forKey:@"mymhotel-ticket"];
        [header setObject:@"1002" forKey:@"mymhotel-type"];
        [header setObject:@"4.0" forKey:@"mymhotel-version"];
        [header setObject:@"JSON" forKey:@"mymhotel-dataType"];
        [header setObject:@"JSON" forKey:@"mymhotel-ackDataType"];
        [header setObject:[Util getMacAdd] forKey:@"mymhotel-sourceCode"];
        [header setObject:[NSString stringWithFormat:@"%f",timestamp] forKey:@"mymhotel-dateTime"];
        [header setObject:@"no-cache" forKey:@"Pragma"];
        [header setObject:@"no-cache" forKey:@"Cache-Control"];
        [self setHeaders:header];
        [self setViewIdent:viewid];
        NSInteger severIndex = [Util SelectTheServerUrl];
        switch (severIndex)
        {
            case 1:
                self.interfaceURL = [[rhead stringByAppendingString:([MySingleton sharedSingleton].testUrl)]
                                     stringByAppendingString:viewIdent];

                break;
            case 2:
                self.interfaceURL = [[rhead stringByAppendingString:([MySingleton sharedSingleton].interTestUrl)]
                                     stringByAppendingString:viewIdent];

                
                break;
            case 0:
            default:
                self.interfaceURL = [[rhead stringByAppendingString:([MySingleton sharedSingleton].baseInterfaceUrl)]
                                     stringByAppendingString:viewIdent];
                break;
        }
        self.baseDelegate = self;
        [self connect_json:params];
        
        if(![self.viewIdent isEqualToString:@URI_LOGIN] && ![self.viewIdent isEqualToString:@URI_REGIST])
        {
            bakParams = params;
            bakRhead = rhead;
            bakHead = header;
            bakUrl = self.interfaceURL;
            bakViewIdent = self.viewIdent;
        }
    }
}

// 刷新请求
- (void)refurbish
{
    [self setHeaders:bakHead];
    self.interfaceURL = bakUrl;
    self.baseDelegate = self;
    [self connect_json:bakParams];
    
}

// 设置接口标示
- (void)setViewIdent:(NSString *)viewi
{
    if (![viewIdent isEqualToString:viewi])
        viewIdent= [viewi copy];
}

// 封装http请求头 发起网络请求 xml格式
- (void)getXml:(NSMutableDictionary*)params :(NSString*)viewid
{
    requestType = @"local";
    [self setViewIdent:viewid];
    
    NSInteger severIndex = [Util SelectTheServerUrl];
    switch (severIndex)
    {
        case 1:
            self.interfaceURL = [[@REQUEST_HEAD_NORMAL stringByAppendingString:([MySingleton sharedSingleton].testUrl)]
                                 stringByAppendingString:viewIdent];
            break;
            
        case 2:
            self.interfaceURL = [[@REQUEST_HEAD_NORMAL stringByAppendingString:([MySingleton sharedSingleton].interTestUrl)]
                                 stringByAppendingString:viewIdent];
            break;
            
        case 0:
        default:
            self.interfaceURL = [[@REQUEST_HEAD_NORMAL stringByAppendingString:([MySingleton sharedSingleton].baseInterfaceUrl)]
                                 stringByAppendingString:viewIdent];
            break;
    }

    self.baseDelegate = self;
    [self connect_xml:params];
}

- (void)getWXContent:(NSMutableDictionary*)params :(NSString*)viewid
{
    requestType = @"weixin";
    [self setViewIdent:viewid];
    self.interfaceURL = [[@REQUEST_HEAD_SCREAT stringByAppendingString:[[MySingleton sharedSingleton] weixinInterfaceUrl]] stringByAppendingString:viewIdent];
    self.baseDelegate = self;
    [self connect_xml:params];
}

- (void)postWXContent:(NSMutableDictionary*)params :(NSString*)viewid
{
    requestType = @"weixin";
    [self setViewIdent:viewid];
    self.interfaceURL = [[@REQUEST_HEAD_NORMAL stringByAppendingString:[[MySingleton sharedSingleton] weixinInterfaceUrl]] stringByAppendingString:viewIdent];
    self.baseDelegate = self;
    [self connect_json:params];
}

#pragma mark - BaseInterfaceDelegate

/*************************************************
 Function:       // parseResult
 Description:    // 处理网络下行数据
 Input:          // request 请求对象
 Return:         //
 Others:         //
 *************************************************/
- (void)parseResult:(LNHTTPRequest *)request
{
    if (loadingView.window)
        [loadingView disapper];
    
    NSDictionary *header = [request responseHeaders];
    NSString *responseCode = [header objectForKey:@"mymhotel-status"];
    NSString *responseMsg = [header objectForKey:@"mymhotel-message"];

    // 除了查询类型为微信以外，检查网络请求异常状态
    if (![requestType isEqualToString:@"weixin"])
    {
        NSLog(@"mymhotel-status:%@", responseCode);
        
        // 无响应：网络连接失败
        if (responseCode == NULL)
        {
            [self.delegate pushResponseResultsFailed:self.viewIdent responseCode:responseCode withMessage:@"联网失败,请重新尝试联网"];
            return;
        }
        
        // 有网络连接
        NSString *unicodeStr = [NSString stringWithCString:[responseMsg cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        NSLog(@"返回的数据:%@", unicodeStr);
        
        // 解析状态数据
        NSArray* msgs = [unicodeStr componentsSeparatedByString:@"|"];
        // 登录失败或者超时的情况，自动登录一次（之前的操作未完成，需要用户重新点击发起操作）
        // if (![msgs[0] isEqualToString:@"OK"])
        if ([msgs[0] isEqualToString:@"EBA013"]
            ||[msgs[0] isEqualToString:@"TICKET_ISNULL"]
            ||[msgs[0] isEqualToString:@"TOKEN_INVALID"]
            ||[msgs[0] isEqualToString:@"UNLOGIN"]
            ||[msgs[0] isEqualToString:@"EBF001"]
            ||[msgs[0] isEqualToString:@"EBF003"]
            ||[msgs[0] isEqualToString:@"ES0003"])
        {
            [self logIn];
            return;
        }
        // 返回无数据的状态
        if (msgs != nil && msgs.count > 1)
        {
            NSRange range = [msgs[1] rangeOfString:@"不存在"];
            if ([responseCode isEqualToString:@"ERR"]
                || [msgs[1]isEqualToString:@"无数据"]
                || [msgs[1]isEqualToString:@"数据空"]
                || range.length > 0)
            {
                [self.delegate pushResponseResultsFailed:self.viewIdent responseCode:responseCode withMessage:msgs[1]];
                return;
            }
        }
        else // msg如果不是两段数据也提示返回错误？
        {
            [self.delegate pushResponseResultsFailed:self.viewIdent responseCode:responseCode withMessage:unicodeStr];
        }
    }

    // 解析返回的数据
    NSString *jsonStr = [[NSString alloc] initWithString:[request responseStringFormatUTF8]];//Data:
    NSLog(@"jsonStr:%@", jsonStr);
    if (jsonStr != nil)
    {
        @try
        {
            // 不需要返回数据的请求
            if (jsonStr.length < 1)
            {
                [self.delegate pushResponseResultsFinished:self.viewIdent responseCode:responseCode withMessage:@"请求成功" andData:nil];
                return;
            }
            // 有返回数据的请求
            Parser *parser = [[Parser alloc]init];
            NSData *dict = [jsonStr JSONValue];
            NSMutableArray* array = [parser parser:viewIdent fromData:dict];
            [self.delegate pushResponseResultsFinished:self.viewIdent responseCode:responseCode withMessage:@"" andData:array];
        }
        @catch (NSException *exception)
        {
        }
    }
}

- (void)requestIsFailed:(NSError *)error
{
    if (loadingView.window)
        [loadingView disapper];
    NSLog(@"%@",error.domain);
    NSLog(@">>>>>>>>>>>>>>>>>>>>requestIsFailed<<<<<<<<<<<<<<<<<<<<<<");
    [self.delegate pushResponseResultsFailed:self.viewIdent responseCode:@"" withMessage:[NSString stringWithFormat:@"联网请求失败，请检查手机网络状况。"]];
}

#pragma mark - 自动登录

- (void)logIn
{
    index++;
    if (index > 2)
    {
        index = 0;
        return;
    }

    DBUserLogin *user =  [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    
    if (user == nil //没有用户，返回
        || ([Util isEmptyOrNull:user.account]&&[Util isEmptyOrNull:user.email]) // 用户账号（手机号）和邮箱同时为空
        || [Util isEmptyOrNull:user.password]) // 没有用户密码
        return;
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:(user.account == nil || [user.account isEqualToString:@""]) ? user.email : user.account forKey:@"account"];
    [params setObject:user.password forKey:@"password"];
    [self getContent:params
           withUrlId:@URI_LOGIN
        withUrlRhead:@REQUEST_HEAD_NORMAL
          withByUser:YES];
    
}

@end
