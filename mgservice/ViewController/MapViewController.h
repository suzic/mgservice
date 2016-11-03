//
//  MapViewController.h
//  mgservice
//
//  Created by liuchao on 2016/11/3.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InTaskController;

@interface MapViewController : UIViewController

@property (retain, nonatomic) InTaskController *intaskController;

- (void)showMsgView:(BOOL)show;

@end
