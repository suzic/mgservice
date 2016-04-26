//
//  LoginViewController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<RequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *account; // 账号

@property (weak, nonatomic) IBOutlet UITextField *passWord; // 密码

@property (nonatomic,strong) NSDictionary * loginParams;  // 登录信息

@property (nonatomic,strong) NSURLSessionTask * accessServerTimeTask;

@property (nonatomic,strong) NSURLSessionTask * checkIsLoginTask;

@property (nonatomic,strong) NSURLSessionTask * requestLoginTask;

@property (nonatomic,strong) NSURLSessionTask * waiterInfoTask;

@property (nonatomic,strong) LCProgressHUD * hud;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RequestNetWork defaultManager]registerDelegate:self];
    
    self.loginButton.layer.cornerRadius = 4.0f;
    
    //[self NETWORK_accessServerTime];
    
}

- (void)dealloc {
    if(self.hud){
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
    }
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
//    
//    if ([witerInfo.isLogin isEqualToString:@"1"])
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

#pragma mark - 网络请求

// 获取服务器时间
- (void)NETWORK_accessServerTime
{
    self.accessServerTimeTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_SCREAT
                                                          webURL:@URI_MESSAGE_BASETIME
                                                          params:nil
                                                      withByUser:YES];
}


- (void)RESULT_accessServerTime:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
    
    }
    else
    {
        
    }
}

// 服务员状态查询 是否登陆成功（弃用）
- (void)NETWORK_checkIsLogin
{
    
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": waiterInfo.deviceId,
                                     @"deviceToken":waiterInfo.deviceToken}];
    
    self.checkIsLoginTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                          webURL:@URI_WAITER_CHECKSTATUS
                                                          params:params
                                                      withByUser:YES];
}

- (void)RESULT_checkIsLogin:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.attendanceState = @"1";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"自动登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
    }
}

// 获取服务员信息
- (void)NETWORK_waiterInfo
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
//    NSLog(@"%@",waiterInfo.deviceId);
//    NSLog(@"%@",waiterInfo.deviceToken);
//    NSLog(@"%@",waiterInfo.workNum);
//    NSLog(@"%@",waiterInfo.password);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":waiterInfo.deviceId,
                                                                                   @"deviceToken":waiterInfo.deviceToken}];
    self.waiterInfoTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                   webURL:@URI_WAITER_CHECKINFO
                                                                   params:params
                                                               withByUser:YES];
}

- (void)RESULT_waiterInfo:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // 失败需要重新登录
        [self NETWORK_requestLogin];
    }
}

// 登录请求
- (void)NETWORK_requestLogin
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
//    waiterInfo.deviceToken = @"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8157";
    
//    SHLoadingView *loadingView = [SHLoadingView loadingView];
//    [loadingView showSynchronous];
    
    //三亚红树林现场获取mac地址
//    [self NETWORK_getMAX];
    
    //由于不在现场，获取不到mac地址，因此写个假的,代替diviceId地址
    self.macStr = [self uuid];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:
                                    @{@"workNum":self.account.text,
                                      @"passward":self.passWord.text,
                                      @"diviceId":self.macStr,
                                      @"deviceToken":waiterInfo.deviceToken}];//deviceId:12:34:02:00:00:37
    self.requestLoginTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                     webURL:@URI_WAITER_LOGIN
                                                                     params:params
                                                                 withByUser:YES];
    self.loginParams = params;
    
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (void)RESULT_requestLogin:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if ([datas[0] isEqualToString:@"0"])
        {
            //登录成功存储服务员登录信息
            DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
            waiterInfo.workNum = _loginParams[@"workNum"];
            waiterInfo.password = _loginParams[@"passward"];
            waiterInfo.deviceId = _loginParams[@"diviceId"];
            waiterInfo.deviceToken = _loginParams[@"deviceToken"];
            [[DataManager defaultInstance]saveContext];
            //登录成功获取服务员信息
            [self NETWORK_waiterInfo];
            //应用登陆成功后，调用SDK
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:datas[1] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[RequestNetWork defaultManager]registerDelegate:self];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        NSLog(@"%@    %@",code,message);
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[RequestNetWork defaultManager]registerDelegate:self];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - RequestNetWorkDelegate 协议方法

- (void)startRequest:(NSURLSessionTask *)task
{
    if (!self.hud)
    {
        self.hud = [[LCProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                               andStyle:titleStyle andTitle:@"正在加载...."];
    }
    else
    {
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
        self.hud = [[LCProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                               andStyle:titleStyle andTitle:@"正在加载...."];
    }
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:_hud];
    [_hud startWMProgress];
}

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];

    if (task == self.accessServerTimeTask)
    {
        [self RESULT_accessServerTime:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.checkIsLoginTask)
    {
        [self RESULT_checkIsLogin:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.requestLoginTask)
    {
        [self RESULT_requestLogin:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.waiterInfoTask)
    {
        [self RESULT_waiterInfo:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.accessServerTimeTask)
    {
        [self RESULT_accessServerTime:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.checkIsLoginTask)
    {
        [self RESULT_checkIsLogin:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.requestLoginTask)
    {
        [self RESULT_requestLogin:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.waiterInfoTask)
    {
        [self RESULT_waiterInfo:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - 按钮点击方法

// 点击登录方法
- (IBAction)loginPressed:(id)sender
{
    NSString * username = self.account.text;
    NSString * password = self.passWord.text;
    if (username.length <= 0 || password.length <= 0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[RequestNetWork defaultManager]registerDelegate:self];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self NETWORK_requestLogin];
}

#pragma mark----------
//现场获取mac地址
- (void)NETWORK_getMAX
{
    //    SHLoadingView *loadingView = [SHLoadingView loadingView];
    //    [loadingView showSynchronous];
    //    NSString *urlStr = @"http://10.11.88.104/cgi-bin/mac.sh";
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //        NSString* macStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //
    //        if (macStr.length>0)
    //        {
    //            macStr = [macStr substringToIndex:macStr.length - 1];
    //            [[NSUserDefaults standardUserDefaults]setObject:@"innet" forKey:@"netType"];
    //            DBParameter *paramenter = [[DataManager defaultInstance] getParameter];
    //            paramenter.diviceId = macStr;
    //            [[DataManager defaultInstance] saveContext];
    //            // 获取Mac地址成功之后开启定位
    //            [loadingView disapper];
    //            NSLog(@"<<<<<<<<<<<<<<<<<<<<获取Mac地址成功>>>>>>>>>>>>>>>>>>:%@",macStr);
    //            [self startUserCurrentArea];
    //            // 检查最后一条呼叫任务
    //            [self requestTaskList];
    //        }else
    //        {
    //            [[NSUserDefaults standardUserDefaults]setObject:@"outnet" forKey:@"netType"];
    //            [loadingView disapper];
    //            
    //        }
    //    }];
}
@end
