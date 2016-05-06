//
//  NgrmapViewController.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/10/19.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <Nagrand/Nagrand.h>

@class InTaskController;

@interface NgrmapViewController : NGRMapViewController

@property (retain, nonatomic) InTaskController *intaskController;

- (void)showMsgView:(BOOL)show;

@end
