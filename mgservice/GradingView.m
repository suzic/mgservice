//
//  GradingView.m
//  mgservice
//
//  Created by sjlh on 16/9/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "GradingView.h"
#import "InTaskController.h"
#import "MainViewController.h"

@interface GradingView()

@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, strong) InTaskController *inTask;
@property (nonatomic, strong) MainViewController *MainVC;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *taskContentString;
@property (nonatomic, strong) UIColor *contentColor;
@end

@implementation GradingView

- (id)initWithTaskType:(NSString *)taskType contentText:(NSString *)contentText color:(UIColor *)color
{
    self = [super init];
    
    if (self)
    {
//        self.taskType = taskType;
        self.titleString = taskType;
        self.taskContentString = contentText;
        self.contentColor = color;
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.8;
    self.userInteractionEnabled = YES;
    
    // 背景view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.userInteractionEnabled = YES;
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, kScreenWidth - 5, kScreenHeight/2);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 1;
    bgView.tag = 10001;
    [self addSubview:bgView];
    
    // 任务标题
    UILabel * taskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, bgView.frame.size.width - 20 , 44)];
    taskTitleLabel.text = self.titleString;
    taskTitleLabel.textAlignment = 1;
    taskTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    taskTitleLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:taskTitleLabel];
    
    // 任务内容
    UILabel * taskContent = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(taskTitleLabel.frame), bgView.frame.size.width - 40, bgView.frame.size.height - taskTitleLabel.frame.size.height - 10 - 44)];
    taskContent.text = self.taskContentString;
    taskContent.textColor = self.contentColor;
    taskContent.numberOfLines = 0;
    taskContent.font = [UIFont systemFontOfSize:18.0f];
    taskContent.textAlignment = 0;
    [bgView addSubview:taskContent];
    
    // 确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMaxY(bgView.bounds) - 44, bgView.frame.size.width, 44);
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
}

- (void)buttonAction:(UIButton *)btn
{
    //通知，回到主页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backMainViewController" object:nil];
    [self showGradingView:NO];
}

- (void)showGradingView:(BOOL)show
{
    if (show == YES)
    {
        self.hidden = NO;
        AppDelegate *appDelegate = [AppDelegate sharedDelegate];
        [appDelegate.window addSubview:self];
    }else
    {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    
}

@end
