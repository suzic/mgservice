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

@property (nonatomic,strong) NSURLSessionTask * accessServerTimeTask;

@property (nonatomic,strong) NSURLSessionTask * checkIsLoginTask;

@property (nonatomic,strong) NSURLSessionTask * requestLoginTask;

@property (nonatomic,strong) LCProgressHUD * hud;

@end

@implementation LoginViewController

{
    BOOL _isLogin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RequestNetWork defaultManager]registerDelegate:self];
    
    _isLogin = NO;
    self.loginButton.layer.cornerRadius = 4.0f;
    
    [self NETWORK_accessServerTime];
    
}

- (void)dealloc {
    if(self.hud){
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
    }
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    
    if ([witerInfo.isLogin isEqualToString:@"1"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

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
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.deviceId = @"12:34:02:00:00:33";
        witerInfo.deviceToken = @"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151";
        _isLogin = YES;
    }
    else
    {
        
    }
}

// 服务员状态查询 是否登陆成功
- (void)NETWORK_checkIsLogin
{
    
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    if (witerInfo == nil)
        return;
    NSLog(@"%@",witerInfo);
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": @"12:34:02:00:00:33",@"deviceToken":@"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151"}];
    
    self.checkIsLoginTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                          webURL:@URI_WAITER_CHECKSTATUS
                                                          params:params
                                                      withByUser:YES];
}

- (void)RESULT_checkIsLogin:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.isLogin = @"1";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"自动登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
    }
}

// 登录请求
- (void)NETWORK_requestLogin
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:
                                    @{@"username":self.account.text,
                                      @"password":self.passWord.text,
                                      @"diviceId": @"12:34:02:00:00:33",
                                      @"deviceToken":@"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151"}];
    self.requestLoginTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_WAITER_CHECKINFO params:params withByUser:YES];
}

- (void)RESULT_requestLogin:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)message withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
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
    // 获取服务器时间
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
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        return;
    }
    [self NETWORK_requestLogin];
}

@end
