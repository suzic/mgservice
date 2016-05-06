//
//  InTaskController.h
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NgrmapViewController.h"

@interface InTaskController : UIViewController
@property (weak, nonatomic) NgrmapViewController *mapViewController;
@property (nonatomic,strong)NSString * getStrDate;
@property (assign, nonatomic) BOOL showMessageLabel;
@end
