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
@property (nonatomic,assign) NSInteger selectPageNumber;  // 请求订单页数
@property (nonatomic,copy) NSString * foodPresentList; // 菜单列表业务号
@property (nonatomic,assign) BOOL isPage;//如果是yes，就是MainVC页面

@property (retain, nonatomic) NSMutableArray *taskArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSURLSessionTask * reloadWorkStatusTask;
@property (nonatomic, strong) NSURLSessionTask * checkIsLoginTask;
@property (nonatomic, strong) NSURLSessionTask * requestTaskTask;
@property (nonatomic, strong) NSURLSessionTask * reloadAttendanceStateTask;
@property (nonatomic, strong) NSURLSessionTask * waiterGetIndentTask;
@property (nonatomic, strong) NSURLSessionTask * menuDetailListTask;
@property (nonatomic, strong) NSURLSessionTask * reloadIMTask;//登录IM请求
@property (nonatomic,strong) LCProgressHUD * hud;

@property (nonatomic,strong) NSString * taskCode;
@end

@implementation MainViewController
{
    CGFloat lastScrollOffsetY;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RequestNetWork defaultManager]registerDelegate:self];
    if ([[NSString stringWithFormat:@"%@",[SPUserDefaultsManger getValue:KIsAllowRefresh]] isEqualToString:@"1"]) {
        if ([[[[DataManager defaultInstance]getWaiterInfor] attendanceState]isEqualToString:@"1"]) {
            self.selectPageNumber = 1;
            [self NETWORK_requestTask];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    NSArray * array = [[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (array.count <= 0 || array == nil)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        for (DBTaskList * task in array) {
            if ([task.category isEqualToString:@"4"])
            {
                self.navigationItem.rightBarButtonItem = self.presentButton;
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
            break;
        }
    }
    DBWaiterInfor * waiterInfo = [[DataManager defaultInstance]getWaiterInfor];
    self.waiterName.text = waiterInfo.name;
    self.waiterCurrentArea.text = waiterInfo.currentArea;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.isPage = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RequestNetWork defaultManager]registerDelegate:self];
    
    self.statusButton.layer.cornerRadius = 40.0f;
    self.acceptButton.layer.cornerRadius = 4.0f;
    
    self.selectPageNumber = 1;
    _direction = NO;
    lastScrollOffsetY = 0;
    self.selectedIndex = 2;
    self.taskArray = [[NSMutableArray alloc]init];
    
    //获取工作状态
    [self workStatusInUserDefaults];
    
    [self tableRefreshCreate];
    [self NETWORK_checkIsLogin];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessType:) name:@"pushMessType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentButtonHiddenYES) name:@"listButtonHiddenYES" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentButtonHiddenNO) name:@"listButtonHiddenNO" object:nil];
}

#pragma mark - 上拉加载下拉刷新
// 在tableview上添加控件
- (void)tableRefreshCreate
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.taskTable.mj_footer = footer;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadCurrentData];
    }];
    self.taskTable.mj_header = header;
}

// 上拉加载
- (void)loadMoreData
{
    self.selectPageNumber++;
    [self.taskTable.mj_footer beginRefreshing];
    [self NETWORK_requestTask];
}

// 下拉刷新
- (void)reloadCurrentData
{
    self.selectPageNumber = 1;
    [self.taskTable.mj_header beginRefreshing];
    [self NETWORK_requestTask];
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
    
    NSString *secondStr = seconds < 10 ? [NSString stringWithFormat:@"0%ld",(long)seconds] :[NSString stringWithFormat:@"%ld",(long)seconds];
    NSString *minStr    = mins < 10 ? [NSString stringWithFormat:@"0%ld",(long)mins] :[NSString stringWithFormat:@"%ld",(long)mins];
    NSString *hourStr   = hours < 10 ? [NSString stringWithFormat:@"0%ld",(long)hours] :[NSString stringWithFormat:@"%ld",(long)hours];
    string = [NSString stringWithFormat: @"%@:%@:%@",hourStr,minStr,secondStr];
    
    return string;
}

#pragma mark - 网络请求

// 刷新当前上班状态(登出)
- (void)NETWORK_waiterLogout
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"]|| waiterInfo.attendanceState == nil)
        return;
    
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
            DataManager* dataManager = [DataManager defaultInstance];
            DBWaiterInfor *witerInfo = [[DataManager defaultInstance] getWaiterInfor];
            witerInfo.attendanceState = @"0";
            //存储数据
            [dataManager saveContext];
            [self performSegueWithIdentifier:@"showLogin" sender:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"下班失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
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
        if(self.hud){
            [self.hud stopWMProgress];
            [self.hud removeFromSuperview];
        }
        [[RequestNetWork defaultManager]cancleAllRequest];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 刷新当前工作状态
- (void)NETWORK_reloadWorkStatus:(NSString *)workstate
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"]|| waiterInfo.attendanceState == nil)
        return;

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
        if ([datas[0] isEqualToString:@"0"])
        {
            // 状态设置成功
            if (_direction == NO) {
                _timer.paused = NO;
                _direction = YES;
                [_statusButton setTitle:@"暂停" forState:UIControlStateNormal];
                //将工作状态保存起来
                [SPUserDefaultsManger setBool:_timer.paused forKey:KIsWorkState];
                NSDate *date = [NSDate date];
                
                //如果第一次运行，将当前日期存入
                if (![SPUserDefaultsManger getValue:kStart]) {
                    [SPUserDefaultsManger setValue:date forKey:kStart];
                }
            }
            else
            {
                _timer.paused = YES;
                _direction = NO;
                [_statusButton setTitle:@"开始" forState:UIControlStateNormal];
                //将工作状态保存起来
                [SPUserDefaultsManger setBool:_timer.paused forKey:KIsWorkState];
                [SPUserDefaultsManger setValue:[NSString stringWithFormat:@"%ld",(long)_second] forKey:kPause];
                
                NSDate * da = (NSDate *)[SPUserDefaultsManger getValue:kStart];
                NSInteger inte = labs((NSInteger)(da.timeIntervalSinceNow)*60);
                [SPUserDefaultsManger setValue:[NSString stringWithFormat:@"%ld",(long)inte] forKey:@"abc"];
            }
        }
        else
        {
            // 状态设置失败
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"状态更改失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [[RequestNetWork defaultManager]registerDelegate:self];
            }];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [[RequestNetWork defaultManager]registerDelegate:self];
        }];
    }
}

// 服务员状态查询 是否登陆成功
- (void)NETWORK_checkIsLogin
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"] || waiterInfo.attendanceState == nil)
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
            if(self.hud){
                [self.hud stopWMProgress];
                [self.hud removeFromSuperview];
            }
            [[RequestNetWork defaultManager]cancleAllRequest];
            [self performSegueWithIdentifier:@"showLogin" sender:nil];
        }
        else
        {
            //有任务跳转到地图页面
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
            NSArray * array = [[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
            if(array.count > 0)
            {
                DBTaskList * waiterTask = array[0];
                NSLog(@"%@",waiterTask.category);
                if ([waiterTask.category isEqualToString:@"0"]) {
                    [self performSegueWithIdentifier:@"goTask" sender:nil];
                }
            }
        }
    }
    else
    {
        if(self.hud){
            [self.hud stopWMProgress];
            [self.hud removeFromSuperview];
        }
        [[RequestNetWork defaultManager]cancleAllRequest];
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
}

// 请求任务列表
- (void)NETWORK_requestTask
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"]|| waiterInfo.attendanceState == nil)
        return;
    NSLog(@"%@",waiterInfo.deviceId);
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"diviceId": waiterInfo.deviceId,
                                     @"deviceToken":waiterInfo.deviceToken,
                                     @"pageNo":[NSString stringWithFormat:@"%ld",(long)self.selectPageNumber],
                                     @"pageCount":@"10",
                                     @"taskStatus":@"2"}];
    self.requestTaskTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URI_WAITER_GETSERVICELIST
                                                                    params:params
                                                                withByUser:YES];
}

- (void)RESULT_requestTask:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    [self.taskTable.mj_header endRefreshing];
    if (datas.count <= 0 || datas == nil)
    {
        [self.taskTable.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.taskTable.mj_footer endRefreshing];
    }
    if (succeed)
    {
        if (self.selectPageNumber == 1)
        {
            for (DBTaskList * taskList in self.taskArray) {
                [[DataManager defaultInstance]deleteFromCoreData:taskList];
            }
            [[DataManager defaultInstance]saveContext];
            [self.taskArray removeAllObjects];
        }
        for (DBTaskList * task in datas) {
            [self.taskArray addObject:task];
        }
        [self.taskTable reloadData];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请求数据失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"点击刷新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[self reloadCurrentData];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

// 服务员抢单
-  (void)NETWORK_waiterGetIndent:(NSString *)taskCode
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"]|| waiterInfo.attendanceState == nil)
        return;
    NSLog(@"%@...%@...%@",waiterInfo.deviceId,waiterInfo.deviceToken,taskCode);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":waiterInfo.deviceId,
                                                                                   @"deviceToken":waiterInfo.deviceToken,
                                                                                   @"taskCode":taskCode}];
    self.waiterGetIndentTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                        webURL:@URI_WAITER_RUSHTASK
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_waiterGetIndent:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBTaskList * waiterTask = datas[0];
        DBWaiterInfor * waiterInfo = [[DataManager defaultInstance]getWaiterInfor];
        if ([datas[1][@"progreeInfo"][@"workNum"] isEqualToString:waiterInfo.workNum]) {
            [self.taskArray removeObject:waiterTask];
            waiterTask.waiterStatus = @"1";
            [[DataManager defaultInstance]saveContext];
            // 抢单到达服务成功  跳转
            if ([waiterTask.category isEqualToString:@"0"])
            {
                [self whenSkipUse];
                [self NETWORK_reloadIM];
            }
            // 抢单送餐服务成功
            else if ([waiterTask.category isEqualToString:@"4"])
            {
                // 送餐任务抢单成功后请求菜单列表
                [self NETWORK_menuDetailList:waiterTask.drOrderNo];
            }
#warning 订单类型确定后更新 会再补充
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"抢单失败" message:@"手速太慢了！已经被其他小伙伴抢走了" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //刷新列表
                [self refreshList];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [self whenSkipUse];
            }];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"抢单失败" message:@"手速太慢了！已经被其他小伙伴抢走了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //刷新列表
            [self refreshList];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self whenSkipUse];
        }];
    }
}

// 请求菜单列表
- (void)NETWORK_menuDetailList:(NSString *)drOrderNo
{
    self.foodPresentList = drOrderNo;
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"orderNoList":drOrderNo}];
    self.menuDetailListTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                       webURL:@URI_WAITER_REPASTORDERS
                                                                       params:params
                                                                   withByUser:YES];
}

- (void)RESULT_menuDetailList:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        [self whenSkipUse];
        [self performSegueWithIdentifier:@"goMenu" sender:nil];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"抢单失败" message:@"手速太慢了！已经被其他小伙伴抢走了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self refreshList];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//拿到userID
- (void)NETWORK_reloadIM
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    DBTaskList * waiterTask = [[[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil] lastObject];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"taskCode":waiterTask.taskCode}];
    self.reloadIMTask = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                  webURL:@URL_ACHIEVE_USERID
                                                                  params:dic
                                                              withByUser:YES];
}
- (void)RESULT_reloadIM:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed) {
        if (datas.count > 0) {
            self.isPage = NO;
            [self performSegueWithIdentifier:@"goTask" sender:nil];
        }
    }
    else
    {
        NSLog(@"请求失败");
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
    else if (task == self.waiterGetIndentTask)
    {
        [self RESULT_waiterGetIndent:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.reloadIMTask)
    {
        [self RESULT_reloadIM:YES withResponseCode:code withMessage:msg withDatas:datas];
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
    else if (task == self.waiterGetIndentTask)
    {
        [self RESULT_waiterGetIndent:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.reloadIMTask)
    {
        [self RESULT_reloadIM:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - 按钮点击方法
// 工作状态切换按钮
- (IBAction)workingStatus:(UIButton *)sender
{
    if (_direction == NO) {
        // 修改当前状态为上班
        [self NETWORK_reloadWorkStatus:@"1"];
    }
    else
    {
        // 修改当前状态为下班
        [self NETWORK_reloadWorkStatus:@"0"];
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

- (void)presentButtonHiddenYES
{
    self.navigationItem.rightBarButtonItem = self.presentButton;
}

- (void)presentButtonHiddenNO
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)obtainTask:(id)sender
{
#pragma 临时调试跳转
//    [self performSegueWithIdentifier:@"goTask" sender:nil];
    if (self.taskArray.count <= 0 ||self.taskArray == nil) {
        return;
    }
    DBTaskList * taskList = (DBTaskList *)self.taskArray[self.selectedIndex - 2];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"抢单" message:@"确认要抢该订单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self NETWORK_waiterGetIndent:taskList.taskCode];
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        [[RequestNetWork defaultManager]registerDelegate:self];
    }];
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
    DBTaskList * taskList = self.taskArray[indexPath.row - 2];
    if ([taskList.category isEqualToString:@"0"])
    {
        cell.taskName.text = taskList.taskCode;
    }
    else
    {
        cell.taskName.text = taskList.taskCode;
    }
    cell.taskContent.text = taskList.userMessageInfo;
    cell.taskAddress.text = [NSString stringWithFormat:@"位置：%@",taskList.userLocationDesc];
    cell.taskTime.text = [NSString stringWithFormat:@"时间：%@",taskList.timeLimit];
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
    TaskCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    cell.taskContent.hidden = YES;
    cell.taskAddress.hidden = YES;
    cell.taskTime.hidden = YES;
    TaskCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.taskContent.hidden = NO;
    newCell.taskAddress.hidden = NO;
    newCell.taskTime.hidden = NO;
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
    NSInteger firstRow = ((scrollView.contentOffset.y + 1) * 8 / self.taskTable.frame.size.height);
    if (firstRow < 0) firstRow = 0;
    if (self.taskArray.count > 0) {
        TaskCell * cell = [self.taskTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        cell.taskContent.hidden = YES;
        cell.taskAddress.hidden = YES;
        cell.taskTime.hidden = YES;
        if (firstRow + 2 > self.taskArray.count + 1) {
            firstRow = self.taskArray.count - 1;
        }
        TaskCell * newCell = [self.taskTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:firstRow + 2 inSection:0]];
        newCell.taskContent.hidden = NO;
        newCell.taskAddress.hidden = NO;
        newCell.taskTime.hidden = NO;
        self.selectedIndex = firstRow + 2;
    }
}

#pragma mark - UIAlertView / UIActionSheet delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_OFFWORK && buttonIndex == 1)
    {
        [self NETWORK_waiterLogout];
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

//传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goTask"]) //"goTask"是SEGUE连线的标识
    { 
//        id theSegue = segue.destinationViewController;
//        [theSegue setValue:sender forKey:@"getStrDate"];
    }
}

- (void)dealloc
{
    if(self.hud)
    {
        [self.hud stopWMProgress];
        [self.hud removeFromSuperview];
    }
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}
#pragma mark - 接收通知
//通知中的方法
- (void)pushMessType:(NSNotification*)notification
{
    //每次收到新任务消息推送的时候，都刷新tableview，
    [self refreshList];
}

#pragma  mark - function
- (void)refreshList
{
    //刷新列表
    if (self.isPage == YES) {
        if ([[NSString stringWithFormat:@"%@",[SPUserDefaultsManger getValue:KIsAllowRefresh]] isEqualToString:@"1"]) {
            if ([[[[DataManager defaultInstance]getWaiterInfor] attendanceState]isEqualToString:@"1"]) {
                self.selectPageNumber = 1;
                [self NETWORK_requestTask];
            }
        }
    }
}
- (void)workStatusInUserDefaults
{
    [SPUserDefaultsManger setValue:@"1" forKey:KIsAllowRefresh];
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTime)];
    _second = 0;
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.countdownLabel.font = [UIFont fontWithName:@"Verdana" size:34];
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
}
@end
