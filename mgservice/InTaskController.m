//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"

@interface InTaskController ()

@property (strong, nonatomic) IBOutlet UIButton *myLocation;
@property (strong, nonatomic) IBOutlet UIButton *heLocation;
@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewHeight;
@property (strong, nonatomic) IBOutlet UITextField *inputChat;

@property (assign, nonatomic) BOOL showTalk;

@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myLocation.layer.cornerRadius = 15.0f;
    self.heLocation.layer.cornerRadius = 15.0f;
    //self.navigationItem.hidesBackButton = YES;
    
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewHeight.constant = self.view.frame.size.height - 64;
    self.showTalk = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowTalk:(BOOL)showTalk
{
    if (_showTalk == showTalk)
        return;
    _showTalk = showTalk;
    
    CGRect showHistoryRect = CGRectMake(0, self.view.frame.size.height - self.chatHistoryView.frame.size.height, self.chatHistoryView.frame.size.width, self.chatHistoryView.frame.size.height);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.chatHistoryView.frame.size.width, self.chatHistoryView.frame.size.height);
    [self.chatHistoryView setFrame:showTalk ? hideHistoryRect : showHistoryRect];
    [UIView animateWithDuration:0.5f animations:^{
        [self.chatHistoryView setFrame:showTalk ? showHistoryRect : hideHistoryRect];
    }];
}

- (IBAction)swithTalk:(id)sender
{
    self.showTalk = !self.showTalk;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
