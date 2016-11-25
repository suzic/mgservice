//
//  FrameViewController.h
//  mgservice
//
//  Created by chao liu on 16/11/23.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameViewController : UIViewController
- (void)hiddenMainView:(BOOL)hidden;
- (void)showMsgView:(BOOL)show;
- (void)FinishCurrentTaskAction;
- (void)reloadCurrentTask;
@property (weak, nonatomic) IBOutlet UIView *inTaskView;
@end
