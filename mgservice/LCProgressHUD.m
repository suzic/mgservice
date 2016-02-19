//
//  LCProgressHUD.m
//  mgmanager
//
//  Created by 刘超 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "LCProgressHUD.h"
// 获取屏幕的尺寸
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
@interface LCProgressHUD()
{
    CGRect _frame;
}

@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (assign,nonatomic) WMProgressStyle styleType;
@property (strong,nonatomic) NSString *titleStr;

@end


@implementation LCProgressHUD

- (id)initWithFrame:(CGRect)frame andStyle:(WMProgressStyle)styleType andTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.styleType = styleType;
        self.titleStr = title;
        [self createProgress];
    }
    return self;
}

- (void)createProgress
{
    //create backgroundView
    self.progressView = [[UIView alloc]initWithFrame:_frame];
    self.progressView.alpha = 0.01;
    self.progressView.backgroundColor = [UIColor blackColor];

    [self addSubview:_progressView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 110)];
    bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    bgView.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:0.7];
    bgView.layer.cornerRadius = 10.0f;
//    bgView.alpha = 0.65;
    [self addSubview:bgView];
    //activityView
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(bgView.frame.size.width/2, 40, 0, 0)];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [bgView addSubview:self.activityView];
    
    if (self.styleType == defaultStyle) {
        self.progressView.backgroundColor = [UIColor whiteColor];
        self.progressView.layer.cornerRadius = 8.0;

    }
    
    if (self.styleType == titleStyle) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,70, bgView.frame.size.width, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = self.titleStr;
        [bgView addSubview:titleLabel];
    }
}

- (void)startWMProgress
{
    [self.activityView startAnimating];
    self.hidden = NO;
}

- (void)stopWMProgress
{
    [self.activityView stopAnimating];
    
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
}


@end
