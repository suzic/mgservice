//
//  InTaskController.h
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameViewController.h"
#import "GradingView.h"

@interface InTaskController : UIViewController

@property (nonatomic,strong)NSString * getStrDate;
@property (assign, nonatomic) BOOL showMessageLabel;
@property (nonatomic,strong)  YWConversationViewController * conversationView;
@property (assign, nonatomic) BOOL showTalk;  //显示聊天页面
@property (nonatomic,strong) YWP2PConversation * conversation;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMap;//显示地图按钮
@property (weak, nonatomic) IBOutlet UIImageView *arrowUpAndDownImage;
@property (nonatomic,strong) DBTaskList * waiterTaskList;
@property (nonatomic, strong) FrameViewController *frameController;
- (void)deallocInstantMessageing;

//完成任务
- (void)NETWORK_reloadWorkStatusTask;

//
- (void)NETWORK_TaskStatus;
@end
