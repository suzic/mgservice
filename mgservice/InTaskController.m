//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"

@interface InTaskController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *myLocation;
@property (strong, nonatomic) IBOutlet UIButton *heLocation;
@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;
@property (strong, nonatomic) IBOutlet UITextField *inputChat;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMap;

@property (assign, nonatomic) BOOL showTalk;

@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myLocation.layer.cornerRadius = 15.0f;
    self.heLocation.layer.cornerRadius = 15.0f;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewBottom.constant = 60 - self.view.frame.size.height;
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
    self.navigationItem.rightBarButtonItem = showTalk ? self.showMap : nil;

    CGRect showHistoryRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.chatHistoryView setFrame:showTalk ? hideHistoryRect : showHistoryRect];
    [UIView animateWithDuration:0.5f animations:^{
        [self.chatHistoryView setFrame:showTalk ? showHistoryRect : hideHistoryRect];
    } completion:^(BOOL finished) {
        self.chatHistoryViewTop.constant = showTalk ? 0.0f : self.view.frame.size.height - 124;
        self.chatHistoryViewBottom.constant = showTalk ? 0.0f : 60 - self.view.frame.size.height;
        if (showTalk == NO)
            [self.inputChat resignFirstResponder];
    }];
}

- (IBAction)tapHistory:(id)sender
{
    if ([self.inputChat isFirstResponder])
        [self.inputChat resignFirstResponder];
    else if (self.showTalk == NO)
        self.showTalk = YES;
}

- (IBAction)swithTalk:(id)sender
{
    self.showTalk = NO;
}

- (IBAction)sendChat:(id)sender
{
    self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.showTalk)
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.chatHistoryViewBottom.constant = 250.0f;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.chatHistoryViewBottom.constant = self.showTalk ? 0.0f : 60 - self.view.frame.size.height;
}

@end
