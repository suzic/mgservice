//
//  LoginViewController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<RequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *account; // 账号

@property (weak, nonatomic) IBOutlet UITextField *passWord; // 密码

@property (nonatomic,strong) NSDictionary * loginParams;  // 登录信息

@property (nonatomic,strong) NSURLSessionTask * accessServerTimeTask;

@property (nonatomic,strong) NSURLSessionTask * checkIsLoginTask;

@property (nonatomic,strong) NSURLSessionTask * requestLoginTask;

@property (nonatomic,strong) NSURLSessionTask * waiterInfoTask;

@property (nonatomic,strong) MainViewController * mainVC;

@property (weak, nonatomic) IBOutlet UILabel *localMacAddress;

@property (nonatomic,assign) BOOL inhotel;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RequestNetWork defaultManager]registerDelegate:self];
    
    self.loginButton.layer.cornerRadius = 4.0f;
    
    //[self NETWORK_accessServerTime];
    self.inhotel = YES;
    //获取MAC地址
    [self NETWORK_getMAC];
}

- (void)dealloc
{
   
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
                                                                                   @"deviceToken":waiterInfo.deviceToken,
                                                                                   @"waiterId":waiterInfo.waiterId}];
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
//        [self NETWORK_requestLogin];
    }
}

// 登录请求
- (void)NETWORK_requestLogin
{
    
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    NSLog(@"%@",waiterInfo.deviceId);
    if (waiterInfo.deviceId == nil ||[waiterInfo.deviceId isEqualToString:@""])
    {
        UIAlertController *view = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"未获取到mac地址，请链接酒店Wi-Fi" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            
        }];
        [view addAction:sure];
        [self presentViewController:view animated:YES completion:^{
            
        }];
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:
                                    @{@"workNum":self.account.text,
                                      @"passward":self.passWord.text,
                                      @"diviceId":waiterInfo.deviceId,
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
//            waiterInfo.waiterId = _loginParams[@"waiterId"];
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

#pragma mark - TableView DataSource & Delegate 协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.inhotel == YES ? 2 : 2;//如果在酒店，就显示两行，否则显示三行 暂时都现实两行
    else
        return 1;
}

#pragma mark - RequestNetWorkDelegate 协议方法

- (void)startRequest:(NSURLSessionTask *)task
{
    
}

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{

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
    self.mainVC.timer.paused = YES;
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
//    [self NETWORK_getMAC];
    [self NETWORK_requestLogin];
}

#pragma mark----------
//现场获取mac地址
- (void)NETWORK_getMAC
{
    DBWaiterInfor *waiterInfor = [[DataManager defaultInstance] getWaiterInfor];
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    __block NSString *macAddress;
    __block LoginViewController *weakSelf = self;
    [[FMDHCPNetService shareDHCPNetService] localMacAddress:^(NSString *macAddr)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
        });
        // 未获取到mac地址
        if (macAddr == nil || [macAddr isEqualToString:@""])
        {
            macAddress = nil;
            weakSelf.inhotel = NO;
            
            [[NSUserDefaults standardUserDefaults]setObject:@"outnet" forKey:@"netType"];
            
            NSString * strMac = [[NSUserDefaults standardUserDefaults] objectForKey:@"mac"];
            if ([strMac isEqualToString:@""] || strMac == nil)
            {
                NSInteger x = arc4random() % 1000000000;
                NSString * mac = [NSString stringWithFormat:@"-:%ld:-",(long)x];
                waiterInfor.deviceId = mac;
                macAddress = mac;
                [[NSUserDefaults standardUserDefaults] setValue:mac forKey:@"mac"];
            }
            else
            {
                waiterInfor.deviceId = strMac;
                macAddress = strMac;
            }
            
        }else
        {
            macAddress = macAddr;
            weakSelf.inhotel = NO;
            NSLog(@"<<<<<<<<<<<<<<<<<<<<获取Mac地址成功>>>>>>>>>>>>>>>>>>:%@",macAddress);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",waiterInfor.deviceId);
            waiterInfor.deviceId = macAddress;
            weakSelf.localMacAddress.text = [NSString stringWithFormat:@"mac地址：%@",waiterInfor.deviceId];
            [weakSelf.tableView reloadData];
            [[DataManager defaultInstance] saveContext];
    });
    }];
    
}

@end
