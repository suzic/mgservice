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
#import "PageViewController.h"
#import "GradingView.h"
@interface StatisticalController ()<UITableViewDelegate,UITableViewDataSource,RequestNetWorkDelegate>
{
    NSMutableArray * openedInSectionArr;
}
// 工作时间相关
@property (weak, nonatomic) IBOutlet UIView *workTimeView;      // 工作相关控件View
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;    // 显示日期
@property (weak, nonatomic) IBOutlet UILabel *upWorkTimeLabel;  // 上班时间
@property (weak, nonatomic) IBOutlet UILabel *downWorkTimeLabel;// 下班时间
@property (weak, nonatomic) IBOutlet UILabel *workHoursLabel;   // 工作时长

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


// tableview展开、收缩相关
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger expandSectionIndex;

// 网络请求
@property (nonatomic, strong) NSURLSessionTask * requestTaskStatistical;// 任务统计
@property (nonatomic,strong) LCProgressHUD * hud;
@end

@implementation StatisticalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[RequestNetWork defaultManager]registerDelegate:self];
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
    
    self.expandSectionIndex = NSNotFound;
    
    // 每个section展开收起状态标识符
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];
    
    //任务统计
    [self NETWORK_requestTaskStatistical];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"];
    self.dateTimeLabel.text = dateTime.length == 0 ? @"请选择日期" : dateTime;
    
    self.completeButton.backgroundColor = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];
    [self.completeButton setTitle:[NSString stringWithFormat:@"已完成（%ld）",openedInSectionArr.count] forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:[NSString stringWithFormat:@"已取消（%ld）",openedInSectionArr.count-7] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return openedInSectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 判断section的展开收起状态
    if ([[openedInSectionArr objectAtIndex:section] intValue] == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubCell * cell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
    if (indexPath.section == 2 || indexPath.section == 4) {
        [cell.taskTypeButton setTitle:@"进入查看菜单" forState:UIControlStateNormal];
        cell.taskTypeButton.tag = 1111;
        cell.taskTypeLabel.text = @"要求时间 20:10:00";
        cell.taskTypeLabel.textColor = [UIColor redColor];
    }
    else
    {
        [cell.taskTypeButton setTitle:@"进入查看聊天记录" forState:UIControlStateNormal];
        cell.taskTypeButton.tag = 0000;
        cell.taskTypeLabel.text = @"呼叫内容 呼叫到场咨询";
        cell.taskTypeLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if ([openedInSectionArr[section] isEqualToString:@"1"])
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    else
        cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (section == 2 || section == 4)
    {
        cell.taskNameLabel.text = @"送餐任务 - c00111222";
        cell.starView.rating = 2.0f;
    }
    else
    {
        cell.starView.rating = 4.0f;
    }
//    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
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
- (void)NETWORK_requestTaskStatistical
{
    /*
     输入参数：
     waiterId       服务员编号     string类型        必填项
     taskStatus     任务状态       string类型        0代表已完成   1代表已取消   必填项
     startDate      任务开始时间    DateTime类型      非必填项
     endDate        任务结束时间    DateTime类型      非必填项
     pageNo         当前页码       int类型 非必填项    默认第一页
     pageCount      每页显示数量    int类型 非必填项    默认10条
     */
    DBWaiterInfor * waiterInfo = [[DataManager defaultInstance]getWaiterInfor];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"waiterId": waiterInfo.waiterId,
                                     @"taskStatus":@"0",
                                     }];
    self.requestTaskStatistical = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URL_TASKSTATISTICAL
                                                                    params:params
                                                                withByUser:YES];
}

// 任务统计
- (void)RESULT_requestTaskStatistical:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    NSLog(@"%@",datas);
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
    if (task == self.requestTaskStatistical)
    {
        [self RESULT_requestTaskStatistical:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [self.hud stopWMProgress];
    [self.hud removeFromSuperview];
    if (task == self.requestTaskStatistical)
    {
        [self RESULT_requestTaskStatistical:NO withResponseCode:code withMessage:msg withDatas:nil];
        NSLog(@"%@",msg);
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
#pragma mark - 点击事件

// header的点击事件，展开、收起的功能
- (void)tapHeader:(UITapGestureRecognizer *)gesture
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
    
    //如果当前行是未选中状态
    if ([[openedInSectionArr objectAtIndex:gesture.view.tag] intValue] == 0) {
        //就把这一行 变成选中状态
        [openedInSectionArr replaceObjectAtIndex:gesture.view.tag withObject:@"1"];
    }
    else
    {
        //否则就是选中状态，改成未选中
        [openedInSectionArr replaceObjectAtIndex:gesture.view.tag withObject:@"0"];
    }
    
    //    [self.tableView reloadData];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 进入任务页面按钮点击事件
- (IBAction)pushTaskPageButtonAction:(UIButton *)sender
{
    if (sender.tag == 0000)
    {
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"进入聊天页面的功能暂未开发" preferredStyle:1];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
        NSString * task = @"呼叫任务（c00123）已完成";
        NSString * content = @"当您确定找到客人后即可标记呼叫任务（c00123）完成；\r 如果服务员移动离开客人超过10米距离，则该窗口自动消失（仍为未完成）。";
        GradingView * gradingView = [[GradingView alloc]initWithTaskType:@"您已距客人10米之内" contentText:content color:[UIColor grayColor]];
        [gradingView showGradingView:YES];
    }
    if (sender.tag == 1111) {
        // 跳转到任务列表
        PageViewController * pageVC = [[PageViewController alloc]init];
        [self.navigationController pushViewController:pageVC animated:YES];
    }
    
}
- (IBAction)completeButtonAction:(UIButton *)sender
{
    self.completeButton.backgroundColor = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];
    [self.completeButton setTitle:[NSString stringWithFormat:@"已完成（%ld）",openedInSectionArr.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
}
- (IBAction)cancelButtonAction:(UIButton *)sender
{
    self.completeButton.backgroundColor = [UIColor whiteColor];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];//恶心绿
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0",nil];
    [self.cancelButton setTitle:[NSString stringWithFormat:@"已取消（%ld）",openedInSectionArr.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

@end
