//
//  LPPageViewMenu.m
//  LPPageViewController
//
//  Created by FineexMac on 16/1/28.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import "LPPageViewMenu.h"
#import "MenuOrderController.h"
@interface LPPageViewMenu ()
{
    __weak IBOutlet NSLayoutConstraint *widthConstraint;
    __weak IBOutlet UIButton *leftButton;
    __weak IBOutlet NSLayoutConstraint *lineWidth;
    
    __weak IBOutlet UIButton *rightButton;
    __weak IBOutlet UIView *animateView;
    __weak IBOutlet NSLayoutConstraint *animateViewLeadMargin;
    
    __weak IBOutlet UIButton *rightTwoButton;
    
}
@property (nonatomic,strong)MenuOrderController * menuOC;
@end

@implementation LPPageViewMenu

- (void)awakeFromNib
{
    //分割线
    lineWidth.constant = 0.5;
    //选择左边按钮
    leftButton.selected = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *nibName = NSStringFromClass([self class]);
        self = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    }
    return self;
}

#pragma mark - 动画
- (void)animateViewProgress:(CGFloat)progress
{
    if (progress>0 && progress<1) {
        animateViewLeadMargin.constant = progress * widthConstraint.constant;
    }
//    NSLog(@"%f",progress);
    if (progress >= 0.33) {
        [self selectMenuRightTwoButton];
    }
    if (progress >= 0.25) {
        [self selectMenuRightButton];
    }
    if (progress == 0 ) {
        [self selectMenuLeftButton];
    }
}

#pragma mark - 切换按钮
- (void)selectMenuLeftButton
{
    if (!leftButton.selected) {
        leftButton.selected = YES;
        rightButton.selected = NO;
        rightTwoButton.selected = NO;
    }
}

- (void)selectMenuRightButton
{
    if (!rightButton.selected) {
        rightButton.selected = YES;
        leftButton.selected = NO;
        rightTwoButton.selected = NO;
    }
}

- (void)selectMenuRightTwoButton
{
    if (!rightTwoButton.selected) {
        rightTwoButton.selected = YES;
        leftButton.selected = NO;
        rightButton.selected = NO;
    }
}

#pragma mark - 设置宽度
- (void)setWidth:(CGFloat)width
{
    _width = width;
    widthConstraint.constant = width;
}

#pragma mark - 界面
- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    if (leftButton) {
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [leftButton setTitle:leftTitle forState:UIControlStateHighlighted];
        [leftButton setTitle:leftTitle forState:UIControlStateSelected];
    }
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    if (rightButton) {
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [rightButton setTitle:rightTitle forState:UIControlStateHighlighted];
        [rightButton setTitle:rightTitle forState:UIControlStateSelected];
    }
}

- (void)setRightTwoTitle:(NSString *)rightTwoTitle
{
    _rightTwoTitle = rightTwoTitle;
    if (rightTwoButton) {
        [rightTwoButton setTitle:rightTwoTitle forState:UIControlStateNormal];
        [rightTwoButton setTitle:rightTwoTitle forState:UIControlStateHighlighted];
        [rightTwoButton setTitle:rightTwoTitle forState:UIControlStateSelected];
    }
}

- (void)setThemeColor:(UIColor *)themeColor
{
    if (themeColor) {
        _themeColor = themeColor;
        [leftButton setTitleColor:themeColor forState:UIControlStateSelected];
        [leftButton setTitleColor:[themeColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        
        [rightButton setTitleColor:themeColor forState:UIControlStateSelected];
        [rightButton setTitleColor:[themeColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        
        [rightTwoButton setTitleColor:themeColor forState:UIControlStateSelected];
        [rightTwoButton setTitleColor:[themeColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        animateView.backgroundColor = themeColor;
    }
}

#pragma mark - 事件
- (IBAction)leftButtonPressed:(UIButton *)sender {
    if (_scollView) [_scollView setContentOffset:CGPointZero animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"ongoing"}];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    if (_scollView) [_scollView setContentOffset:CGPointMake(_scollView.contentSize.width/3, 0) animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"complete"}];
}

- (IBAction)rightTwoButtonPressed:(id)sender {
    if (_scollView) [_scollView setContentOffset:CGPointMake(_scollView.contentSize.width/1.5, 0) animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"cancel"}];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com