//
//  MainViewController.h
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameViewController.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *presentButton;
@property (assign,nonatomic) NSInteger second;

@property (nonatomic, strong) CADisplayLink * timer;//定时器
@property (weak, nonatomic) IBOutlet UIButton *scanning;
@property (assign, nonatomic) BOOL showInfor;
@property (weak, nonatomic) IBOutlet UIView *InforView;
@property (strong, nonatomic) FrameViewController *frameController;
- (IBAction)canningAction:(id)sender;

@end
