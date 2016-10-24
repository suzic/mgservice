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

@interface MenuOrderController () <UITableViewDataSource, UITableViewDelegate, MenuItemCellDelegate,UIActionSheetDelegate>

@property (retain, nonatomic) NSMutableArray *menuArray;
@property (assign, nonatomic) NSInteger expandSectionIndex;
@property (retain, nonatomic) UIButton *expandCompleteButton;
@property (assign, nonatomic) NSInteger selectButtonTag;
@property (nonatomic,strong) NSString * phoneNumber;
@property (nonatomic,strong) NSURLSessionTask * waiterFinishTaskTask; // 服务员提交任务的请求标识·
@property (nonatomic,strong) NSURLSessionTask * menuDetailListTask; // 菜单详情
@property (nonatomic,strong) NSURLSessionTask * waiterCancelOrder; //服务员取消订单
@property (nonatomic,strong) DBTaskList * waiterTaskList;
@property (nonatomic,assign) BOOL isDeleteStatus;   //记录左划状态

@end

@implementation MenuOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isDeleteStatus = NO;
    [SPUserDefaultsManger setValue:@"0" forKey:KIsAllowRefresh];
    self.expandSectionIndex = NSNotFound;
    self.selectButtonTag = NSNotFound;
    self.menuArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderStatus:) name:@"OrderStatus" object:nil];
    [self loadDBTaskData];
    self.orderStatus = @"ongoing";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SPUserDefaultsManger setValue:@"1" forKey:KIsAllowRefresh];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
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
    if (self.menuArray.count > 0) {
        [self.menuArray removeAllObjects];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    NSArray * array = [[DataManager defaultInstance]arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    for (DBTaskList * waiterTask in array) {
//        NSMutableArray * taskContent = [NSMutableArray array];
//        // [self NETWORK_menuDetailList:waiterTask.drOrderNo];
//        [taskContent addObject:waiterTask.userLocationDesc];
//        [taskContent addObject:waiterTask.timeLimit];
//        [taskContent addObject:waiterTask.taskCode];
//        NSArray * presentList = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
//        [taskContent addObject:waiterTask];
        
        [self.menuArray addObject:waiterTask];
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
    DBTaskList * waiterTask = self.menuArray[selectTask];
    NSString * taskCode = waiterTask.taskCode;
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

// 服务员取消订餐
- (void)NETWORK_calcelOrder:(NSString *)taskCode
{
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":waiterInfo.deviceId,@"deviceToken":waiterInfo.deviceToken,@"taskCode":taskCode}];
    NSLog(@"%@",params);
    self.waiterCancelOrder = [[RequestNetWork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                       webURL:@URI_WAITER_CANCELORDER
                                                                       params:params
                                                                   withByUser:YES];
}

- (void)RESULT_waiterCancelOrder:(BOOL)succeed withResponseCode:(NSString *)code withMessage:(NSString *)msg withDatas:(NSMutableArray *)datas
{
    if (succeed)
    {
        DBTaskList * waiterTask = datas[0];
        if ([waiterTask.status isEqualToString:@"9"])
        {
            DBTaskList * waiterTask = datas[0];
            // 取消任务成功   删除菜单表中已取消的数据
            for (DBWaiterPresentList * presentList in [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo]) {
                [[DataManager defaultInstance]deleteFromCoreData:presentList];
            }
            // 删除已接订单表中的的数据
            [[DataManager defaultInstance]deleteFromCoreData:waiterTask];
            [[DataManager defaultInstance]saveContext];
            [self.menuArray removeObject:waiterTask];
            self.isDeleteStatus = NO;
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
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"取消失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self whenSkipUse];
        }];
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
    else if (task == self.waiterCancelOrder)
    {
        [self RESULT_waiterCancelOrder:YES withResponseCode:code withMessage:msg withDatas:datas];
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
    else if (task == self.waiterCancelOrder)
    {
        [self RESULT_waiterCancelOrder:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBTaskList * waiterTask = self.menuArray[section];
    NSArray *menuItems = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
    return self.expandSectionIndex == section ? menuItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    DBWaiterPresentList * present = [[DataManager defaultInstance]getPresentList:[self.menuArray[indexPath.section] drOrderNo]][indexPath.row];
    
    cell.oneMenuName = present;
    cell.menuName.text = [NSString stringWithFormat:@"%@", present.menuName];
    cell.menuPrice.text = [NSString stringWithFormat:@"¥ %@ X %@", present.sellPrice,present.count];
    cell.menuReady.on = [present.ready isEqualToString:@"1"] ? YES : NO;
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.menuArray.count <= 0)
        return nil;
    MenuSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menuHeader"];
    if ([self.orderStatus isEqualToString:@"complete"]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
        for (UIGestureRecognizer *gs in gestures)
            [cell.contentView removeGestureRecognizer:gs];
        [cell.contentView addGestureRecognizer:tap];
        cell.contentView.tag = section;
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        
        DBTaskList * waiterTask = self.menuArray[section];
        cell.locationDec.text = waiterTask.userLocationDesc;
        cell.limitTime.text = [waiterTask.timeLimit componentsSeparatedByString:@" "][1];
        NSArray * presentListArray = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
        if (presentListArray.count > 0) {
//            cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话：%@",[presentListArray[0] targetTelephone]];
            cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话：%@",@"11111111111"];
        }
        
//        [self fuwenbenLabel:cell.phoneNumber FontNumber:nil AndRange:NSMakeRange(0, 5) AndColor:[UIColor blackColor]];
        UITapGestureRecognizer * phoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneCall:)];
        [cell.phoneNumber addGestureRecognizer:phoneTap];
        
        NSString * startTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverStartTime]];
        NSString * endTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverEndTime]];
        NSString * separatedstartTime= [startTime substringFromIndex:5];
        NSString * separatedEndTime= [endTime componentsSeparatedByString:@" "][1];
        cell.deliverStartAndEndTime.text = [NSString stringWithFormat:@"要求送达时间：%@ - %@",separatedstartTime,separatedEndTime];
        cell.menuOrderMoney.text = [NSString stringWithFormat:@"总额：￥ %@",[presentListArray[0] menuOrderMoney]];
        [cell.menuOrderMoney sizeToFit];
        cell.readyInfo.tag = section + 100;
        [cell.readyInfo addTarget:self action:@selector(completeReady:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.readyInfo.hidden = YES;
        if (section == self.expandSectionIndex)
        {
            self.expandCompleteButton = cell.readyInfo;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHeader:)];
        [cell.contentView addGestureRecognizer:pan];
        
        cell.deleteLabel.tag = section;
        UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [cell.deleteLabel addGestureRecognizer:tapImage];
        
        return cell.contentView;
    }
    if ([self.orderStatus isEqualToString:@"ongoing"])
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
        for (UIGestureRecognizer *gs in gestures)
            [cell.contentView removeGestureRecognizer:gs];
        [cell.contentView addGestureRecognizer:tap];
        cell.contentView.tag = section;
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        
        DBTaskList * waiterTask = self.menuArray[section];
        cell.locationDec.text = waiterTask.userLocationDesc;
        cell.limitTime.text = [waiterTask.timeLimit componentsSeparatedByString:@" "][1];
        NSArray * presentListArray = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
        if (presentListArray.count > 0) {
            cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话：%@",[presentListArray[0] targetTelephone]];
        }
        
//        [self fuwenbenLabel:cell.phoneNumber FontNumber:nil AndRange:NSMakeRange(0, 5) AndColor:[UIColor blackColor]];
        UITapGestureRecognizer * phoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneCall:)];
        [cell.phoneNumber addGestureRecognizer:phoneTap];
        
//        NSString * startTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverStartTime]];
//        NSString * endTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverEndTime]];
//        NSString * separatedstartTime= [startTime substringFromIndex:5];
//        NSString * separatedEndTime= [endTime componentsSeparatedByString:@" "][1];
//        cell.deliverStartAndEndTime.text = [NSString stringWithFormat:@"要求送达时间：%@ - %@",separatedstartTime,separatedEndTime];
//        cell.menuOrderMoney.text = [NSString stringWithFormat:@"总额：￥ %@",[presentListArray[0] menuOrderMoney]];
        [cell.menuOrderMoney sizeToFit];
        cell.readyInfo.tag = section + 100;
        [cell.readyInfo addTarget:self action:@selector(completeReady:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger totalCount = presentListArray.count;
        NSInteger completeCount = 0;
        for (DBWaiterPresentList * list in presentListArray)
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
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHeader:)];
        [cell.contentView addGestureRecognizer:pan];
        
        cell.deleteLabel.tag = section;
        UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [cell.deleteLabel addGestureRecognizer:tapImage];
        
        return cell.contentView;
    }
    else
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        NSArray *gestures = [NSArray arrayWithArray:cell.contentView.gestureRecognizers];
        for (UIGestureRecognizer *gs in gestures)
            [cell.contentView removeGestureRecognizer:gs];
        [cell.contentView addGestureRecognizer:tap];
        cell.contentView.tag = section;
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        
        DBTaskList * waiterTask = self.menuArray[section];
        cell.locationDec.text = waiterTask.userLocationDesc;
        cell.limitTime.text = [waiterTask.timeLimit componentsSeparatedByString:@" "][1];
        NSArray * presentListArray = [[DataManager defaultInstance]getPresentList:waiterTask.drOrderNo];
        if (presentListArray.count > 0) {
            cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话：%@",[presentListArray[0] targetTelephone]];
        }
        
        [self fuwenbenLabel:cell.phoneNumber FontNumber:nil AndRange:NSMakeRange(0, 5) AndColor:[UIColor blackColor]];
        UITapGestureRecognizer * phoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneCall:)];
        [cell.phoneNumber addGestureRecognizer:phoneTap];
        
//        NSString * startTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverStartTime]];
//        NSString * endTime = [NSString stringWithFormat:@"%@",[presentListArray[0] deliverEndTime]];
//        NSString * separatedstartTime= [startTime substringFromIndex:5];
//        NSString * separatedEndTime= [endTime componentsSeparatedByString:@" "][1];
//        cell.deliverStartAndEndTime.text = [NSString stringWithFormat:@"要求送达时间：%@ - %@",separatedstartTime,separatedEndTime];
        cell.menuOrderMoney.text = [NSString stringWithFormat:@"总额：￥ %@",[presentListArray[0] menuOrderMoney]];
        [cell.menuOrderMoney sizeToFit];
        cell.readyInfo.tag = section + 100;
        [cell.readyInfo addTarget:self action:@selector(completeReady:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.readyInfo.hidden = YES;
        if (section == self.expandSectionIndex)
        {
            self.expandCompleteButton = cell.readyInfo;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHeader:)];
        [cell.contentView addGestureRecognizer:pan];
        
        cell.deleteLabel.tag = section;
        UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [cell.deleteLabel addGestureRecognizer:tapImage];
        
        return cell.contentView;
    }
}

- (void)panHeader:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.view];
    CGRect rect = pan.view.frame;

    pan.maximumNumberOfTouches = 1;
    pan.minimumNumberOfTouches = 1;

    if (pan.state == UIGestureRecognizerStateBegan)
    {
        if (pan.view.frame.origin.x >= 0)
        {
            self.isDeleteStatus = NO;
        }
        else
        {
            self.isDeleteStatus = YES;
        }
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.isDeleteStatus == NO)
        {
            if (rect.origin.x > 0)
            {
                rect.origin.x = 0;
                pan.view.frame = rect;
            }
            else if (rect.origin.x < 0)
            {
                rect.origin.x = point.x;
                pan.view.frame = rect;
            }
            else
            {
                if (point.x >= 0)
                {
                    rect.origin.x = 0;
                    pan.view.frame = rect;
                }
                else
                {
                    rect.origin.x = point.x;
                    pan.view.frame = rect;
                }
            }
        }
        else
        {
            if (rect.origin.x < -(kScreenWidth / 5))
            {
                rect.origin.x = -(kScreenWidth / 5);
                pan.view.frame = rect;
            }
            else if (rect.origin.x > -(kScreenWidth / 5))
            {
                rect.origin.x = -(kScreenWidth / 5) + point.x;
                if (-(kScreenWidth / 5) + point.x > 0)
                {
                    rect.origin.x = 0;
                }
                else
                {
                    rect.origin.x = -(kScreenWidth / 5) + point.x;
                }
                pan.view.frame = rect;
            }
            else
            {
                if (point.x < 0)
                {
                    rect.origin.x = -(kScreenWidth / 5);
                    pan.view.frame = rect;
                }
                else
                {
                    rect.origin.x = -(kScreenWidth / 5) + point.x;
                    pan.view.frame = rect;
                }
            }
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.isDeleteStatus == NO)
        {
            if (point.x < -kScreenWidth / 10)
            {
                rect.origin.x = -(kScreenWidth / 5);
                [UIView animateWithDuration:0.1 animations:^{
                    pan.view.frame = rect;
                }];
            }
            else
            {
                rect.origin.x = 0;
                [UIView animateWithDuration:0.1 animations:^{
                    pan.view.frame = rect;
                }];
            }
        }
        else
        {
            if (point.x > kScreenWidth / 10)
            {
                rect.origin.x = 0;
                [UIView animateWithDuration:0.1 animations:^{
                    pan.view.frame = rect;
                }];
            }
            else
            {
                rect.origin.x = -(kScreenWidth / 5);
                [UIView animateWithDuration:0.1 animations:^{
                    pan.view.frame = rect;
                }];
            }
        }
    }
    //    //如果左划，就让x坐标到-80
    //    if (point.x<0 && self.isDeleteStatus == NO) {
    //        self.isDeleteStatus = YES;
    //        [UIView animateWithDuration:0.4 animations:^{
    //            pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y);
    //            [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    //            CGRect rect = pan.view.frame;
    //            rect.origin.x = -kScreenWidth / 5;
    //            pan.view.frame = rect;
    //        }];
    //    }
    //    //如果右划，就让x坐标到0
    //    if (point.x > 0)
    //    {
    //        self.isDeleteStatus = NO;
    //        [UIView animateWithDuration:0.4 animations:^{
    //            pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y);
    //            [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    //            CGRect rect = pan.view.frame;
    //            rect.origin.x = 0;
    //            pan.view.frame = rect;
    //        }];
    //    }
}

- (void)tapLabel:(UITapGestureRecognizer *)tapLabel
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectButtonTag = tapLabel.view.tag - 100;
        [self NETWORK_calcelOrder:[self.menuArray [tapLabel.view.tag] taskCode]];
    }];
    [alert addAction:cancelAction];
    [alert addAction:determineAction];
    [self presentViewController:alert animated:YES completion:^{
        [[RequestNetWork defaultManager]registerDelegate:self];
    }];
}

- (void)completeReady:(UIButton *)sender
{
    NSArray *menuInfo = [[DataManager defaultInstance]getPresentList:[self.menuArray[sender.tag - 100] drOrderNo]];
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
    self.isDeleteStatus = NO;
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
    return 110;
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
    
    NSArray *menuInfo = [[DataManager defaultInstance]getPresentList:[self.menuArray[self.expandSectionIndex] drOrderNo]];
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

#pragma mark - 点击事件
- (void)phoneCall:(UITapGestureRecognizer *)tap
{
    UILabel * label = (UILabel*)tap.view;
    self.phoneNumber = [label.text componentsSeparatedByString:@"："][1];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneNumber, nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
    }
}

//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
//    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

#pragma mark - 通知
- (void)OrderStatus:(NSNotification *)notification
{
    NSLog(@"%@",[notification.userInfo objectForKey:@"OrderStatus"]);
    self.orderStatus = [notification.userInfo objectForKey:@"OrderStatus"];
    [self.tableView reloadData];
}
@end
