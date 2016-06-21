//
//  GuestInfoController.h
//  mgservice
//
//  Created by sjlh on 16/6/16.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface GuestInfoController : UIViewController
@property (weak,nonatomic) MainViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL showInfor;
@property (assign, nonatomic) BOOL showSelectInfor;


@end
