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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMap;

- (IBAction)tenMButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tenM;

/**
 * @abstract 添加用户位置到地图上
 */
- (void)addUserLocationImageInMap:(NSString *)mac;

- (void)showMsgView:(BOOL)show;
@end
