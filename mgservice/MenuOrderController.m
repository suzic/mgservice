//
//  MenuOrderController.m
//  mgservice
//
//  Created by 苏智 on 16/1/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MenuOrderController.h"
#import "MenuItemCell.h"
#import "MenuSectionCell.h"

@interface MenuOrderController () <UITableViewDataSource, UITableViewDelegate, MenuItemCellDelegate>

@property (retain, nonatomic) NSMutableArray *menuArray;
@property (assign, nonatomic) NSInteger expandSectionIndex;
@property (retain, nonatomic) UIButton *expandCompleteButton;

@end

@implementation MenuOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.expandSectionIndex = NSNotFound;
    [self setupDemoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDemoData
{
    for (int i = 0; i < 5; i++)
    {
        [self.menuArray addObject:@[[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名A", @"count":@"1", @"price":@"122.00", @"ready":@"0"}],
                                    [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名B", @"count":@"2", @"price":@"88.00", @"ready":@"0"}],
                                    [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"菜名C", @"count":@"1", @"price":@"52.00", @"ready":@"0"}]]];
    }
}

- (NSMutableArray *)menuArray
{
    if (_menuArray == nil)
        _menuArray = [NSMutableArray arrayWithCapacity:5];
    return _menuArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *menuItems = self.menuArray[section];
    return self.expandSectionIndex == section ? menuItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    NSArray *menuInfo = self.menuArray[indexPath.section];
    NSMutableDictionary *dic = menuInfo[indexPath.row];
    cell.menuData = dic;
    cell.menuName.text = [NSString stringWithFormat:@"%@ X %@", dic[@"name"], dic[@"count"]];
    cell.menuPrice.text = [NSString stringWithFormat:@"¥ %@", dic[@"price"]];
    cell.menuReady.on = [dic[@"ready"] isEqualToString:@"1"] ? YES : NO;
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

    NSArray *menuInfo = self.menuArray[section];
    NSInteger totalCount = menuInfo.count;
    NSInteger completeCount = 0;
    for (NSMutableDictionary *dic in menuInfo)
        if ([dic[@"ready"] isEqualToString:@"1"]) completeCount++;
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
        self.expandCompleteButton = cell.readyInfo;
    
    return cell.contentView;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)readyStatusChanged:(MenuItemCell *)cell
{
    cell.menuData[@"ready"] = cell.menuReady.on == YES ? @"1" : @"0";
    
    NSArray *menuInfo = self.menuArray[self.expandSectionIndex];
    NSInteger totalCount = menuInfo.count;
    NSInteger completeCount = 0;
    for (NSMutableDictionary *dic in menuInfo)
        if ([dic[@"ready"] isEqualToString:@"1"]) completeCount++;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
