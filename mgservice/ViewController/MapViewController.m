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
#import "MBProgressHUD.h"

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
@property (strong, nonatomic) FMLocationBuilderInfo *myselfInfo;

@property (nonatomic, copy) NSString * cancelMapID;//取消切换的地图ID
@property (nonatomic, assign) BOOL showChangeMap;
@property (nonatomic, assign) BOOL resultDistance;
@property (nonatomic, assign) NSInteger countZero;
@property (nonatomic, assign) NSInteger count;


@end
int const kCallingServiceCountTwo = 5;

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.inTaskView.backgroundColor = [UIColor whiteColor];
//    self.inTaskView.alpha = 0.7;
    self.count = 0;

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
    
    [self addUserLocationMark];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //此方法之前是放在viewDidLoad里的，但从首页跳转地图时非常卡，然后放在viewDidAppear后不卡了，暂时未发现其他问题，不知道去现场测试会不会有问题。
    [self getMacAndStartLocationService];

    [self addFengMap];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.frameViewcontroller hiddenMainView:YES];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:nil];
    [FMLocationManager shareLocationManager].delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:self.mangroveMapView];
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
    HUD.labelText = @"正在加载地图，请稍等";
    [HUD show:YES];

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
- (void)inDoorMapView:(UIButton *)button
{
    button.selected = NO;
    
//    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    if (self.currentMapCoord.mapID == kOutdoorMapID)
    {
        [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    }
    else
    {
        FMKMapCoord mapCoord = self.currentMapCoord;
        NSDictionary * dic = @{@"mapid":@(mapCoord.mapID).stringValue, @"groupID":@(mapCoord.coord.storey).stringValue,@"isNeedLocate":@(![FMLocationManager shareLocationManager].isCallingService)};
        [self enterIndoorByIndoorInfo:dic];
    }
    
    button.selected = YES;
}
- (void)enterIndoorByIndoorInfo:(NSDictionary * )dic
{
    NSString * mapID = dic[@"mapid"];
    NSString * groupID = dic[@"groupID"];
    BOOL isNeedLocate = dic[@"isNeedLocate"];
    
    FMIndoorMapVC * VC = [[FMIndoorMapVC alloc] initWithMapID:mapID];
    VC.isNeedLocate = isNeedLocate;
    VC.groupID = groupID;
    
    NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
    BOOL indoorMapIsExist = NO;
    for (NSString * indoorMapID in indoorMapIDs) {
        if (indoorMapID.intValue == mapID.intValue) {
            indoorMapIsExist = YES;
            break;
        }
    }
    if (indoorMapIsExist)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//回到主页
- (void)backMainViewController:(NSNotificationCenter *)noti
{
    [self.frameViewcontroller hiddenMainView:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - FMMap

- (void)addFengMap
{
    _mapPath = [[NSBundle mainBundle] pathForResource:@"79980" ofType:@"fmap"];
    _mangroveMapView = [[FMMangroveMapView alloc] initWithFrame:self.view.bounds path:_mapPath delegate:self];
    [self.view addSubview:_mangroveMapView];
    [_mangroveMapView zoomWithScale:2.6];
    [_mangroveMapView rotateWithAngle:45.0];
    [_mangroveMapView setInclineAngle:60.0];
    FMKExternalModelLayer * modelLayer = [self.mangroveMapView.map getExternalModelLayerWithGroupID:@"1"];
    modelLayer.delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:nil];
    [[FMLocationManager shareLocationManager] setMapView:_mangroveMapView];
    UIButton *enableLocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enableLocateBtn.frame = CGRectMake(10, kScreenHeight-64- 50, 50, 50);
    [enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_nomarl"] forState:UIControlStateNormal];
    [enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateSelected];
    [enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateHighlighted];
    [self.view addSubview:enableLocateBtn];
    [enableLocateBtn addTarget:self action:@selector(inDoorMapView:) forControlEvents:UIControlEventTouchUpInside];
    
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
    if (macAddress != nil && ![macAddress isEqualToString:@""])
    {
        [[DataManager defaultInstance] getWaiterInfor].deviceId = macAddress;
    }
    
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [[FMKLocationServiceManager shareLocationServiceManager] startLocateWithMacAddress:macAddress mapPath:_mapPath];
}
- (void)addUserLocationMark
{
    [FMNaviAnalyserTool shareNaviAnalyserTool].returnNaviResult = ^(NSArray * result, NSString * mapID)
    {
    };
    //拿到coredata里的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"waiterStatus = 1"];
    DBTaskList *waiterTaskList = (DBTaskList *)[[[DataManager defaultInstance] arrayFromCoreData:@"DBTaskList" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil] lastObject];
    self.userBuilderInfo = [[FMLocationBuilderInfo alloc] init];
    self.userBuilderInfo.loc_mac = waiterTaskList.userDiviceld;
    self.userBuilderInfo.loc_desc = @"客人位置";
    self.userBuilderInfo.loc_icon = @"clien_icon.png";
    
    DBWaiterInfor *waiterInfo = [[DataManager defaultInstance] getWaiterInfor];

    self.myselfInfo = [[FMLocationBuilderInfo alloc] init];
    self.myselfInfo.loc_mac = waiterInfo.deviceId;
    self.myselfInfo.loc_desc = @"我的位置";
    self.myselfInfo.loc_icon = @"waiter.png";
    _locationMarker.hidden = YES;
    [FMLocationManager shareLocationManager].delegate = self;
    [[FMLocationManager shareLocationManager] addLocOnMap:self.myselfInfo];
    [[FMLocationManager shareLocationManager] addLocOnMap:self.userBuilderInfo];
    [[FMLocationManager shareLocationManager] testDistanceWithLocation1:self.myselfInfo location2:self.userBuilderInfo distance:10];
}

- (void)removeLocation
{
    [[FMLocationManager shareLocationManager] removeLocOnMap:self.myselfInfo];
    [[FMLocationManager shareLocationManager] removeLocOnMap:self.userBuilderInfo];
    [FMLocationManager shareLocationManager].delegate = nil;
}

#pragma mark - FMKLocationServiceManagerDelagate

- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success
{
    self.locationMarker.hidden = [FMLocationManager shareLocationManager].isCallingService;
    self.currentMapCoord = mapCoord;
    
    if ([FMLocationManager shareLocationManager].isCallingService == YES) return;
    
    if (success == NO)
        return;
    
    _currentMapCoord = mapCoord;
    NSLog(@"当前的线程:%@",[NSThread currentThread]);
    NSLog(@"地图切换的逻辑");
    
    //跳转或更新地图
    [self switchToIndoorOrUpdateLocationMarkerByMapCoord:mapCoord];
}
- (void)switchToIndoorOrUpdateLocationMarkerByMapCoord:(FMKMapCoord)mapCoord
{
    if (mapCoord.mapID != kOutdoorMapID && mapCoord.mapID != _cancelMapID.intValue)
    {
        NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
        BOOL indoorMapIsExist = NO;
        for (NSString * indoorMapID in indoorMapIDs) {
            if (indoorMapID.intValue == mapCoord.mapID) {
                indoorMapIsExist = YES;
                break;
            }
        }
        if (indoorMapIsExist)
        {
            self.currentMapCoord = mapCoord;
            self.showChangeMap = YES;
        }
    }
    else
    {
        _locationMarker.hidden = NO;
        [_locationMarker locateWithGeoCoord:mapCoord.coord];
    }
    
}
- (void)setShowChangeMap:(BOOL)showChangeMap
{
    if (_showChangeMap != showChangeMap)
    {
        _showChangeMap = showChangeMap;
        if (_showChangeMap == YES)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"是否切换地图!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           FMIndoorMapVC * indoorMapVC = [[FMIndoorMapVC alloc] initWithMapID:@(self.currentMapCoord.mapID).stringValue];
                                           indoorMapVC.groupID = @(self.currentMapCoord.coord.storey).stringValue;
                                           [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
//                                           MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
//                                           HUD.labelText = @"正在加载地图，请稍等";
//                                           [HUD show:YES];
                                           
                                           [self testIndoorMapIsxistByMapCoord:self.currentMapCoord.mapID];
                                           NSLog(@"%d",self.currentMapCoord.mapID);
                                           [self.navigationController pushViewController:indoorMapVC animated:YES];
                                       }];
            
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                _cancelMapID = @(self.currentMapCoord.mapID).stringValue;
            }];
            
            [alertView addAction:action1];
            [alertView addAction:action2];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
    }
}
- (void)didUpdateHeading:(double)heading
{
    if (_locationMarker) {
        [_locationMarker updateRotate:heading];
    }
}
- (void)mapViewDidFinishLoadingMap:(FMKMapView *)mapView
{
    [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
}
#pragma mark - FMLocationManagerDelegate

- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++");
    self.resultDistance = result;
}
- (void)updateLocPosition:(FMKMapCoord)mapCoord macAddress:(NSString * )macAddress
{
    if (self.countZero != mapCoord.mapID)
    {
        self.count = 0;
        self.countZero = mapCoord.mapID;
    }
    else
    {
        if (self.count < kCallingServiceCountTwo)
        {
            ++self.count;
        }
    }
    if (self.count != kCallingServiceCountTwo)
        return;
    
    NSLog(@"%d",mapCoord.mapID);
    if (macAddress != [[DataManager defaultInstance] getWaiterInfor].deviceId && mapCoord.mapID != kOutdoorMapID)
    {
        _locationMarker.hidden = YES;
        self.currentMapCoord = mapCoord;
        self.showChangeMap = YES;
    }
}
- (void)setResultDistance:(BOOL)resultDistance
{
    if (_resultDistance != resultDistance)
    {
        _resultDistance = resultDistance;
        if (_resultDistance == YES)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"距离小于十米" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAcion = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            [alertView addAction:sureAcion];
            [self presentViewController:alertView animated:YES completion:^{
                
            }];
        }
    }
}
//判断室内地图是否存在
- (BOOL)testIndoorMapIsxistByMapCoord:(int)mapID
{
    NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
    BOOL indootMapIsExist = NO;
    for (NSString * indoorMapID in indoorMapIDs) {
        if (indoorMapID.intValue == mapID) {
            indootMapIsExist = YES;
            break;
        }
    }
    return indootMapIsExist;
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
