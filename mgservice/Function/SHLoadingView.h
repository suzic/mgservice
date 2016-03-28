//
//  SHLoadingView.h
//  Xianghu
//
//  Created by lihongzhu on 14-5-21.
//  Copyright (c) 2014年 Xianghu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LoadingState) {
    LoadingStateDisVisible = 0,
    LoadingStateVisible,
    LoadingStateApperAnimation,
    LoadingStateDisApperAnimation
};


typedef NS_ENUM(NSUInteger, SHLoadingViewType) {
    SHLoadingViewTypeNormal,
    SHLoadingViewTypeLoading,
    SHLoadingViewTypeFail,//自动消失
    SHLoadingViewTypeCustom//自定义
};

@interface SHLoadingView : UIViewController
{
    LoadingState _state;
    
    UIActivityIndicatorView *_indicatiorView;;
}

@property (nonatomic, retain) UIWindow *window;

+ (id)loadingView;
+ (id)loadingViewWithType:(SHLoadingViewType)type;
+ (id)loadingViewWithType:(SHLoadingViewType)type Sting:(NSString *)string;
+ (id)loadingViewWithImage:(UIImage *)image Sting:(NSString *)string;

@property (nonatomic, strong)id store_self;

- (void)showSynchronous;//同步
- (void)showWithViewController:(UIViewController *)viewController;//异步
- (void)disapper;

@property(nonatomic, assign)UIViewController *showViewController;

@end
