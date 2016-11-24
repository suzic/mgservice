//
//  MapViewController.m
//  mgservice
//
//  Created by liuchao on 2016/11/3.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MapViewController.h"
#import "InTaskController.h"

@interface MapViewController ()<FMKMapViewDelegate,FMKSearchAnalyserDelegate,FMKLayerDelegate>

@property (assign, nonatomic) BOOL showFinish;
@property (retain, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) FMMangroveMapView *mangroveMapView;
@property (strong, nonatomic) NSString *mapPath;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.inTaskView.backgroundColor = [UIColor whiteColor];
//    self.inTaskView.alpha = 0.7;
    self.title = @"当前执行中任务";
    self.navigationItem.hidesBackButton = YES;//隐藏后退按钮

        
//    self.alertController = [UIAlertController alertControllerWithTitle:@"消息通知" message:@"您的距离客人距离十米，请完成当前任务吧 ！" preferredStyle:UIAlertControllerStyleAlert];
//    __weak typeof (self) weakSelf = self;
//    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf.intaskController NETWORK_reloadWorkStatusTask];
//        
//    }];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //        _showFinish = NO;
//    }];
//    [self.alertController addAction:cancelAction];
//    [self.alertController addAction:action];
    
    [self addFengMap];
    
    //定位按钮
    UIButton * positioningButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [positioningButton setBackgroundImage:[UIImage imageNamed:@"location_icon_nomarl"] forState:UIControlStateNormal];
    positioningButton.frame = CGRectMake(10, kScreenHeight-74-35, 35, 35);
    [positioningButton addTarget:self action:@selector(positioningButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mangroveMapView addSubview:positioningButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.frameViewcontroller hiddenMainView:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.frameViewcontroller hiddenMainView:NO];
}
- (void)addFengMap
{
    _mapPath = [[NSBundle mainBundle] pathForResource:@"79980" ofType:@"fmap"];
    _mangroveMapView = [[FMMangroveMapView alloc] initWithFrame:self.view.bounds path:_mapPath delegate:self];
    [self.view addSubview:_mangroveMapView];
    FMKExternalModelLayer * modelLayer = [self.mangroveMapView.map getExternalModelLayerWithGroupID:@"1"];
    modelLayer.delegate = self;
}

- (void)setShowFinish:(BOOL)showFinish
{
    if (_showFinish == showFinish)
        return;
    _showFinish = showFinish;
    
    
    if (_showFinish == YES)
    {
        [self presentViewController:self.alertController animated:YES completion:nil];
        
    }else
    {
        [self.alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (IBAction)tenMButton:(id)sender
{
    [self.frameViewcontroller FinishCurrentTaskAction];
}

#pragma mark - 按钮

- (IBAction)showMapButton:(id)sender
{
    [self.frameViewcontroller reloadCurrentTask];
}

// 定位按钮
- (void)positioningButtonAction:(UIButton *)btn
{
    NSLog(@"定位");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
