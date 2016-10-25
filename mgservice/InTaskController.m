//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"
#import "MainViewController.h"
#import "NgrmapViewController.h"

@interface InTaskController ()<RequestNetWorkDelegate>


@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;//聊天记录View

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;//聊天记录视图上
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;//聊天记录视图下
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (retain, nonatomic) NSMutableArray *messageArray;
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;//完成任务
@property (nonatomic, strong) NSURLSessionTask * reloadTaskStatus;//任务状态

@property (nonatomic, strong) CADisplayLink * timer;
@property (assign,nonatomic) NSInteger second;//时间
@property (nonatomic,strong) LCProgressHUD * hud;

@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[RequestNetWork defaultManager]registerDelegate:self];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewBottom.constant = 60 - self.view.frame.size.height;
    self.chatHistoryView.backgroundColor = [UIColor clearColor];
    self.showTalk = NO;

    self.messageLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.layer.borderWidth = 1.0f;
    self.messageLabel.layer.cornerRadius = 25.0f/2.0f;
    //返回按钮 临时用
//    self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton;
    //模拟任务完成的方法
//    [self endTask];
    
    //即时通讯登录
    [self instantMessaging];
    
    //计时器
    [self theTimer];
    
    //接收通知,管家取消到场任务时执行此通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomePage:) name:@"backHomePage" object:nil];
    
    //来新消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessage:) name:NotiNewMessage object:nil];

    //查询任务状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskStatus:) name:PushTaskStatus object:nil];
    
    //回到主页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backMainViewController:) name:@"backMainViewController" object:nil];
    
    [self NETWORK_TaskStatus];
    
    NSString * messageCount = (NSString *)[SPUserDefaultsManger getValue:@"messageCount"];
    if (messageCount != nil) {
        self.messageLabel.text = messageCount;
        self.messageLabel.hidden = NO;
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    
}
- (DBTaskList *)waiterTaskList
{
    if (_waiterTaskList == nil)
    {
        //拿到coredata里的数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
        _waiterTaskList = (DBTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil] lastObject];
    }
    return _waiterTaskList;
}
#pragma mark-模拟完成任务
- (void)endTask
{
    UIButton * endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    endButton.frame = CGRectMake(200, 250, 100, 30);
    [endButton setTitle:@"小于10米" forState:UIControlStateNormal];
    [endButton setBackgroundColor:[UIColor greenColor]];
    [endButton addTarget:self action:@selector(endButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endButton];
}

- (void)endButton:(UIButton *)button
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"任务已完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self NETWORK_reloadWorkStatusTask];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark-网络请求
//完成任务
- (void)NETWORK_reloadWorkStatusTask
{
    [self whenSkipUse];
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"waiterId":waiterInfo.waiterId,
                                     @"taskCode":self.waiterTaskList.taskCode}];//任务编号
    self.reloadWorkStatusTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                          webURL:@URI_WAITER_FINISHTASK
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_reloadWorkStatusTask:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        if (datas.count > 0) {
//            DBMessage * message = self.waiterTaskList.hasMessage;
//            [[DataManager defaultInstance] deleteFromCoreData:message];
//            [[DataManager defaultInstance] deleteFromCoreData:self.waiterTaskList];
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
//            DBTaskList * waiterTask = [[[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil]lastObject];
            self.waiterTaskList.taskStatus = @"1";
            [[DataManager defaultInstance] saveContext];
            [self.conversation removeAllLocalMessages];
            [self deallocInstantMessageing];
            [self.conversation markConversationAsRead];
            [SPUserDefaultsManger setValue:@"" forKey:@"taskCode"];
            //登出IM
            [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
            [SPUserDefaultsManger deleteforKey:@"messageCount"];
            NSString * task = [NSString stringWithFormat:@"呼叫任务（%@）已完成",self.waiterTaskList.taskCode];
            NSString * content = @"服务员点击了完成任务";
            GradingView * gradingView = [[GradingView alloc]initWithTaskType:content contentText:task color:[UIColor grayColor]];
            [gradingView showGradingView:YES];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"完成任务失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//通过任务编号，获得任务信息
- (void)NETWORK_TaskStatus
{
    NSString * strCode = (NSString *)[SPUserDefaultsManger getValue:@"taskCode"];
    NSLog(@"%@",strCode);
    if (strCode == nil)
        return;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"taskCode":strCode}];//任务编号
    self.reloadTaskStatus = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                      webURL:@URI_WAITER_TASkSTATUS
                                                                      params:params
                                                                  withByUser:YES];
}

//如果用户取消任务，服务员端则删除已接任务，并且返回到主页面
- (void)RESULT_taskStatus:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        DBStatisticalInfoList * infoList = datas[0];
        NSLog(@"%@",infoList.taskStatus);
        if ([infoList.taskStatus isEqualToString:@"0"])
        {
            return;
        }
        if ([infoList.taskStatus isEqualToString:@"9"])
        {
                //登出IM
            [SPUserDefaultsManger setValue:@"" forKey:@"taskCode"];
            [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
            [SPUserDefaultsManger deleteforKey:@"messageCount"];
            
            NSString * task = [NSString stringWithFormat:@"呼叫任务（%@）被取消",self.waiterTaskList.taskCode];
            NSString * content = @"客人取消了呼叫服务";
            GradingView * gradingView = [[GradingView alloc]initWithTaskType:content contentText:task color:[UIColor grayColor]];
            [gradingView showGradingView:YES];
        }
    }
}

#pragma mark - RequestNetWorkDelegate 代理方法
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
    [appDelegate.window addSubview:self.hud];
    [self.hud startWMProgress];
}

//成功回调
- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.reloadWorkStatusTask)
    {
        [self RESULT_reloadWorkStatusTask:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    if (task == self.reloadTaskStatus)
    {
        [self RESULT_taskStatus:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    
}

//失败回调
- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.reloadWorkStatusTask)
    {
        [self RESULT_reloadWorkStatusTask:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    if (task == self.reloadTaskStatus) {
        [self RESULT_taskStatus:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}



- (void)whenSkipUse
{
    if(self.hud)
    {
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
    }
    [[RequestNetWork defaultManager]cancleAllRequest];
}

#pragma mark-即时通讯登录IM
// 即时通讯登录
- (void)instantMessaging
{
    //以下三行代码是固定值，如果不需要只需注释或删掉即可
//    self.waiterTaskList.wUserId = @"testuser10";
//    self.waiterTaskList.cUserId = @"test0";
//    self.waiterTaskList.cAppkey = @"23337443";
//    NSLog(@"%@",self.waiterTaskList.wUserId);
    //登录IM
    NSLog(@"%@ ---- %@ -- %@",self.waiterTaskList.hasMessage.wUserId,self.waiterTaskList.hasMessage.cUserId,self.waiterTaskList.hasMessage.cAppkey);
    [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:self.waiterTaskList.hasMessage.wUserId passWord:@"sjlh2016" preloginedBlock:nil successBlock:^{
        YWPerson * person = [[YWPerson alloc]initWithPersonId:self.waiterTaskList.hasMessage.cUserId appKey:self.waiterTaskList.hasMessage.cAppkey];
        self.conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext: [SPKitExample sharedInstance].ywIMKit.IMCore];
        self.showMessageLabel = YES;
    } failedBlock:^(NSError * error) {
        NSLog(@"登录IM失败");
    }];
}

#pragma mark-创建即时通讯页面
// 创建及时通讯界面
- (void)instantMessageingFormation
{
    [self deallocInstantMessageing];
    self.conversationView = [[SPKitExample sharedInstance]exampleMakeConversationViewControllerWithConversation:self.conversation];
    self.conversationView.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    self.conversationView.backgroundImage = nil;
    self.conversationView.view.backgroundColor = [UIColor clearColor];
    self.conversationView.tableView.backgroundView = nil;
    self.conversationView.tableView.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = [NSString stringWithFormat:@"%ld",(long)self.conversation.conversationUnreadMessagesCount.integerValue];
    [self addChildViewController:self.conversationView];
    [self.chatHistoryView addSubview: self.conversationView.view];
}
- (void)deallocInstantMessageing
{
    if (self.conversationView) {
        [self.conversationView.view removeFromSuperview];
        [self.conversationView removeFromParentViewController];
        self.conversationView = nil;
    }
}

#pragma mark-计时器
//计时器
- (void)theTimer
{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTimer)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:self.waiterTaskList.timeLimit];
    self.second = labs((NSInteger)[date timeIntervalSinceNow] *60);
    self.timeLable.font = [UIFont fontWithName:@"Verdana" size:34];
}

//时间
- (void)changeTimer
{
    self.second ++;
    if (self.second > 18000) {
        self.timeLable.textColor = [UIColor redColor];
        self.mapViewController.title = @"当前执行中任务(已超时)";
    }
    self.timeLable.text = [self calculate:self.second];
}

// 格式化时间
- (NSString *)calculate:(NSInteger)totalSecond
{
    NSString *string    = @"";
    NSInteger seconds   = totalSecond / 60 % 60;
    NSInteger mins      = totalSecond / 3600 % 60;
    NSInteger hours     = totalSecond / 3600 / 60 % 60;
    NSString *secondStr = seconds < 10 ? [NSString stringWithFormat:@"0%ld",(long)seconds] :[NSString stringWithFormat:@"%ld",(long)seconds];
    NSString *minStr    = mins < 10 ? [NSString stringWithFormat:@"0%ld",(long)mins] :[NSString stringWithFormat:@"%ld",(long)mins];
    NSString *hourStr   = hours < 10 ? [NSString stringWithFormat:@"0%ld",(long)hours] :[NSString stringWithFormat:@"%ld",(long)hours];
    string = [NSString stringWithFormat: @"%@:%@:%@",hourStr,minStr,secondStr];
    return string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-弹出下面的视图
//显示聊天页面 yes弹出页面，并显示地图按钮
- (void)setShowTalk:(BOOL)showTalk
{
    if (_showTalk == showTalk)
        return;
    _showTalk = showTalk;
    [self.mapViewController showMsgView:_showTalk];
}

//这是聊天记录视图下的大按钮的点击事件
- (IBAction)tapHistory:(id)sender
{
    if (self.showTalk == NO)
    {
        self.arrowUpAndDownImage.image = [UIImage imageNamed:@"down"];
        self.showTalk = YES;
        //创建聊天对象
        [self instantMessageingFormation];
        self.showMessageLabel = NO;
        self.messageLabel.hidden = YES;
        [SPUserDefaultsManger deleteforKey:@"messageCount"];
    }else{
        NSLog(@"无动作");
        self.arrowUpAndDownImage.image = [UIImage imageNamed:@"up"];
        [self.conversationView.messageInputView resignFirstResponder];
        self.showTalk = NO;
        [self deallocInstantMessageing];
        [self.conversation markConversationAsRead];
        self.showMessageLabel = YES;
        self.messageLabel.hidden = YES;
        self.navigationItem.rightBarButtonItem = self.showTalk ? nil : self.mapViewController.showMap;
        return;
    }
}

#pragma mark-收起聊天
//每次点地图按钮的时候执行这个。
- (IBAction)swithTalk:(id)sender
{
    self.arrowUpAndDownImage.image = [UIImage imageNamed:@"up"];
    [self.conversationView.messageInputView resignFirstResponder];
    self.showTalk = NO;
    [self deallocInstantMessageing];
    [self.conversation markConversationAsRead];
    self.showMessageLabel = YES;
    self.messageLabel.hidden = YES;
}

#pragma mark-通知方法
//收到取消任务的通知后，删除已接任务
- (void)backHomePage:(NSNotification*)notification
{
    [self NETWORK_TaskStatus];
}

//显示未读消息角标
- (void)newMessage:(NSNotification *)noti
{
    [SPUserDefaultsManger setValue:[NSString stringWithFormat:@"%ld",(long)self.conversation.conversationUnreadMessagesCount.integerValue] forKey:@"messageCount"];
    
    NSString * messageCount = (NSString *)[SPUserDefaultsManger getValue:@"messageCount"];
    self.messageLabel.text = messageCount;
    if (self.showMessageLabel == NO) {
        self.messageLabel.hidden = YES;
    }else{
        self.messageLabel.hidden = self.conversation.conversationUnreadMessagesCount.integerValue > 0 ? NO : YES;
    }
}

//查询任务状态
- (void)taskStatus:(NSNotificationCenter*)taskStatus
{
    [self NETWORK_TaskStatus];
}

//回到主页
- (void)backMainViewController:(NSNotificationCenter *)noti
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    self.mapViewController = nil;
}
@end
