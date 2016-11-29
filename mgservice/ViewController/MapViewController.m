//
//  MapViewController.m
//  mgservice
//
//  Created by liuchao on 2016/11/3.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MapViewController.h"
#import "InTaskController.h"
#import "FMIndoorMapVC.h"

@interface MapViewController ()<FMKLocationServiceManagerDelegate,FMKMapViewDelegate,FMKLayerDelegate,FMLocationManagerDelegate>

@property (assign, nonatomic) BOOL showFinish;
@property (retain, nonatomic) UIAlertController *alertController;

// 地图相关
@property (strong, nonatomic) FMMangroveMapView *mangroveMapView;
@property (strong, nonatomic) NSString *mapPath;
//当前定位位置
@property (assign, nonatomic) FMKMapCoord currentMapCoord;
@property (strong, nonatomic) FMKLocationMarker * locationMarker;
@property (strong, nonatomic) FMLocationBuilderInfo *userBuilderInfo;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backMainViewController:) name:@"backMainViewController" object:nil];

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
    
    [self getMacAndStartLocationService];
    
    [self addUserLocationMark];
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
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [FMLocationManager shareLocationManager].delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:self.mangroveMapView];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.frameViewcontroller hiddenMainView:NO];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//回到主页
- (void)backMainViewController:(NSNotificationCenter *)noti
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FMMap

- (void)addFengMap
{
    _mapPath = [[NSBundle mainBundle] pathForResource:@"79980" ofType:@"fmap"];
    _mangroveMapView = [[FMMangroveMapView alloc] initWithFrame:self.view.bounds path:_mapPath delegate:self];
    [self.view addSubview:_mangroveMapView];
    FMKExternalModelLayer * modelLayer = [self.mangroveMapView.map getExternalModelLayerWithGroupID:@"1"];
    modelLayer.delegate = self;
}

//获取MAC地址并且开启定位服务
- (void)getMacAndStartLocationService
{
    __block NSString *macAddress;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[FMDHCPNetService shareDHCPNetService] localMacAddress:^(NSString *macAddr) {
        macAddress = macAddr;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [[FMKLocationServiceManager shareLocationServiceManager] startLocateWithMacAddress:macAddress mapPath:_mapPath];
}
- (void)addUserLocationMark
{
    //拿到coredata里的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    DBTaskList *waiterTaskList = (DBTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil] lastObject];
    self.userBuilderInfo = [[FMLocationBuilderInfo alloc] init];
    self.userBuilderInfo.loc_mac = waiterTaskList.userDiviceld;
    self.userBuilderInfo.loc_desc = @"客人位置";
    self.userBuilderInfo.loc_icon = @"fengmap.png";
    [self.mangroveMapView addLocOnMap:self.userBuilderInfo];
}
#pragma mark - FMKLocationServiceManagerDelagate

- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success
{
    if (success == NO)
        return;
    
    _currentMapCoord = mapCoord;
    NSLog(@"当前的线程:%@",[NSThread currentThread]);
    NSLog(@"地图切换的逻辑");
    if (mapCoord.mapID != 79980)
    {
        // 这里需要回到主线程 因为要操作UI
        dispatch_async(dispatch_get_main_queue(), ^()
        {
            if (self.alertController == nil)
            {
                self.alertController = [UIAlertController alertControllerWithTitle:@"是否切换地图" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                           {
                                               FMIndoorMapVC * VC = [[FMIndoorMapVC alloc] initWithMapID:[NSString stringWithFormat:@"%d",mapCoord.mapID]];
                                               VC.isNeedWifi = YES;
                                               VC.groupID = [NSString stringWithFormat:@"%d",mapCoord.coord.storey];
                                               [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
                                               [self.navigationController pushViewController:VC animated:YES];
                                               self.alertController = nil;
                                               NSLog(@"toIndoor2");
                                           }];
    
                UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                           {
                                           }];
    
                [self.alertController addAction:action1];
                [self.alertController addAction:action2];
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
        });

        
    }
    else
    {
        @synchronized (_locationMarker) {
            [_locationMarker locateWithGeoCoord:mapCoord.coord];
        }
    }
}

- (void)didUpdateHeading:(double)heading
{
    if (_locationMarker) {
        [_locationMarker updateRotate:heading];
    }
}

#pragma mark - FMLocationManagerDelegate

- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++");
    if (result == YES)
    {
        [self.mangroveMapView stopTestDistance];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"距离小于十米" message:@"我只是测试一下" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAcion = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alertView addAction:sureAcion];
        //        [self.mainController presentViewController:alertView animated:YES completion:^{
        //
        //        }];
    }
}
- (void)updateLocPosition:(FMKMapCoord)mapCoord macAddress:(NSString * )macAddress
{
    
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
