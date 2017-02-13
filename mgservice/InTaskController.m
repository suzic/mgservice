//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"
#import "MainViewController.h"

@interface InTaskController ()<RequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;//聊天记录View

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;//聊天记录视图上
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;//聊天记录视图下
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (retain, nonatomic) NSMutableArray *messageArray;
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;//完成任务
@property (nonatomic, strong) NSURLSessionTask * reloadTaskStatus;//任务状态


@property (assign,nonatomic) NSInteger second;//时间

@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[RequestNetWork defaultManager]registerDelegate:self];
    self.navigationItem.hidesBackButton = YES;//隐藏后退按钮
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewBottom.constant = 60 - self.view.frame.size.height;
    self.chatHistoryView.backgroundColor = [UIColor clearColor];
//    self.showTalk = NO;

    self.messageLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.layer.borderWidth = 1.0f;
    self.messageLabel.layer.cornerRadius = 25.0f/2.0f;
    //返回按钮 临时用
//    self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton;
    //模拟任务完成的方法
//    [self endTask];
    
    //即时通讯登录
//    [self instantMessaging];
    
    //计时器
//    [self theTimer];
    
    //接收通知,管家取消到场任务时执行此通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomePage:) name:@"backHomePage" object:nil];
    
    //来新消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessage:) name:NotiNewMessage object:nil];

    //接收通知，在室内地图完成任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTaskAction:) name:@"reloadTask" object:nil];
    
    //接收通知，在室内地图刷新任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskAction:) name:@"refreshTaskItemAction" object:nil];
    
    //查询任务状态
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskStatus:) name:PushTaskStatus object:nil];
    
    //回到主页
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backMainViewController:) name:@"backMainViewController" object:nil];
    
//    [self NETWORK_TaskStatus];
    
//    NSString * messageCount = (NSString *)[SPUserDefaultsManger getValue:@"messageCount"];
//    if (messageCount != nil) {
//        self.messageLabel.text = messageCount;
//        self.messageLabel.hidden = NO;
//    }
}

- (void)taskViewFun
{
    self.chatHistoryView.hidden = NO;
    self.showTalk = NO;
    //即时通讯登录
    [self instantMessaging];
    
    //计时器
    [self theTimer];
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
    NSLog(@"%@-----%@",waiterInfo.taskCode,self.waiterTaskList.taskCode);
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"waiterId":waiterInfo.waiterId,
                                     @"taskCode":self.waiterTaskList.taskCode == nil ? waiterInfo.taskCode : self.waiterTaskList.taskCode}];//任务编号
    self.reloadWorkStatusTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                          webURL:@URI_WAITER_FINISHTASK
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_reloadWorkStatusTask:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
        self.waiterTaskList.taskStatus = @"1";
        self.waiterTaskList.waiterStatus = @"0";
        [self.conversation removeAllLocalMessages];
        [self deallocInstantMessageing];
        [self.conversation markConversationAsRead];
        [SPUserDefaultsManger setValue:@"" forKey:@"taskCode"];
        //登出IM
        [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
        [SPUserDefaultsManger deleteforKey:@"messageCount"];
        NSString * task = [NSString stringWithFormat:@"呼叫任务（%@）已完成",self.waiterTaskList.taskCode == nil ? waiterInfo.taskCode : self.waiterTaskList.taskCode];
        NSString * content = @"服务员点击了完成任务";
        GradingView * gradingView = [[GradingView alloc]initWithTaskType:content contentText:task color:[UIColor grayColor]];
        [gradingView showGradingView:YES];
        
        [self.timer invalidate];
        self.frameController.inTaskView.hidden = YES;
        self.waiterTaskList = nil;
        [[DataManager defaultInstance] saveContext];
        self.chatHistoryView.hidden = YES;
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//               [[NSNotificationCenter defaultCenter] postNotificationName:@"backMainViewController" object:nil];
            [self.frameController backtoMainView];
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
//
////获取任务状态，如果taskStatus=9，证明管家端取消了任务  taskStatus=0，证明任务未完成
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
            self.waiterTaskList.waiterStatus = @"0";
            [[DataManager defaultInstance] saveContext];
            self.frameController.inTaskView.hidden = YES;
            self.waiterTaskList = nil;
            [self.timer invalidate];
            self.chatHistoryView.hidden = YES;
        }
    }
}

#pragma mark - RequestNetWorkDelegate 代理方法
- (void)startRequest:(NSURLSessionTask *)task
{
   
}

//成功回调
- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
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
    NSLog(@"%@",self.waiterTaskList.timeLimit);
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
        //self.mapViewController.title = @"当前执行中任务(已超时)";
    }
    else
    {
        self.timeLable.textColor = [UIColor blackColor];
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
    [self.frameController showMsgView:_showTalk];
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
        self.arrowUpAndDownImage.image = [UIImage imageNamed:@"up"];
        [self.conversationView.messageInputView resignFirstResponder];
        self.showTalk = NO;
        [self deallocInstantMessageing];
        [self.conversation markConversationAsRead];
        self.showMessageLabel = YES;
        self.messageLabel.hidden = YES;
        //这里的rightBarButton是“收起”按钮，现在暂时改为“刷新”按钮，因此注释掉，将来改回来的时候，将注释代码解开即可。
//        self.navigationItem.rightBarButtonItem = self.showTalk ? nil : self.mapViewController.showMap;
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
//- (void)backHomePage:(NSNotification*)notification
//{
//    [self NETWORK_TaskStatus];
//}

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

//室内地图，完成任务
- (void)reloadTaskAction:(NSNotification *)noti
{
    [self NETWORK_reloadWorkStatusTask];
}

//室内地图，刷新任务
- (void)refreshTaskAction:(NSNotification *)noti
{
    [self NETWORK_TaskStatus];
}

//查询任务状态
//- (void)taskStatus:(NSNotificationCenter*)taskStatus
//{
//    [self NETWORK_TaskStatus];
//}

////回到主页
//- (void)backMainViewController:(NSNotificationCenter *)noti
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)dealloc
{
    //self.mapViewController = nil;
}
@end
