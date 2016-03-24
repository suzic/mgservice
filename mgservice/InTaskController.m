//
//  InTaskController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "InTaskController.h"

@interface InTaskController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (strong, nonatomic) IBOutlet UIButton *myLocation;//我的位置
@property (strong, nonatomic) IBOutlet UIButton *heLocation;//他的位置
@property (strong, nonatomic) IBOutlet UIView *chatHistoryView;//聊天记录View
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewTop;//聊天记录视图上
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatHistoryViewBottom;//聊天记录视图下
@property (strong, nonatomic) IBOutlet UITextField *inputChat;//输入聊天
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMap;//显示地图按钮

@property (assign, nonatomic) BOOL showTalk;  //显示聊天页面

@end

@implementation InTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.myLocation.layer.cornerRadius = 15.0f;
    self.heLocation.layer.cornerRadius = 15.0f;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.chatHistoryViewTop.constant = self.view.frame.size.height - 124;
    self.chatHistoryViewBottom.constant = 60 - self.view.frame.size.height;
    self.chatHistoryView.backgroundColor = [UIColor grayColor];
    self.showTalk = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    return cell;
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

//显示聊天页面 yes弹出页面，并显示地图按钮
- (void)setShowTalk:(BOOL)showTalk
{
    if (_showTalk == showTalk)
        return;
    
    _showTalk = showTalk;
    self.navigationItem.rightBarButtonItem = showTalk ? self.showMap : nil;

    CGRect showHistoryRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 64);
//    [self.chatHistoryView setFrame:showTalk ? hideHistoryRect : showHistoryRect];
    [UIView animateWithDuration:0.5f animations:^{
        [self.chatHistoryView setFrame:showTalk ? showHistoryRect : hideHistoryRect];
    } completion:^(BOOL finished) {
        self.chatHistoryViewTop.constant = showTalk ? 0.0f : self.view.frame.size.height - 124;
        self.chatHistoryViewBottom.constant = showTalk ? 0.0f : 60 - self.view.frame.size.height;
        if (showTalk == NO){
            [self.inputChat resignFirstResponder];
        }
    }];
}

//这是一个按钮
- (IBAction)tapHistory:(id)sender
{
    NSLog(@"按钮");
    if ([self.inputChat isFirstResponder])
        [self.inputChat resignFirstResponder];
    else if (self.showTalk == NO)
        self.showTalk = YES;
}

//每次点地图按钮的时候执行这个。
- (IBAction)swithTalk:(id)sender
{
    self.showTalk = NO;
}

//这个是发送按钮
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

//键盘弹出时
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.showTalk)
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.chatHistoryViewBottom.constant = 280.0f;
        }];
    }
}

//键盘缩回时
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.chatHistoryViewBottom.constant = self.showTalk ? 0.0f : 60 - self.view.frame.size.height;
}

//点return按钮，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self.inputChat resignFirstResponder];
    return YES;
}
@end
