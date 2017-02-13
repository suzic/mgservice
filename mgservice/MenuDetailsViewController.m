//
//  MenuDetailsViewController.m
//  mgservice
//
//  Created by sjlh on 2016/11/17.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MenuDetailsViewController.h"
#import "MenuDetailsItemCell.h"
#import "MenuDetailsSectionCell.h"
@interface MenuDetailsViewController ()<UITableViewDataSource, UITableViewDelegate,RequestNetWorkDelegate>
@property (assign, nonatomic) NSInteger expandSectionIndex;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *menuArray;
@property (nonatomic, strong) NSURLSessionTask * menuDetailListTask;

@end

@implementation MenuDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.expandSectionIndex = NSNotFound;
    self.menuArray = [NSMutableArray arrayWithCapacity:5];
    NSLog(@"%@",self.menuCode);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RequestNetWork defaultManager]registerDelegate:self];
    [self NETWORK_menuDetailList:self.menuCode];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuDetailsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuDetailsItem"];
    DBWaiterPresentList * present = self.menuArray[indexPath.row];
    cell.oneMenuName = present;
    cell.menuName.text = [NSString stringWithFormat:@"%@", present.menuName];
    cell.menuPrice.text = [NSString stringWithFormat:@"¥ %@ X %@", present.sellPrice,present.count];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    MenuDetailsSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menuDetailsSection"];
    if (self.menuArray.count == 0)
        return nil;

    DBWaiterPresentList * present = self.menuArray[0];
    cell.locationDec.text = @"测试客房 12345";
    cell.phoneNumber.text = [NSString stringWithFormat:@"联系电话 %@",present.targetTelephone];
    NSString * startTime = [NSString stringWithFormat:@"%@",present.deliverStartTime];
    NSString * endTime = [NSString stringWithFormat:@"%@",present.deliverEndTime];
    NSString * separatedstartTime= [startTime substringFromIndex:5];
    NSString * separatedEndTime= [endTime componentsSeparatedByString:@" "][1];
    cell.deliverStartAndEndTime.text = [NSString stringWithFormat:@"要求送达时间 %@ - %@",separatedstartTime,separatedEndTime];
    cell.menuOrderMoney.text = [NSString stringWithFormat:@"总额 ￥ %@",present.menuOrderMoney];
    [cell.menuOrderMoney sizeToFit];

    return cell.contentView;
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

// 请求菜单详情
- (void)NETWORK_menuDetailList:(NSString *)drOrderNo
{
//    self.foodPresentList = drOrderNo;
    NSLog(@"%@",drOrderNo);
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
        if (datas.count >0)
        {
            for (DBWaiterPresentList * list in datas)
            {
                [self.menuArray addObject:list];
            }
            [self.tableView reloadData];
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"菜单详情获取失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:YES withResponseCode:code withMessage:msg withDatas:datas];
    }
}

- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.menuDetailListTask)
    {
        [self RESULT_menuDetailList:NO withResponseCode:code withMessage:msg withDatas:nil];
    }
}

- (void)startRequest:(NSURLSessionTask *)task
{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
