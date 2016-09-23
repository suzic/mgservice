//
//  StatisticalController.m
//  mgservice
//
//  Created by sjlh on 16/9/13.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "StatisticalController.h"
#import "HeaderCell.h"
#import "SubCell.h"
@interface StatisticalController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * openedInSectionArr;
}
// 工作时间相关
@property (weak, nonatomic) IBOutlet UIView *workTimeView;      //工作相关控件View
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;    //显示日期
@property (weak, nonatomic) IBOutlet UILabel *upWorkTimeLabel;  //上班时间
@property (weak, nonatomic) IBOutlet UILabel *downWorkTimeLabel;//下班时间
@property (weak, nonatomic) IBOutlet UILabel *workHoursLabel;   //工作时长

@property (weak, nonatomic) IBOutlet UIView *buttonView;

// tableview展开、收缩相关
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger expandSectionIndex;
@property (nonatomic,assign) BOOL isDeleteStatus;


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
    
    self.expandSectionIndex = NSNotFound;
    self.isDeleteStatus = NO;
    
    // 每个section展开收起状态标识符
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"];
    self.dateTimeLabel.text = dateTime.length == 0 ? @"请选择日期" : dateTime;
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
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if ([openedInSectionArr[section] isEqualToString:@"1"])
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    else
        cell.contentView.backgroundColor = [UIColor whiteColor];
    
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

#pragma mark - 点击事件

// header的点击事件，展开、收起的功能
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
    
    if ([[openedInSectionArr objectAtIndex:gesture.view.tag] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:gesture.view.tag withObject:@"1"];
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:gesture.view.tag withObject:@"0"];
    }
    
    //    [self.tableView reloadData];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
