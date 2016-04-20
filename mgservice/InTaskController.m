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
@property (strong, nonatomic) IBOutlet UIButton *myLocation;//我的位置
@property (strong, nonatomic) IBOutlet UIButton *heLocation;//他的位置
@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;//聊天记录View
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;//聊天记录视图上
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;//聊天记录视图下
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMap;//显示地图按钮
@property (retain, nonatomic) NSMutableArray *messageArray;
@property (assign, nonatomic) BOOL showTalk;  //显示聊天页面
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;
@property (nonatomic, strong) CADisplayLink * timer;
@property (assign,nonatomic) NSInteger second;//时间
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
    //发送通知，计算键盘高度
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //返回按钮 临时用
//    self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton;
    
    //测试任务完成的方法
    [self endTask];
    
    //创建聊天对象
    [self createChat];
    
    //计时器
    [self theTimer];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomePage:) name:@"backHomePage" object:nil];
}

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
        NSString * taskCode = (NSString *)[SPUserDefaultsManger getValue:@"taskCode"];
        DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"diviceId":waiterInfo.deviceId,
                                         @"deviceToken":waiterInfo.deviceToken,
                                         @"taskCode":taskCode}];//任务编号
        
        self.reloadWorkStatusTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                              webURL:@URI_WAITER_FINISHTASK
                                                                              params:params
                                                                          withByUser:YES];
        //登出IM
        [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
        [SPUserDefaultsManger setValue:nil forKey:@"taskCode"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//创建聊天对象
- (void)createChat
{
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:@"testuser10" passWord:@"123456" preloginedBlock:nil successBlock:^{
        //到这里已经完成SDK接入并登录成功
        //创建聊天对象
        YWPerson * person = [[YWPerson alloc]initWithPersonId:@"test0" appKey:@"23337443"];//23344766 //23337443
        YWP2PConversation * conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
        self.chatVC = [[SPKitExample sharedInstance] exampleMakeConversationViewControllerWithConversation:conversation];
    } failedBlock:^(NSError *aError) {
        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
            /// 可以显示错误提示
        }
    }];
}

//计时器
- (void)theTimer
{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTimer)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.getStrDate = (NSString *)[SPUserDefaultsManger getValue:@"timeTask"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:self.getStrDate];
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

//这是一个按钮
- (IBAction)tapHistory:(id)sender
{
    NSLog(@"按钮");
    if (self.showTalk == NO)
    {
        self.showTalk = YES;
        //改变聊天对象的frame，并且添加到chatHistoryView上
        self.chatVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 69-64);
        [self addChildViewController:self.chatVC];
        [self.chatHistoryView addSubview:self.chatVC.view];
    }else{
        NSLog(@"无动作");
        return;
    }
}

//每次点地图按钮的时候执行这个。
- (IBAction)swithTalk:(id)sender
{
    [self.chatVC.messageInputView resignFirstResponder];
    self.showTalk = NO;
}

//通知中的方法
- (void)backHomePage:(NSNotification*)notification
{
    [SPUserDefaultsManger setValue:nil forKey:@"taskCode"];
    [self.navigationController popViewControllerAnimated:YES];
}
//textView代理
//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGSize textMaxSize = CGSizeMake(self.view.frame.size.width - 20,MAXFLOAT);
//    CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
//    self.bottomViewHeight.constant = textSize.height +20;
//}

@end
