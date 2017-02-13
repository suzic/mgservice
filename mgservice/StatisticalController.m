//
//  StatisticalController.m
//  mgservice
//
//  Created by wangyadong on 16/9/13.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "StatisticalController.h"
#import "HeaderCell.h"
#import "SubCell.h"
#import "InTaskController.h"
#import "GradingView.h"
#import "MenuDetailsViewController.h"
@interface StatisticalController ()<UITableViewDelegate,UITableViewDataSource,RequestNetWorkDelegate>
{
//    NSMutableArray * openedInSectionArr;
}
// 工作时间相关
@property (weak, nonatomic) IBOutlet UIView *workTimeView;      // 工作相关控件View
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;    // 显示日期
@property (weak, nonatomic) IBOutlet UILabel *upWorkTimeLabel;  // 上班时间
@property (weak, nonatomic) IBOutlet UILabel *downWorkTimeLabel;// 下班时间
@property (weak, nonatomic) IBOutlet UILabel *workHoursLabel;   // 工作时长

@property (weak, nonatomic) IBOutlet UIView *buttonView;        //下面两个按钮的容器View
@property (weak, nonatomic) IBOutlet UIButton *completeButton;  //已完成按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    //未完成按钮
@property (assign, nonatomic) BOOL isStatusButton;

@property (strong, nonatomic) NSMutableArray * openedInSectionArr;  //已完成任务统计的数组
@property (strong, nonatomic) NSMutableArray * cancelArr;           //已取消任务统计的数组

@property (nonatomic,assign) NSInteger selectPageNumber;            // 请求订单页数
@property (strong, nonatomic) NSMutableArray * taskInfo;            //通过任务编号，查询任务信息的数组

// tableview展开、收缩相关
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger expandSectionIndex;

// 网络请求
@property (nonatomic, strong) NSURLSessionTask * requestTaskStatistical;// 任务统计
@property (nonatomic, strong) NSURLSessionTask * reloadTaskStatus;      // 通过任务编号，获取任务信息
@end

@implementation StatisticalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //工作相关控件View
    self.workTimeView.layer.cornerRadius = 6.0f;
    self.workTimeView.layer.borderColor = [UIColor grayColor].CGColor;
    self.workTimeView.layer.borderWidth = 1.0f;
    self.workTimeView.layer.shadowRadius = 5.0;
    self.workTimeView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.workTimeView.layer.shadowOpacity = 0.8;
    
    //装按钮的View
    self.buttonView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.buttonView.layer.borderWidth = 1.0f;
    self.buttonView.layer.shadowRadius = 2.0;
    self.buttonView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.buttonView.layer.shadowOpacity = 0.2;
    
    self.isStatusButton = 0;//已完成按钮的状态
    
    self.expandSectionIndex = NSNotFound;
    
    self.openedInSectionArr = [[NSMutableArray alloc]init];
    self.cancelArr = [[NSMutableArray alloc]init];
    self.taskInfo = [[NSMutableArray alloc]init];
    
    //tableview添加刷新、加载
    [self tableRefreshCreate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RequestNetWork defaultManager]registerDelegate:self];

    NSString * dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"];
    NSLog(@"%@",dateTime);
    self.dateTimeLabel.text = dateTime.length == 0 ? @"请选择日期" : dateTime;
    
    self.selectPageNumber = 1;
    //清空数组，为了点了日期返回页面后，不重复添加数据
    [self.openedInSectionArr removeAllObjects];
    [self.cancelArr removeAllObjects];
    
    if (self.isStatusButton == 0)
        [self NETWORK_requestTaskStatistical:@"1"];
    else
        [self NETWORK_requestTaskStatistical:@"9"];
    
    
//    NSInteger openedInSectionArrCount = (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:@"openedInSectionArrCount"];
//    [self.completeButton setTitle:[NSString stringWithFormat:@"已完成（%ld）",openedInSectionArrCount] forState:UIControlStateNormal];
//    NSInteger cancelCount = (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:@"cancelArrCount"];
//    [self.cancelButton setTitle:[NSString stringWithFormat:@"已取消（%ld）",cancelCount] forState:UIControlStateNormal];
//    [self.tableView reloadData];
}

#pragma mark - 上拉加载下拉刷新
// 在tableview上添加控件
- (void)tableRefreshCreate
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self reloadCurrentData];
//    }];
//    self.tableView.mj_header = header;
}

// 上拉加载
- (void)loadMoreData
{
    self.selectPageNumber++;
    [self.tableView.mj_footer beginRefreshing];
    //如果切换至已完成，就请求已完成的数据
    if (self.isStatusButton == 0)
        [self NETWORK_requestTaskStatistical:@"1"];
    else
        [self NETWORK_requestTaskStatistical:@"9"];
}

// 下拉刷新
//- (void)reloadCurrentData
//{
//    self.selectPageNumber = 1;
//    [self.tableView.mj_header beginRefreshing];
//    [self NETWORK_requestTaskStatistical:@"1"];
//}

#pragma mark - tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //如果切换至已完成，就使用openedInSectionArr数组
    if (self.isStatusButton == 0) {
        return _openedInSectionArr.count;
    }
    else
    {
        return _cancelArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 判断section的展开收起状态
    if (self.isStatusButton == 0) {
        DBTaskStatisticalList * statistical = self.openedInSectionArr[section];
        if ([statistical.selectedState isEqualToString:@"1"])
        {
            return self.taskInfo.count;
        }
    }
    if (self.isStatusButton == 1) {
        DBTaskStatisticalList * statistical = self.cancelArr[section];
        if ([statistical.selectedState isEqualToString:@"1"])
        {
            return self.taskInfo.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubCell * cell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
    DBTaskStatisticalList * taskList = self.taskInfo[indexPath.row];
    cell.issuedTimeLabel.text = [NSString stringWithFormat:@"下单时间 %@",taskList.createTime];    //任务下单时间
    cell.acceptTimeLabel.text = [NSString stringWithFormat:@"接单时间 %@",taskList.acceptTime];     //任务领取时间
    
    //如果切换的是“已完成”订单，显示“完成时间” 否则显示“取消时间”
    if (self.isStatusButton == 0)
        cell.completeTimeLabel.text = [NSString stringWithFormat:@"完成时间 %@",taskList.finishTime];  //任务完成时间
    else
        cell.completeTimeLabel.text = [NSString stringWithFormat:@"取消时间 %@",taskList.cancelTime];
    NSLog(@"%@",taskList.category);
    //如果是呼叫任务
    if ([taskList.category isEqualToString:@"0"])
    {
        cell.taskTypeLabel.text = [NSString stringWithFormat:@"服务内容 %@",@"呼叫服务"];
        [cell.taskTypeButton setTitle:@"进入查看聊天记录" forState:UIControlStateNormal];
        cell.taskTypeButton.tag = indexPath.section+1000;
        cell.taskTypeLabel.textColor = [UIColor blackColor];
    }
    
    //如果是送餐任务
    if ([taskList.category isEqualToString:@"4"])
    {
        cell.taskTypeLabel.text = [NSString stringWithFormat:@"服务内容 %@",@"送餐服务"];
        [cell.taskTypeButton setTitle:@"进入查看菜单" forState:UIControlStateNormal];
//        cell.taskTypeLabel.textColor = [UIColor redColor];
        cell.taskTypeButton.tag = indexPath.section+10000;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    DBTaskStatisticalList * statistical;
    
    //如果切换的是“已完成”
    if (self.isStatusButton == 0)
    {
        statistical = self.openedInSectionArr[section];
    }
    else
    {
        statistical = self.cancelArr[section];
    }
    
    //如果是选中状态，就是灰色，否则是白色
    if ([statistical.selectedState isEqualToString:@"1"])
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    else
        cell.contentView.backgroundColor = [UIColor whiteColor];
    
    //如果statistical.category = 0 就是呼叫任务
    if ([statistical.category isEqualToString:@"0"])
    {
        cell.taskNameLabel.text = @"呼叫任务";
        cell.starView.rating = [statistical.score floatValue];
    }
    //如果statistical.category = 1 就是送餐任务
    if ([statistical.category isEqualToString:@"4"])
    {
        cell.taskNameLabel.text = @"送餐任务";
        cell.starView.hidden = YES;
    }

    
    cell.taskCode.text = statistical.taskCode;
    
    
    //点击统计列表时的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectedStateHeader:)];
    NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
    for (UIGestureRecognizer *gs in gestures)
        [cell.contentView removeGestureRecognizer:gs];
    [cell.contentView addGestureRecognizer:tap];
    cell.contentView.tag = section;
    return cell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

#pragma mark - 网络请求
// 任务统计
- (void)NETWORK_requestTaskStatistical:(NSString *)status
{
    /*
     输入参数：
     waiterId       服务员编号     string类型        必填项
     status     任务状态       string类型        0代表未完成   1代表已完成     9代表已取消 必填项
     startDate      任务开始时间    DateTime类型      必填项
     endDate        任务结束时间    DateTime类型      必填项
     pageNo         当前页码       int类型 非必填项    默认第一页
     pageCount      每页显示数量    int类型 非必填项    默认10条
     */
    DBWaiterInfor * waiterInfo = [[DataManager defaultInstance]getWaiterInfor];
    NSDate * dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"];
    NSString * startDate = [NSString stringWithFormat:@"%@ %@",dateTime,@"00:00:00"];
    NSString * endDate = [NSString stringWithFormat:@"%@ %@",dateTime,@"23:59:59"];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"waiterId": waiterInfo.waiterId,
                                     @"status":status,
                                     @"startDate":startDate,
                                     @"endDate":endDate,
                                     @"pageNo":[NSString stringWithFormat:@"%ld",self.selectPageNumber],
                                     @"pageCount":@10,
                                     }];
    self.requestTaskStatistical = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URL_TASKLIST
                                                                    params:params
                                                                withByUser:YES];
}

// 任务统计
- (void)RESULT_requestTaskStatistical:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    //结束上拉或下拉的动作
    [self.tableView.mj_header endRefreshing];
    if (datas.count <= 0 || datas == nil)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if (succeed)
    {
        if (datas.count > 0) {
            for (DBTaskStatisticalList * task in datas)
            {
                if (self.isStatusButton == 0)
                {
                    [self.openedInSectionArr addObject:task];
                    [[NSUserDefaults standardUserDefaults] setInteger:self.openedInSectionArr.count forKey:@"openedInSectionArrCount"];
                }else
                {
                    [self.cancelArr addObject:task];
                    [[NSUserDefaults standardUserDefaults] setInteger:self.cancelArr.count forKey:@"cancelArrCount"];
                }
            }
//            NSInteger openedInSectionArrCount = [[NSUserDefaults standardUserDefaults]integerForKey:@"openedInSectionArrCount"];
//            NSInteger cancelArrCount = [[NSUserDefaults standardUserDefaults]integerForKey:@"cancelArrCount"];
//            [self.completeButton setTitle:[NSString stringWithFormat:@"已完成（%ld）",openedInSectionArrCount] forState:UIControlStateNormal];
//            [self.cancelButton setTitle:[NSString stringWithFormat:@"已取消（%ld）",cancelArrCount] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
        else
        {
//            [self.cancelButton setTitle:[NSString stringWithFormat:@"已取消（%d）",0] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"任务统计数据请求失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.tableView reloadData];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//通过任务编号，获得任务信息
//- (void)NETWORK_TaskStatus:(NSString *)taskCode
//{
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
//                                   @{@"taskCode":taskCode}];//任务编号
//    self.reloadTaskStatus = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
//                                                                      webURL:@URI_WAITER_TASkSTATUS
//                                                                      params:params
//                                                                  withByUser:YES];
//}

//通过任务编号，获取任务信息
//- (void)RESULT_taskStatus:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
//{
//    if (succeed)
//    {
//        if (datas.count > 0) {
//            for (DBTaskStatisticalList * task in datas)
//            {
//                [self.taskInfo addObject:task];
//            }
//            [self.tableView reloadData];
//        }
//    }
//    else
//    {
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有网络" preferredStyle:1];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

#pragma mark - RequestNetWorkDelegate 代理方法

- (void)startRequest:(NSURLSessionTask *)task
{
    
}

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.requestTaskStatistical)
    {
        [self RESULT_requestTaskStatistical:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
//    if (task == self.reloadTaskStatus)
//    {
//        [self RESULT_taskStatus:YES withResponseCode:code withMessage:msg withDatas:datas];
//    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.requestTaskStatistical)
    {
        [self RESULT_requestTaskStatistical:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
//    if (task == self.reloadTaskStatus)
//    {
//        [self RESULT_taskStatus:NO withResponseCode:code withMessage:msg withDatas:nil];
//    }
}

#pragma mark - 点击事件

// header的点击事件，展开、收起的功能
- (void)tapSelectedStateHeader:(UITapGestureRecognizer *)gesture
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSInteger tapSection = gesture.view.tag;
    
    if (self.expandSectionIndex != NSNotFound)
        [indexSet addIndex:self.expandSectionIndex];
    
    if (tapSection == self.expandSectionIndex)
        self.expandSectionIndex = NSNotFound;
    else
        self.expandSectionIndex = tapSection;
    
    if (self.expandSectionIndex != NSNotFound)
        [indexSet addIndex:self.expandSectionIndex];
    
    DBTaskStatisticalList * statistical;
    if (self.isStatusButton == 0)
    {
        statistical = self.openedInSectionArr[tapSection];
    }
    if (self.isStatusButton == 1)
    {
        statistical = self.cancelArr[tapSection];
    }
    //如果当前行是未选中状态
    if ([statistical.selectedState isEqualToString:@"0"]) {
        //取消所有选中状态
        for (DBTaskStatisticalList * stat in self.openedInSectionArr)
        {
            stat.selectedState = @"0";
        }
        for (DBTaskStatisticalList * stat in self.cancelArr)
        {
            stat.selectedState = @"0";
        }
        //把这一行 变成选中状态
        statistical.selectedState = @"1";
        
        [self.taskInfo removeAllObjects];
        DBTaskStatisticalList * statisticalInfo = (DBTaskStatisticalList *)[[DataManager defaultInstance] findWaiterRushByTaskCode:statistical.taskCode];
        [self.taskInfo addObject:statisticalInfo];
    }
    else
    {
        //否则就是选中状态，改成未选中
        statistical.selectedState = @"0";
    }
    
    //    [self.tableView reloadData];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 进入任务页面按钮点击事件
- (IBAction)pushTaskPageButtonAction:(UIButton *)sender
{
    if (sender.tag <10000)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"进入聊天页面的功能暂未开发" preferredStyle:1];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if (sender.tag >= 10000) {
         //跳转到菜单列表
        NSString * menuCode ;
        if (self.isStatusButton == 0)
        {
            menuCode = [self.openedInSectionArr[sender.tag-10000] drOrderNo];
        }
        else
        {
            menuCode = [self.cancelArr[sender.tag-10000] drOrderNo];
        }
        [self whenSkipUse];
        [self performSegueWithIdentifier:@"pushMenuDetails" sender:menuCode];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushMenuDetails"])
    {
        MenuDetailsViewController * send = segue.destinationViewController;
        send.menuCode = sender;
    }
}

- (IBAction)completeButtonAction:(UIButton *)sender
{
    self.expandSectionIndex = NSNotFound;
    [self.openedInSectionArr removeAllObjects];
    self.completeButton.backgroundColor = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    self.isStatusButton = 0;
    self.selectPageNumber = 1;//每次点击“已完成”按钮的时候，请求第一页数据
    [self NETWORK_requestTaskStatistical:@"1"];
    [self.tableView reloadData];
}
- (IBAction)cancelButtonAction:(UIButton *)sender
{
    self.expandSectionIndex = NSNotFound;
    [self.cancelArr removeAllObjects];
    self.completeButton.backgroundColor = [UIColor whiteColor];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];//恶心绿
    self.isStatusButton = 1;
    self.selectPageNumber = 1;//每次点击“已取消”按钮的时候，请求第一页数据
    [self NETWORK_requestTaskStatistical:@"9"];
    [self.tableView reloadData];
}

- (void)whenSkipUse
{
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}

- (void)dealloc
{
    
    [[RequestNetWork defaultManager]cancleAllRequest];
    [[RequestNetWork defaultManager]removeDelegate:self];
}
@end
