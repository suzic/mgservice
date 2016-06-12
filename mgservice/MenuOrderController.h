//
//  MenuOrderController.h
//  mgservice
//
//  Created by 罗禹 on 16/3/25.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "BaseNetWorkViewController.h"

@interface MenuOrderController : BaseNetWorkViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString * orderStatus;
@end
