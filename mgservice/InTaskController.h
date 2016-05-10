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
@property (nonatomic,strong)  YWConversationViewController * conversationView;
@property (assign, nonatomic) BOOL showTalk;  //显示聊天页面
@property (nonatomic,strong) YWP2PConversation * conversation;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)deallocInstantMessageing;

//完成任务
- (void)NETWORK_reloadWorkStatusTask;

@end
