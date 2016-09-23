//
//  LPPageViewController.m
//  LPPageViewController
//
//  Created by FineexMac on 16/1/27.
//  Copyright © 2016年 LPiOS. All rights reserved.
//
//  作者GitHub主页 https://github.com/SwiftLiu
//  作者邮箱 1062014109@qq.com
//  下载链接 https://github.com/SwiftLiu/LPPageViewController.git

#import "LPPageViewController.h"
#import "LPPageViewMenu.h"

@interface LPPageViewController ()<UIScrollViewDelegate>
{
    LPPageViewMenu *menuView;
    UIScrollView *pageScrollView;
    
    dispatch_once_t onceToken;
}
@end

@implementation LPPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"任务列表";
    self.navigationController.navigationBar.translucent = NO;
    
    //滚动视图
    pageScrollView = [UIScrollView new];
    pageScrollView.delegate = self;
    pageScrollView.bounces = NO;
    pageScrollView.pagingEnabled = YES;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:pageScrollView];
    
    //菜单
    menuView = [LPPageViewMenu new];
    [self.view addSubview:menuView];
    menuView.scollView = pageScrollView;//关联（点击菜单视图左右按钮执行动画）
    
    //重设置(若在滚动视图和菜单初始化之前设置了以下属性，需要重新设置)
    [self setThemeColor:_themeColor];
    
    [self setLeftMenuTitle:_leftMenuTitle];
    [self setRightMenuTitle:_rightMenuTitle];
    [self setRightTwoMenuTitle:_rightTwoTitle];
    
    [self setLeftViewController:_leftViewController];
    [self setRightViewController:_rightViewController];
    [self setRightTViewController:_rightTViewController];
}

#pragma mark - 布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    dispatch_once(&onceToken, ^{
        CGFloat w = self.view.frame.size.width;
        menuView.width = w;
        CGFloat y = CGRectGetMaxY(menuView.frame);
        CGFloat h = self.view.frame.size.height - y;
        
        pageScrollView.frame = CGRectMake(0, y, w, h);
        pageScrollView.contentSize = CGSizeMake(w * 3, h);
        
        self.leftViewController.view.frame = CGRectMake(0, 0, w, h);
        self.rightViewController.view.frame = CGRectMake(w, 0, w, h);
        self.rightTViewController.view.frame = CGRectMake(w + w, 0, w, h);
    });
}


#pragma mark - 设置界面
- (void)setThemeColor:(UIColor *)themeColor
{
    if (themeColor) {
        _themeColor = themeColor;
        if (menuView) menuView.themeColor = themeColor;
    }
}

- (void)setLeftMenuTitle:(NSString *)leftMenuTitle
{
    if (leftMenuTitle) {
        _leftMenuTitle = leftMenuTitle;
        if (menuView) menuView.leftTitle = leftMenuTitle;
    }
}

- (void)setRightMenuTitle:(NSString *)rightMenuTitle
{
    if (rightMenuTitle) {
        _rightMenuTitle = rightMenuTitle;
        if (menuView) menuView.rightTitle = rightMenuTitle;
    }
}

- (void)setRightTwoMenuTitle:(NSString *)rightMenuTitle
{
    if (rightMenuTitle) {
        _rightMenuTitle = rightMenuTitle;
        if (menuView) menuView.rightTitle = rightMenuTitle;
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (leftViewController) {
        _leftViewController = leftViewController;
        if (pageScrollView) {
            [self addChildViewController:leftViewController];
            [pageScrollView addSubview:leftViewController.view];
        }
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (rightViewController) {
        _rightViewController = rightViewController;
        if (pageScrollView) {
            [self addChildViewController:rightViewController];
            [pageScrollView addSubview:rightViewController.view];
        }
    }
}

- (void)setRightTViewController:(UIViewController *)rightTViewController
{
    if (rightTViewController) {
        _rightTViewController = rightTViewController;
        if (pageScrollView) {
            [self addChildViewController:rightTViewController];
            [pageScrollView addSubview:rightTViewController.view];
        }
    }
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat progress = offset / scrollView.contentSize.width;
    if (progress == 0) {
        NSLog(@"1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"ongoing"}];
    }
    if (offset == scrollView.contentSize.width/3) {
        NSLog(@"2");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"complete"}];
    }
    if (offset == scrollView.contentSize.width/3 *2) {
        NSLog(@"3");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStatus" object:nil userInfo:@{@"OrderStatus":@"cancel"}];
    }
    [menuView animateViewProgress:progress];
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    menuView.userInteractionEnabled = NO;
}

//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    menuView.userInteractionEnabled = YES;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com