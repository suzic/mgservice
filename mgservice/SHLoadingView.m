//
//  SHLoadingView.m
//  Xianghu
//
//  Created by lihongzhu on 14-5-21.
//  Copyright (c) 2014年 Xianghu. All rights reserved.
//


typedef NS_ENUM(NSUInteger, SHLoadingViewApperType) {
    SHLoadingViewApperTypeSynchronous,//同步
    SHLoadingViewApperTypeBackGround,//异步
};

static const CGSize kIndicatiorViewSize = {150,70};

static const CGFloat kIndicatiorViewIndicatiorSpace = 18;
static const CGSize kIndicatiorViewIndicatiorSize = {36,36};

#import "SHLoadingView.h"
//#import "ASIHTTPRequest(ZSHNetWork).h"
//#import "Reachability.h"
#import "Defaut_Enu.h"

@interface SHLoadingView ()
{
    NSString *_string;
    UIImage *_image;
    UIView *_background;
    
    SHLoadingViewType _type;//出现类型
    SHLoadingViewApperType _apperType;//同步异步
}
@end

@implementation SHLoadingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

+ (id)loadingView
{
    return [SHLoadingView loadingViewWithType:(SHLoadingViewTypeNormal)];
}

+ (id)loadingViewWithType:(SHLoadingViewType)type
{
    NSString *string = nil;
    switch (type) {
        case SHLoadingViewTypeNormal:
        case SHLoadingViewTypeLoading:
        case SHLoadingViewTypeCustom:
            string = @"加载中";
            break;
        case SHLoadingViewTypeFail:
            string = @"网络加载失败，\n请稍后点击刷新按钮重试。";
            break;
    }
    
    return [SHLoadingView loadingViewWithType:type Sting:string];
}

+ (id)loadingViewWithType:(SHLoadingViewType)type Sting:(NSString *)string;
{
    if (type == SHLoadingViewTypeCustom)
        return nil;
    return [[SHLoadingView alloc] initWithType:type Image:nil Sting:string];
}

+ (id)loadingViewWithImage:(UIImage *)image Sting:(NSString *)string;
{
    return [[SHLoadingView alloc] initWithType:SHLoadingViewTypeCustom Image:image Sting:string];
}

- (id)initWithType:(SHLoadingViewType)type Image:(UIImage *)image Sting:(NSString *)string
{
    self = [super init];
    
    if (self)
    {
        _type = type;
        switch (type)
        {
            case SHLoadingViewTypeNormal:
            case SHLoadingViewTypeLoading:
                _string = @"加载中";
                break;
            case SHLoadingViewTypeFail:
                _string = @"网络加载失败。\n请稍后点击刷新按钮重试。";
            default:
                break;
        }

        _string = string? string:_string;
        _image = image? image:_image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [UIScreen mainScreen].bounds;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, kIndicatiorViewSize.height, kIndicatiorViewSize.width - 30, LabelheightWithString(_string, 15, kIndicatiorViewSize.width - 30) + 1)];
    label.text = _string;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    _background = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(bounds) - kIndicatiorViewSize.width / 2, CGRectGetMidY(bounds) - kIndicatiorViewSize.height / 2, kIndicatiorViewSize.width, kIndicatiorViewSize.height + 18 + CGRectGetHeight(label.frame))];
    _background.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    _background.layer.cornerRadius = 4;
    
    switch (_type)
    {
        case SHLoadingViewTypeNormal:
        case SHLoadingViewTypeLoading:
        {
            _indicatiorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
            _indicatiorView.backgroundColor = [UIColor clearColor];
            _indicatiorView.frame = CGRectMake(kIndicatiorViewSize.width / 2 - kIndicatiorViewIndicatiorSize.width / 2, kIndicatiorViewIndicatiorSpace, kIndicatiorViewIndicatiorSize.width, kIndicatiorViewIndicatiorSize.height);
            [_indicatiorView startAnimating];
            [_background addSubview:_indicatiorView];
        }
            break;
        case SHLoadingViewTypeFail:
        case SHLoadingViewTypeCustom:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIndicatiorViewSize.width / 2 - kIndicatiorViewIndicatiorSize.width / 2, kIndicatiorViewIndicatiorSpace, kIndicatiorViewIndicatiorSize.width, kIndicatiorViewIndicatiorSize.height)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = _image? _image:[UIImage imageNamed:@"network_fail.png"];
            [_background addSubview:imageView];
        }
            break;
    }
    [_background addSubview:label];
    [self.view addSubview:_background];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bound = [[UIScreen mainScreen] bounds];
    CGPoint point = CGPointMake(CGRectGetMidX(bound), CGRectGetMidY(bound));
    
    CGPoint center = [self.view.window convertPoint:point toView:self.view];
    _background.center = center;
}

- (void)disapper
{
    if (_state == LoadingStateDisVisible || _state == LoadingStateDisApperAnimation)
        return;
    
    if (_window)
    {
        _state = LoadingStateApperAnimation;
        [UIView animateWithDuration:0.001 animations:^{
            _window.alpha = 0;
        }completion:^(BOOL finished) {
            [_window resignKeyWindow];
            _window = nil;
            self.store_self = nil;
            _state = LoadingStateDisVisible;
        }];
    }
    else
    {
        _state = LoadingStateApperAnimation;
        [UIView animateWithDuration:0.001 animations:^{
            self.view.alpha = 0;
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            self.store_self = nil;
            _state = LoadingStateDisVisible;
        }];
    }
}

- (void)showSynchronous//同步
{
    if (!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.windowLevel = UIWindowLevelStatusBar;
        _window.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.6 alpha:0.5];
        _window.alpha = 0;
        [_window addSubview:self.view];
        [_window makeKeyAndVisible];
        self.store_self = self;
        _state = LoadingStateDisVisible;
    }
    if (_state == LoadingStateVisible)
        return;
    else
    {
        _apperType = SHLoadingViewApperTypeSynchronous;
        self.store_self = self;
        _state = LoadingStateApperAnimation;
        [UIView animateWithDuration:0.001 animations:^{
            _window.alpha = 1;
        }completion:^(BOOL finished) {
            _state = LoadingStateVisible;
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_type == SHLoadingViewTypeFail)
        [self disapper];
}

- (void)showWithViewController:(UIViewController *)viewController//异步
{
    if (_state != LoadingStateDisVisible)
        return;
    _showViewController = viewController;
    
    _apperType = SHLoadingViewApperTypeBackGround;

    [viewController.view addSubview:self.view];
    [viewController addChildViewController:self];
    self.view.alpha = 0;
    
    _state = LoadingStateApperAnimation;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1.0;
    }completion:^(BOOL finished) {
        _state = LoadingStateVisible;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

@end
