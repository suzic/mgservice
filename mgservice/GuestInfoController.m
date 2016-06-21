//
//  GuestInfoController.m
//  mgservice
//
//  Created by sjlh on 16/6/16.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "GuestInfoController.h"
#import "MainViewController.h"
#import "GuestInfoScanningBeforeCell.h"
#import "GuestInfoCell.h"
#import "SelectInfoBeforeCell.h"
#import "SelectInfoCell.h"
#import "ScanningView.h"
@interface GuestInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@property (nonatomic,strong)NSString * roomNumberStr;
@property (nonatomic,strong)NSString * startTimeStr;
@property (nonatomic,strong)NSString * endTimeStr;
@end

@implementation GuestInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.showInfor = 1;
    self.showSelectInfor = 1;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    self.dataSourceArray = [[NSMutableArray alloc]initWithCapacity:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInforAction:) name:@"showInforAction" object:nil];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = 1,j = 1;
    if (indexPath.section == 0)
    {
        if (self.showInfor == 1) {
            GuestInfoScanningBeforeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GuestInfoScanningBeforeCell"];
            cell.deleteScanningInfo.userInteractionEnabled = NO;
            cell.deleteScanningInfo.alpha = 0.4;
            return cell;
        }
        else
        {
            GuestInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GuestInfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.phoneNumber.text = @"18610176014";
            return cell;
        }
    }else
    {
        if (self.showSelectInfor == 1)
        {
            SelectInfoBeforeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectInfoBeforeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            SelectInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectInfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.roomText.text = self.roomNumberStr;
            cell.startTime.text = self.startTimeStr;
            cell.endTime.text = self.endTimeStr;
            if (self.showInfor == 1) {
                cell.bindingButton.userInteractionEnabled = NO;
                cell.bindingButton.alpha=0.4;
            }
            else
            {
                cell.bindingButton.userInteractionEnabled = YES;
                cell.bindingButton.alpha=1;
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.height / 2;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.mainViewController.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 40);
    NSLog(@"%f",offset);
    if (offset >= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.mainViewController.view.frame;
            frame.origin.y -= offset;
            self.mainViewController.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.mainViewController.view.frame;
        frame.origin.y = 0.0;
        self.mainViewController.view.frame = frame;
    }];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)orderSelectButtonAction:(id)sender
{
    self.roomNumberStr = @"60601";
    self.startTimeStr = @"2016-06-02";
    self.endTimeStr = @"2016-06-06";
    [self.tableView reloadData];
}

//扫描按钮
- (IBAction)scanningButton:(id)sender
{
    ScanningView * scanVC = [[ScanningView alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

//查询按钮
- (IBAction)selectButtonAction:(id)sender
{
    self.showSelectInfor = 0;
    [self.tableView reloadData];
}

//清除扫描后的信息
- (IBAction)deleteScanningInfoButtonAction:(id)sender
{
    self.showInfor = 1;
    [self.tableView reloadData];
}


//清除查询信息
- (IBAction)deleteSelectInfo:(id)sender
{
    self.showSelectInfor = 1;
    [self.tableView reloadData];
}

//绑定
- (IBAction)bindingSelectButtonAction:(id)sender
{
    
}


//返回按钮
//- (IBAction)backMainVC:(id)sender
//{
//    self.roomNumberStr = nil;
//    self.startTimeStr = nil;
//    self.endTimeStr = nil;
//    self.mainViewController.scanning.hidden = NO;
//    self.mainViewController.InforView.hidden = YES;
//}

#pragma mark - 通知
-(void)showInforAction:(NSNotification*)notification {
    //接受notification的userInfo，可以把参数存进此变量
    self.showInfor = [[notification.userInfo objectForKey:@"showInfor"] boolValue];
    NSLog(@"%d",self.showInfor);
    [self.tableView reloadData];
}

@end
