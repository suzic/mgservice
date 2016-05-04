//
//  MainViewController.h
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (assign, nonatomic) BOOL direction;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *presentButton;
@property (assign,nonatomic) NSInteger second;

@property (nonatomic, strong) CADisplayLink * timer;//定时器
@end
