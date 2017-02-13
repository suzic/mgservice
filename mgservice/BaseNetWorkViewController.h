//
//  BaseNetWorkViewController.h
//  mgservice
//
//  Created by 罗禹 on 16/3/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestNetWork.h"
#import "MBProgressHUD.h"

@interface BaseNetWorkViewController : UIViewController <RequestNetWorkDelegate>

@property (nonatomic,strong) MBProgressHUD * hud;  //加载框

@end
