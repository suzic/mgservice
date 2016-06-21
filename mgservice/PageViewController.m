//
//  PageViewController.m
//  mgservice
//
//  Created by sjlh on 16/6/7.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "PageViewController.h"
#import "MenuOrderController.h"
@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"任务列表";
    self.themeColor = [UIColor orangeColor];
    self.leftMenuTitle = @"进行中";
    self.rightMenuTitle = @"已完成";
    self.rightTwoTitle = @"已取消";
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.leftViewController  = [storyboard instantiateViewControllerWithIdentifier:@"menu"];//进行中的viewController
    self.rightViewController = [storyboard instantiateViewControllerWithIdentifier:@"menu"];//[CompleteViewController new];    //已完成的viewController
    self.rightTViewController = [storyboard instantiateViewControllerWithIdentifier:@"menu"];//[CancelViewController new];     //已取消的viewController
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
