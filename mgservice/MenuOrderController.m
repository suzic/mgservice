//
//  MenuOrderController.m
//  mgservice
//
//  Created by 罗禹 on 16/3/25.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MenuOrderController.h"
#import "MenuItemCell.h"
#import "MenuSectionCell.h"

@interface MenuOrderController () <UITableViewDataSource, UITableViewDelegate, MenuItemCellDelegate>

@property (retain, nonatomic) NSMutableArray *menuArray;
@property (assign, nonatomic) NSInteger expandSectionIndex;
@property (retain, nonatomic) UIButton *expandCompleteButton;
@property (assign, nonatomic) NSInteger selectButtonTag;

@property (nonatomic,strong) NSURLSessionTask * waiterFinishTaskTask; // 服务员提交任务的请求标识·
@property (nonatomic,strong) NSURLSessionTask * menuDetailListTask; // 菜单详情

@end

@implementation MenuOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.expandSectionIndex = NSNotFound;
    self.selectButtonTag = NSNotFound;
    self.menuArray = [NSMutableArray array];
    [self loadDBTaskData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskCode = 1"];
    NSArray * listArray = [[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (listArray.count > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listButtonHiddenYES" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listButtonHiddenNO" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)loadDBTaskData
{
    if (_menuArray.count > 0) {
        [_menuArray removeAllObjects];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    NSArray * array = [[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    for (DBTaskList * waiterTask in array) {
        NSMutableArray * taskContent = [NSMutableArray array];
        // [self NETWORK_menuDetailList:waiterTask.drOrderNo];
        [taskContent addObject:waiterTask.userLocationDesc];
        [taskContent addObject:waiterTask.timeLimit];
        [taskContent addObject:waiterTask.taskCode];
        NSArray * presentList = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
        [taskContent addObject:presentList];
        
        [self.menuArray addObject:taskContent];
    }
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setupDemoData
//{
//    for (int i = 0; i < 5; i++)
//    {
//        [self.menuArray addObject:@[[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名A", @"count":@"1", @"price":@"122.00", @"ready":@"0"}],
//                                    [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名B", @"count":@"2", @"price":@"88.00", @"ready":@"0"}],
//                                    [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名C", @"count":@"1", @"price":@"52.00", @"ready":@"0"}]]];
//    }
//    NSLog(@"\n%@",self.menuArray);
//}

- (NSMutableArray *)menuArray
{
    if (_menuArray == nil)
        _menuArray = [NSMutableArray arrayWithCapacity:5];
    return _menuArray;
}

#pragma mark - 网络请求
// 服务员提交完成任务
- (void)NETWORK_waiterFinishTask:(NSInteger)selectTask
{
    NSString * taskCode = self.menuArray[selectTask][2];
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    if ([waiterInfo.attendanceState isEqualToString:@"0"]|| waiterInfo.attendanceState == nil)
        return;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":waiterInfo.deviceId,
                                                                                   @"deviceToken":waiterInfo.deviceToken,
                                                                                   @"taskCode":taskCode}];
    self.waiterFinishTaskTask = [[RequestNetWork defaultManager]POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                        webURL:@URI_WAITER_FINISHTASK
                                                                        params:params
                                                                    withByUser:YES];
}

- (void)RESULT_waiterFinishTask:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBTaskList * waiterTask = datas[0];
        if ([waiterTask.status isEqualToString:@"1"])
        {
            // 提交完成成功   删除菜单表中已完成的数据
            for (DBWaiterPresentList * presentList in [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo]) {
                [[DataManager defaultInstance]deleteFromCoreData:presentList];
            }
            // 删除已接订单表中的的数据
            [[DataManager defaultInstance]deleteFromCoreData:waiterTask];
            [[DataManager defaultInstance]saveContext];
            [self.menuArray removeObject:waiterTask];
            // 删除后重置选中
            if (_expandSectionIndex == NSNotFound)
            {
                
            }
            else if (_selectButtonTag < _expandSectionIndex)
            {
                self.expandSectionIndex--;
            }
            else if (_selectButtonTag == _expandSectionIndex)
            {
                self.expandSectionIndex = NSNotFound;
            }
            [self loadDBTaskData];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交失败" message:@"请重新提交完成订单" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [self whenSkipUse];
            }];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self whenSkipUse];
        }];
    }
}

// 请求菜单详情
- (void)NETWORK_menuDetailList:(NSString *)drOrderNo
{
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
        
    }
    else
    {

    }
}


#pragma mark - RequestNetWorkDelegate 协议方法

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    [super pushResponseResultsFinished:task responseCode:code withMessage:msg andData:datas];
    if (task == self.waiterFinishTaskTask)
    {
        [self RESULT_waiterFinishTask:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
    else if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [super pushResponseResultsFailed:task responseCode:code withMessage:msg];
    if (task == self.waiterFinishTaskTask)
    {
        [self RESULT_waiterFinishTask:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
    else if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *menuItems = [self.menuArray[section] lastObject];
    return self.expandSectionIndex == section ? menuItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    DBWaiterPresentList * present = [self.menuArray[indexPath.section] lastObject][indexPath.row];
    
    cell.oneMenuName = present;
    cell.menuName.text = [NSString stringWithFormat:@"%@ X %@", present.menuName, present.count];
    cell.menuPrice.text = [NSString stringWithFormat:@"¥ %@", present.sellPrice];
    cell.menuReady.on = [present.ready isEqualToString:@"1"] ? YES : NO;
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.menuArray.count <= 0)
        return nil;
    
    MenuSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menuHeader"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
    for (UIGestureRecognizer *gs in gestures)
        [cell.contentView removeGestureRecognizer:gs];
    [cell.contentView addGestureRecognizer:tap];
    cell.contentView.tag = section;
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.locationDec.text = self.menuArray[section][0];
    cell.limitTime.text = [self.menuArray[section][1] componentsSeparatedByString:@" "][1];
    //cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话：%@",[[self.menuArray[section] lastObject][0] targetTelephone]];
    cell.readyInfo.tag = section + 100;
    [cell.readyInfo addTarget:self action:@selector(completeReady:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *menuInfo = [self.menuArray[section]lastObject];
    NSInteger totalCount = menuInfo.count;
    NSInteger completeCount = 0;
    for (DBWaiterPresentList * list in menuInfo)
        if ([list.ready isEqualToString:@"1"]) completeCount++;
    if (completeCount < totalCount)
    {
        [cell.readyInfo setBackgroundColor:[UIColor grayColor]];
        [cell.readyInfo setTitle:[NSString stringWithFormat:@"%ld / %ld 完成", (long)completeCount, (long)totalCount] forState:UIControlStateNormal];
    }
    else
    {
        [cell.readyInfo setBackgroundColor:[UIColor blueColor]];
        [cell.readyInfo setTitle:@"完成" forState:UIControlStateNormal];
    }
    if (section == self.expandSectionIndex)
    {
        self.expandCompleteButton = cell.readyInfo;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell.contentView;
}

- (void)completeReady:(UIButton *)sender
{
    NSArray *menuInfo = [self.menuArray[sender.tag - 100]lastObject];
    NSInteger totalCount = menuInfo.count;
    NSInteger completeCount = 0;
    for (DBWaiterPresentList * present in menuInfo)
        if ([present.ready isEqualToString:@"1"]) completeCount++;
    if (completeCount < totalCount)
    {
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交完成" message:@"确定要完成该订单？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectButtonTag = sender.tag - 100;
            [self NETWORK_waiterFinishTask:sender.tag - 100];
        }];
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
            [[RequestNetWork defaultManager]registerDelegate:self];
        }];
    }
}

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
    
    // 执行更新
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)readyStatusChanged:(MenuItemCell *)cell
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"menuName = %@ and orderNo = %@", cell.oneMenuName.menuName,cell.oneMenuName.orderNo];
    NSArray *result = [[DataManager defaultInstance] arrayFromCoreData:@"DBWaiterPresentList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    DBWaiterPresentList * presentList = result[0];
    presentList.ready = cell.menuReady.on == YES ? @"1" : @"0";
    [[DataManager defaultInstance]saveContext];
    
    NSArray *menuInfo = [self.menuArray[self.expandSectionIndex]lastObject];
    NSInteger totalCount = menuInfo.count;
    NSInteger completeCount = 0;
    for (DBWaiterPresentList * list in menuInfo)
        if ([list.ready isEqualToString:@"1"]) completeCount++;
    if (completeCount < totalCount)
    {
        [self.expandCompleteButton setBackgroundColor:[UIColor grayColor]];
        [self.expandCompleteButton setTitle:[NSString stringWithFormat:@"%ld / %ld 完成", (long)completeCount, (long)totalCount] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.expandCompleteButton setBackgroundColor:[UIColor blueColor]];
        [self.expandCompleteButton setTitle:@"完成" forState:UIControlStateNormal];
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


@end