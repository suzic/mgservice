//
//  BaseNetWorkViewController.m
//  mgservice
//
//  Created by 罗禹 on 16/3/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "BaseNetWorkViewController.h"

@interface BaseNetWorkViewController ()

@end

@implementation BaseNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RequestNetWork defaultManager] registerDelegate:self];
}

- (void)dealloc {
//    if (self.hud) {
//        [self.hud stopWMProgress];
//        [self.hud removeFromSuperview];
//    }
    [[RequestNetWork defaultManager] cancleAllRequest];
    [[RequestNetWork defaultManager] removeDelegate:self];
}

#pragma mark -  RequestNetWorkDelegate 协议方法

- (void)startRequest:(YWNetWork *)manager {
//    if (!self.hud) {
//        self.hud = [[LCProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
//                                            andStyle:titleStyle andTitle:@"正在加载...."];
//    }else{
//        [self.hud stopWMProgress];
//        [self.hud removeFromSuperview];
//        self.hud = [[LCProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
//                                            andStyle:titleStyle andTitle:@"正在加载...."];
//    }
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.window addSubview:self.hud];
//    [self.hud startWMProgress];
}

- (void)pushResponseResultsFinished:(YWNetWork *)manager responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas {
//    [self.hud stopWMProgress];
//    [self.hud removeFromSuperview];
}

- (void)pushResponseResultsFailed:(YWNetWork *)manager responseCode:(NSString *)code withMessage:(NSString *)msg {
//    [self.hud stopWMProgress];
//    [self.hud removeFromSuperview];
}

@end
