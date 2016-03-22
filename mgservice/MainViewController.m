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

#define kPause @"pause"
#define kStart @"start"
#define kIswork @"iswork"

@interface MainViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,RequestNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *taskTable;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel; // 显示倒计时文本
@property (weak, nonatomic) IBOutlet UILabel *waiterName; // 服务员姓名
@property (weak, nonatomic) IBOutlet UILabel *waiterCurrentArea; // 当值区域

@property (retain, nonatomic) NSMutableArray *taskArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) NSURLSessionTask * task1;
@property (nonatomic, retain) NSURLSessionTask * task2;
@property (nonatomic,strong) LCProgressHUD * hud;

@end

@implementation MainViewController
{
    CGFloat lastScrollOffsetY;
    BOOL direction;
    
    //  定时器
    CADisplayLink *_timer;
    NSInteger _second;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    direction = NO;
    lastScrollOffsetY = 0;
    self.selectedIndex = 0;
    self.statusButton.layer.cornerRadius = 40.0f;
    self.acceptButton.layer.cornerRadius = 4.0f;
    [self performSegueWithIdentifier:@"showLogin" sender:self];

    [self setupDemoData];
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTime)];
    _second = 0;
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    NSDate *date = (NSDate *)[SPUserDefaultsManger getValue:kStart];
    if (date)
    {
        _second = labs((NSInteger)([date timeIntervalSinceNow]) * 60);
    }
    
    if ([SPUserDefaultsManger getValue:@"background"] && [SPUserDefaultsManger getBool:kPause])
    {
        _timer.paused = NO;
    }
    else
    {
        _timer.paused = YES;
    }
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

// 刷新当前工作状态
- (void)NETWORK_reloadWorkStatUs:(NSString *)attendanceState
{
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    if (witerInfo == nil)
        return;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId":  @"12:34:02:00:00:33",
                                     @"deviceToken":@"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151",
                                     @"workingState":attendanceState}];
    
    self.task1 = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                  webURL:@URI_WAITER_ISWORK
                                  params:params
                              withByUser:YES];
    
}

// 服务员状态查询 是否登陆成功
- (void)NETWORK_checkIsLogin
{
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    if (witerInfo == nil)
        return;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": @"12:34:02:00:00:33",@"deviceToken":@"c4cee031f6e9d9d1e3ffe9da5d7cdc90bc4dbefae0eb4a16cdd262cedf1f8151"}];
    
    self.task2 = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                  webURL:@URI_WAITER_CHECKSTATUS
                                  params:params
                              withByUser:YES];
}

- (void)RESULT_checkIsLogin:(NSMutableArray *)datas withSucceed:(BOOL)succeed
{
    if (succeed) {
        NSLog(@"%@",datas);
    }
    
}

- (void)RESULT_reloadWorkStatus:(NSMutableArray *)datas withSucceed:(BOOL)succeed {
    if (succeed) {
        NSLog(@"%@",datas);
    }
}

#pragma mark - RequestNetWorkDelegate 代理方法

- (void)startRequest:(YWNetWork *)manager {
    if (!self.hud) {
        self.hud = [[LCProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                               andStyle:titleStyle andTitle:@"正在加载...."];
    }else{
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
    if (task == self.task1){
        [self RESULT_checkIsLogin:datas withSucceed:YES];
    }else if (task == self.task2) {
        [self RESULT_reloadWorkStatus:datas withSucceed:YES];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.task1){
        [self RESULT_checkIsLogin:nil withSucceed:NO];
    }else if (task == self.task2) {
        [self RESULT_reloadWorkStatus:nil withSucceed:NO];
    }
}

#pragma mark - 按钮点击方法
// 工作状态切换按钮
- (IBAction)workingStatus:(UIButton *)sender
{
    DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([witerInfo.attendanceState isEqualToString:@"0"])
    {
        _timer.paused = NO;
        NSDate *date = [NSDate date];
        [SPUserDefaultsManger setValue:date forKey:kStart];
        // 修改当前状态为上班
        [self NETWORK_reloadWorkStatUs:@"1"];
    }
    else
        
    {
        _timer.paused = YES;
        [SPUserDefaultsManger setBool:_timer.paused forKey:kPause];
        // 修改当前状态为下班
        [self NETWORK_checkIsLogin];
        [self NETWORK_reloadWorkStatUs:@"0"];
    }
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

- (void)setupDemoData
{
    for (int i = 0; i < 20; i++)
    {
        [self.taskArray addObject:[NSString stringWithFormat:@"任务编号 %02d", i]];
    }
    self.selectedIndex = 2;
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
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        _timer.paused = YES;
        _second = 0;
        self.countdownLabel.text = [self calculate:_second];
        DataManager* dataManager = [DataManager defaultInstance];
        DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
        witerInfo.isLogin = @"2";
        //存储数据
        [dataManager saveContext];
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

@end
