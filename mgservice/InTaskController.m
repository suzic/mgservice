//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"
#import "MainViewController.h"

@interface InTaskController ()
@property (strong, nonatomic) YWConversationViewController * chatVC;
@property (nonatomic,strong) YWConversationViewController * conversationView;

@property (strong, nonatomic) IBOutlet UIButton *myLocation;//我的位置
@property (strong, nonatomic) IBOutlet UIButton *heLocation;//他的位置
@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;//聊天记录View
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;//聊天记录视图上
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;//聊天记录视图下
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMap;//显示地图按钮
@property (retain, nonatomic) NSMutableArray *messageArray;
@property (assign, nonatomic) BOOL showTalk;  //显示聊天页面
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;//取消任务

@property (nonatomic, strong) CADisplayLink * timer;
@property (assign,nonatomic) NSInteger second;//时间
@property (nonatomic,strong) YWP2PConversation * conversation;
@property (nonatomic,strong) LCProgressHUD * hud;
@property (nonnull,strong) DBWaiterTaskList * waiterTask;
@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bottomViewHeight.constant = 40;
    self.myLocation.layer.cornerRadius = 15.0f;
    self.heLocation.layer.cornerRadius = 15.0f;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewBottom.constant = 60 - self.view.frame.size.height;
    self.chatHistoryView.backgroundColor = [UIColor grayColor];
    self.showTalk = NO;
    
    self.messageLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.layer.borderWidth = 1.0f;
    self.messageLabel.layer.cornerRadius = 15.0f;
    
    //发送通知，计算键盘高度
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //返回按钮 临时用
//    self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton;
    
    //模拟任务完成的方法
    [self endTask];
    
    //拿到coredata里的数据
    self.waiterTask = (DBWaiterTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBWaiterTaskList" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil] lastObject];
    
    //即时通讯登录
    [self instantMessaging];
    
    //计时器
    [self theTimer];
    
    //接收通知,管家取消到场任务时执行此通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomePage:) name:@"backHomePage" object:nil];
    
    //来新消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessage:) name:@"NotiNewMessage" object:nil];
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
//        NSString * taskCode = (NSString *)[SPUserDefaultsManger getValue:@"taskCode"];
        DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"diviceId":waiterInfo.deviceId,
                                         @"deviceToken":waiterInfo.deviceToken,
                                         @"taskCode":self.waiterTask.taskCode}];//任务编号
        
        self.reloadWorkStatusTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                              webURL:@URI_WAITER_FINISHTASK
                                                                              params:params
                                                                          withByUser:YES];
        //登出IM
        [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
        self.waiterTask.taskCode = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
        
    }
    
}

//失败回调
- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.reloadWorkStatusTask)
    {
        
    }
    
}

#pragma mark-即时通讯登录
// 即时通讯登录
- (void)instantMessaging
{
    //以下三行代码是固定值，如果不需要只需注释或删掉即可
    self.waiterTask.wUserId = @"testuser10";
    self.waiterTask.cUserId = @"test0";
    self.waiterTask.cAppkey = @"23337443";
    //登录IM
    [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:self.waiterTask.wUserId passWord:@"123456" preloginedBlock:nil successBlock:^{
        YWPerson * person = [[YWPerson alloc]initWithPersonId:self.waiterTask.cUserId appKey:self.waiterTask.cAppkey];
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
    self.conversationView.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 69-64);
//    self.conversationView.backgroundImage = nil;
//    self.conversationView.view.backgroundColor = [UIColor clearColor];
//    self.conversationView.tableView.backgroundView = nil;
//    self.conversationView.tableView.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = [NSString stringWithFormat:@"%ld",self.conversation.conversationUnreadMessagesCount.integerValue];
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
    NSDate* date = [formatter dateFromString:self.waiterTask.timeLimit];
    self.second = labs((NSInteger)[date timeIntervalSinceNow] *60);
    self.timeLable.font = [UIFont fontWithName:@"Verdana" size:34];
}

//时间
- (void)changeTimer
{
    self.second ++;
    if (self.second > 18000) {
        self.timeLable.textColor = [UIColor orangeColor];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.navigationItem.rightBarButtonItem = showTalk ? self.showMap : nil;
    CGRect showHistoryRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 64);
    [UIView animateWithDuration:0.5f animations:^{
        [self.chatHistoryView setFrame:showTalk ? showHistoryRect : hideHistoryRect];
        self.chatHistoryView.alpha = showTalk ? 0.8 : 1;
    } completion:^(BOOL finished) {
        self.chatHistoryViewTop.constant = showTalk ? 0.0f : self.view.frame.size.height - 124;
        self.chatHistoryViewBottom.constant = showTalk ? 0.0f : 60 - self.view.frame.size.height;
    }];
}

//这是聊天记录视图下的大按钮的点击事件
- (IBAction)tapHistory:(id)sender
{
    if (self.showTalk == NO)
    {
        self.showTalk = YES;
        //创建聊天对象
        [self instantMessageingFormation];
        self.showMessageLabel = NO;
        self.messageLabel.hidden = YES;
    }else{
        NSLog(@"无动作");
        return;
    }
}

#pragma mark-收起聊天
//每次点地图按钮的时候执行这个。
- (IBAction)swithTalk:(id)sender
{
    [self.chatVC.messageInputView resignFirstResponder];
    self.showTalk = NO;
    [self deallocInstantMessageing];
    [self.conversation markConversationAsRead];
    self.showMessageLabel = YES;
    self.messageLabel.hidden = YES;
}

#pragma mark-通知方法
//通知中的方法
- (void)backHomePage:(NSNotification*)notification
{
    self.waiterTask.taskCode = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-显示未读消息角标
- (void)newMessage:(NSNotification *)noti
{
    self.messageLabel.text = [NSString stringWithFormat:@"%ld",self.conversation.conversationUnreadMessagesCount.integerValue];
    if (self.showMessageLabel == NO) {
        self.messageLabel.hidden = YES;
    }else{
        self.messageLabel.hidden = self.conversation.conversationUnreadMessagesCount.integerValue > 0 ? NO : YES;
    }
}

//textView代理
//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGSize textMaxSize = CGSizeMake(self.view.frame.size.width - 20,MAXFLOAT);
//    CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
//    self.bottomViewHeight.constant = textSize.height +20;
//}

@end
