//
//  MainViewController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MainViewController.h"
#import "TaskCell.h"
#import "LCProgressHUD.h"

#define ALERT_OFFWORK   1000
#define ALERT_INTOTASK  1001

@interface MainViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,RequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *taskTable;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel; // 显示倒计时文本
@property (weak, nonatomic) IBOutlet UILabel *waiterName; // 服务员姓名
@property (weak, nonatomic) IBOutlet UILabel *waiterCurrentArea; // 当值区域
@property (nonatomic,strong) NSString * strTime;
@property (nonatomic,strong) NSString * strinter;
@property (nonatomic,assign) NSInteger selectPageNumber;

@property (retain, nonatomic) NSMutableArray *taskArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;
@property (nonatomic, strong) NSURLSessionTask * checkIsLoginTask;
@property (nonatomic, strong) NSURLSessionTask * requestTaskTask;
@property (nonatomic, strong) NSURLSessionTask * reloadAttendanceStateTask;
@property (nonatomic,strong) LCProgressHUD * hud;

@end

@implementation MainViewController
{
    CGFloat lastScrollOffsetY;
    
    //  定时器
    CADisplayLink *_timer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RequestNetWork defaultManager]registerDelegate:self];
    if ([[[[DataManager defaultInstance]getWaiterInfor] attendanceState]isEqualToString:@"1"]) {
        [self NETWORK_requestTask];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RequestNetWork defaultManager]registerDelegate:self];
    self.selectPageNumber = 1;
    _direction = NO;
    lastScrollOffsetY = 0;
    self.selectPageNumber = 0;
    self.statusButton.layer.cornerRadius = 40.0f;
    self.acceptButton.layer.cornerRadius = 4.0f;

    self.selectedIndex = 2;
    self.taskArray = [NSMutableArray array];
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTime)];
    _second = 0;
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.countdownLabel.font = [UIFont fontWithName:@"Verdana" size:34];
    NSLog(@"----%@",[SPUserDefaultsManger getValue:@"background"]);
    //从沙盒获取工作状态
    if ([SPUserDefaultsManger getBool:KIsWorkState] ==0)
    {
        _timer.paused = NO;
        _direction = YES;
        [self.statusButton setTitle:@"暂停" forState:UIControlStateNormal];
        NSDate * date = (NSDate *)[SPUserDefaultsManger getValue:kStart];
        if (date) {
            _second = labs((NSInteger)[date timeIntervalSinceNow] *60);
        }
    }
    else
    {
        _direction = NO;
        [self.statusButton setTitle:@"开始" forState:UIControlStateNormal];
        NSDate * date = (NSDate *)[SPUserDefaultsManger getValue:kPause];
        self.strTime = [NSString stringWithFormat:@"%@",[SPUserDefaultsManger getValue:kPause]];
        if (date) {
            _second = self.strTime.integerValue;
            self.countdownLabel.text = [self calculate:_second];
        }
        _timer.paused = YES;
    }
    [self NETWORK_checkIsLogin];
}

#pragma mark - 定时器方法

// 定时器方法
- (void)changeTime
{
    _second++;
    //  格式化字符串
    
    self.countdownLabel.text = [self calculate:_second];
}

// 格式化时间
- (NSString *)calculate:(NSInteger)totalSecond
{
    NSString *string    = @"";
    
    NSInteger seconds   = totalSecond / 60 % 60;
    
    NSInteger mins      = totalSecond / 3600 % 60;
    
    NSInteger hours     = totalSecond / 3600 / 60 % 60;
    
    NSString *secondStr = seconds < 10 ? [NSString stringWithFormat:@"0%ld",(long)seconds] :[NSString stringWithFormat:@"%ld",seconds];
    NSString *minStr    = mins < 10 ? [NSString stringWithFormat:@"0%ld",(long)mins] :[NSString stringWithFormat:@"%ld",mins];
    NSString *hourStr   = hours < 10 ? [NSString stringWithFormat:@"0%ld",(long)hours] :[NSString stringWithFormat:@"%ld",hours];
    string = [NSString stringWithFormat: @"%@:%@:%@",hourStr,minStr,secondStr];
    
    return string;
}

#pragma mark - 网络请求

// 刷新当前上班状态(登出)
- (void)NETWORK_waiterLogout
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"workNum":waiterInfo.workNum,
                                     @"passward":waiterInfo.password}];
    self.reloadAttendanceStateTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                          webURL:@URI_WAITER_LOGOUT
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_waiterLogout:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        if ([datas[0] isEqualToString:@"0"])
        {
            [self.statusButton setTitle:@"开始" forState:UIControlStateNormal];
            _timer.paused = YES;
            _direction = NO;
            _second = 0;
            self.countdownLabel.text = [self calculate:_second];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStart];
            [SPUserDefaultsManger deleteforKey:kPause];
            [SPUserDefaultsManger deleteforKey:@"abc"];
            [SPUserDefaultsManger setBool:1 forKey:@"isWorkState"];
            [SPUserDefaultsManger setValue:@"0" forKey:kIswork];
            DataManager* dataManager = [DataManager defaultInstance];
            DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
            witerInfo.attendanceState = @"0";
            //存储数据
            [dataManager saveContext];
            [self performSegueWithIdentifier:@"showLogin" sender:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"下班失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[RequestNetWork defaultManager]registerDelegate:self];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"下班失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[RequestNetWork defaultManager]registerDelegate:self];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 刷新当前工作状态
- (void)NETWORK_reloadWorkStatus:(NSString *)workstate
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId":waiterInfo.deviceId,
                                     @"deviceToken":waiterInfo.deviceToken,
                                     @"workingState":workstate}];
    self.reloadWorkStatusTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                          webURL:@URI_WAITER_WORKSTATUS
                                                                          params:params
                                                                      withByUser:YES];
}

- (void)RESULT_reloadWorkStatus:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBWaiterInfor * waiter = (DBWaiterInfor *)[[DataManager defaultInstance]getWaiterInfor];
        waiter.workStatus = @"1";
        [[DataManager defaultInstance]saveContext];
    }
    else
    {
        DBWaiterInfor * waiter = (DBWaiterInfor *)[[DataManager defaultInstance]getWaiterInfor];
        waiter.workStatus = @"0";
        [[DataManager defaultInstance]saveContext];
    }
}

// 服务员状态查询 是否登陆成功
- (void)NETWORK_checkIsLogin
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"])
    {
        if(self.hud)
        {
            [self.hud stopWMProgress];
            [self.hud removeFromSuperview];
        }
        [[RequestNetWork defaultManager]cancleAllRequest];
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
        return;
    }
    else if([waiterInfo.attendanceState isEqualToString:@"1"])
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"diviceId":waiterInfo.deviceId,
                                         @"deviceToken":waiterInfo.deviceToken}];
    
        self.checkIsLoginTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:@URI_WAITER_CHECKSTATUS
                                                                         params:params
                                                                     withByUser:YES];
    }
}

- (void)RESULT_checkIsLogin:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBWaiterInfor * waiter = (DBWaiterInfor *)datas[0];
        if ([waiter.attendanceState isEqualToString:@"0"])
        {
            [self performSegueWithIdentifier:@"showLogin" sender:nil];
            [[RequestNetWork defaultManager]registerDelegate:self];
        }
        else
        {
            
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
        [[RequestNetWork defaultManager]registerDelegate:self];
    }
}

// 请求任务列表
- (void)NETWORK_requestTask
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"])
        return;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": waiterInfo.deviceId,
                                     @"deviceToken":waiterInfo.deviceToken,
                                     @"pageNO":[NSString stringWithFormat:@"%ld",self.selectPageNumber],
                                     @"pageCount":@"20",
                                     @"taskStatus":@"2"}];
    self.requestTaskTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URI_WAITER_GETSERVICELIST
                                                                    params:params
                                                                withByUser:YES];
}

- (void)RESULT_requestTask:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        for (DBTaskList * task in datas) {
            [self.taskArray addObject:task];
        }
        [self.taskTable reloadData];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请求数据失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"点击刷新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self NETWORK_requestTask];
        }];
        [alert addAction:action];
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

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.reloadWorkStatusTask)
    {
        [self RESULT_reloadWorkStatus:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.checkIsLoginTask)
    {
        [self RESULT_checkIsLogin:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.requestTaskTask)
    {
        [self RESULT_requestTask:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.reloadAttendanceStateTask)
    {
        [self RESULT_waiterLogout:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.reloadWorkStatusTask)
    {
        [self RESULT_reloadWorkStatus:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.checkIsLoginTask)
    {
        [self RESULT_checkIsLogin:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.requestTaskTask)
    {
        [self RESULT_requestTask:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.reloadAttendanceStateTask)
    {
        [self RESULT_waiterLogout:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - 按钮点击方法
// 工作状态切换按钮
- (IBAction)workingStatus:(UIButton *)sender
{
    if (_direction == NO) {
        _timer.paused = NO;
        _direction = YES;
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        //将工作状态保存起来
        [SPUserDefaultsManger setBool:_timer.paused forKey:KIsWorkState];
        NSDate *date = [NSDate date];
        
        //如果第一次运行，将当前日期存入
        if (![SPUserDefaultsManger getValue:kStart]) {
            [SPUserDefaultsManger setValue:date forKey:kStart];
        }
//        [self reloadWorkStatUs:@"1"];
        [SPUserDefaultsManger setValue:date forKey:kStart];
        // 修改当前状态为上班
        [self NETWORK_reloadWorkStatus:@"1"];
    }
    else
    {
        _timer.paused = YES;
        _direction = NO;
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        //将工作状态保存起来
        [SPUserDefaultsManger setBool:_timer.paused forKey:KIsWorkState];

        [SPUserDefaultsManger setValue:[NSString stringWithFormat:@"%ld",_second] forKey:kPause];
        
        NSDate * da = (NSDate *)[SPUserDefaultsManger getValue:kStart];
        NSLog(@"ffffff....%f",([da timeIntervalSinceNow])*60);
        NSInteger inte = labs((NSInteger)(da.timeIntervalSinceNow)*60);
        NSLog(@"dddddd...%ld",inte);
        NSLog(@"哈哈%@",[self calculate:inte]);
        [SPUserDefaultsManger setValue:[NSString stringWithFormat:@"%ld",inte] forKey:@"abc"];
        
//        [self reloadWorkStatUs:@"0"];
        [SPUserDefaultsManger setBool:_timer.paused forKey:kPause];
        // 修改当前状态为下班
        [self NETWORK_reloadWorkStatus:@"0"];
    }
    
//    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
//    NSLog(@"%@",witerInfo.attendanceState);
//    if ([witerInfo.attendanceState isEqualToString:@"0"])
//    {
//        _timer.paused = YES;
//        NSDate *date = [NSDate date];
//        [SPUserDefaultsManger setValue:date forKey:kStart];
//        //修改当前状态为上班
//        [self reloadWorkStatUs:@"1"];
//    }
//    else if([witerInfo.attendanceState isEqualToString:@"1"])
//    {
//        _timer.paused = NO;
//        [SPUserDefaultsManger setBool:_timer.paused forKey:kPause];
//        // 修改当前状态为下班
//        [self reloadWorkStatUs:@"0"];
//    }
}

- (IBAction)logout:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认下班"
                                                    message:@"您准备要下班了吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"还得继续"
                                          otherButtonTitles:@"我要下班", nil];
    alert.tag = ALERT_OFFWORK;
    [alert show];
}

- (IBAction)obtainTask:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"抢单结果模拟测试"
                                                       delegate:self
                                              cancelButtonTitle:@"没抢到"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"进入呼叫任务", @"进入送餐任务",nil];
    sheet.tag = ALERT_INTOTASK;
    [sheet showInView:self.view];
}

- (NSMutableArray *)taskArray
{
    if (_taskArray == nil)
        _taskArray = [NSMutableArray arrayWithCapacity:10];
    return _taskArray;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex)
        return;
    NSMutableArray *updateIndexes = [NSMutableArray arrayWithCapacity:2];
    [updateIndexes addObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    _selectedIndex = selectedIndex;
    [updateIndexes addObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    [self.taskTable reloadRowsAtIndexPaths:updateIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableView Datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskArray.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2 || indexPath.row >= self.taskArray.count + 2)
        return [tableView dequeueReusableCellWithIdentifier:@"paddingCell"];
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
    cell.taskName.text = self.taskArray[indexPath.row - 2];
    cell.cellSelected = (indexPath.row == self.selectedIndex);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.selectedIndex == indexPath.row && self.selectedIndex >= 2 && self.selectedIndex < self.taskArray.count + 2) ?
        self.taskTable.frame.size.height / 2 : self.taskTable.frame.size.height / 8;
}

// 点选操作会计算选择索引
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2 || indexPath.row >= self.taskArray.count + 2)
        return;
    self.selectedIndex = indexPath.row;
    NSInteger firstRow = self.selectedIndex - 2;
    [self.taskTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 当滚动将要进入减速效果的时候强制执行滚动到索引的功能以中断不可控减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.taskTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex - 2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 当滚动减速结束的时候强制执行滚动到索引的功能以中断不可控减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.taskTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex - 2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 当拖动结束的时候强制执行滚动到索引的功能以中断不可控减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self.taskTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex - 2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 滚动的过程中不断的计算当前自动选择的索引数值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger firstRow = (scrollView.contentOffset.y / self.taskTable.frame.size.height * 8);
    if (firstRow < 0) firstRow = 0;
    self.selectedIndex = firstRow + 2;
}

#pragma mark - UIAlertView / UIActionSheet delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_OFFWORK && buttonIndex == 1)
    {
        [self NETWORK_waiterLogout];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ALERT_INTOTASK && buttonIndex == 0)
        [self performSegueWithIdentifier:@"goTask" sender:self];
    else if (actionSheet.tag == ALERT_INTOTASK && buttonIndex == 1)
        [self performSegueWithIdentifier:@"goMenu" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)dealloc {
    if(self.hud){
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
    }
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}

@end
