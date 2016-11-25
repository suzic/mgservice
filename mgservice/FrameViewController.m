//
//  FrameViewController.m
//  mgservice
//
//  Created by chao liu on 16/11/23.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FrameViewController.h"
#import "MainViewController.h"
#import "InTaskController.h"

@interface FrameViewController ()

@property (weak, nonatomic) IBOutlet UIView *homeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskViewTopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskBottomConstraint;

@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) InTaskController *inTaskController;

@end

@implementation FrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inTaskView.hidden = YES;
    self.homeView.hidden = NO;
    self.inTaskViewTopConstraints.constant = kScreenHeight - 84;
    self.inTaskBottomConstraint.constant = 64 - kScreenHeight;
}

- (void)hiddenMainView:(BOOL)hidden
{
    if (self.inTaskView.hidden == NO) return;
    self.inTaskView.hidden = !hidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showMsgView:(BOOL)show
{
    //这里的rightBarButton是“收起”按钮，现在暂时改为“刷新”按钮，因此注释掉，将来改回来的时候，将注释代码解开即可。
    //    self.navigationItem.rightBarButtonItem = show ? self.intaskController.showMap : nil;
    CGRect showHistoryRect = CGRectMake(0, 64.0f, self.view.frame.size.width, kScreenHeight - 64.0f);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 64.0f, self.view.frame.size.width, kScreenHeight - 64.0f);
    [UIView animateWithDuration:0.25f animations:^{
        [self.inTaskView setFrame:show ? showHistoryRect : hideHistoryRect];
        self.inTaskViewTopConstraints.constant = show ? 44.0f : kScreenHeight - 84.0f;
        self.inTaskBottomConstraint.constant  = show ? 0 : 64 -kScreenHeight;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)FinishCurrentTaskAction
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"任务已完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.inTaskController NETWORK_reloadWorkStatusTask];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)reloadCurrentTask
{
    //点击刷新按钮后，即根据任务号，查询任务信息。
    [self.inTaskController NETWORK_TaskStatus];
    /*
     这里的代码是点击“收起”后的操作，现在暂时将“收起”改为“刷新”按钮，因此注释，以后改回来的时候解开注释即可。
     [self showMsgView:NO];
     [self.intaskController.conversationView.messageInputView resignFirstResponder];
     self.intaskController.showTalk = NO;
     [self.intaskController deallocInstantMessageing];
     [self.intaskController.conversation markConversationAsRead];
     self.intaskController.showMessageLabel = YES;
     self.intaskController.messageLabel.hidden = YES;
     */

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showMessage"])
    {
        self.inTaskController = (InTaskController *)[segue destinationViewController];
        self.inTaskController.frameController = self;
    }
    else if ([segue.identifier isEqualToString:@"showHome"])
    {
        UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
        self.mainController = (MainViewController *)[nav topViewController];
        self.mainController.frameController = self;
    }
}

@end
