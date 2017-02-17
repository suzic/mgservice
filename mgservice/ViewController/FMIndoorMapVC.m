//
//  FMIndoorMapVC.m
//  mgservice
//
//  Created by chao liu on 16/11/26.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FMIndoorMapVC.h"
#import "ChooseFloorScrollView.h"
#import "MBProgressHUD.h"

@interface FMIndoorMapVC ()<FMKMapViewDelegate,FMKLocationServiceManagerDelegate,ChooseFloorScrollViewDelegate,FMKLayerDelegate,FMLocationManagerDelegate>

@property (nonatomic, strong) FMMangroveMapView * mapView;
@property (nonatomic, strong) NSString *mapPath;//地图数据路径
@property (nonatomic, strong) FMKLocationMarker *locationMarker;
@property (nonatomic, strong) ChooseFloorScrollView *chooseFloorScrlooView;
@property (nonatomic, strong) NSString *displayGroupID;
@property (nonatomic, copy) NSString * cancelMapID;//取消切换的地图ID
@property (nonatomic, assign) FMKMapCoord currentMapCoord;
@property (nonatomic, assign) BOOL showChangeMap;
@property (nonatomic, assign) BOOL isDistance;
@property (nonatomic, assign) NSInteger countZero;
@property (nonatomic, assign) NSInteger count;
@end
int const kCallingServiceCount = 5;
@implementation FMIndoorMapVC

- (instancetype)initWithMapID:(NSString *)mapID
{
    if (self = [super init]) {
        self.mapID = mapID;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMapView];

    self.count = 0;
    self.isDistance = NO;
    [self addLocationMarker];//定位图标
    [self createChooseScrollView];
    //室内地图的左上角完成按钮
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(reloadTask:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    //室内地图右上角的刷新按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshTask:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [FMLocationManager shareLocationManager].delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:nil];
    [[FMLocationManager shareLocationManager] setMapView:self.mapView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)createMapView
{
    if (!_mapView)
    {
#if DEBUG_ONLINE
    CGRect rect = CGRectMake(0, kNaviHeight+kFloorButtonHeight-8, kScreenWidth, kScreenHeight-kNaviHeight-kFloorButtonHeight+3);
    _mapView = [[FMMangroveMapView alloc] initWithFrame:rect ID:_mapID delegate:self];
    _mapPath = [[FMKMapDataManager shareInstance]getMapDataPathWithID:_mapID];
#else
    _mapPath = [[NSBundle mainBundle] pathForResource:self.mapID ofType:@"fmap"];
    _mapView = [[FMMangroveMapView alloc] initWithFrame:self.view.bounds path:_mapPath delegate:self];
#endif
    [_mapView setThemeWithLocalPath:[[NSBundle mainBundle] pathForResource:@"2002.theme" ofType:nil]];
    
    if (!self.groupID) {
        self.groupID = @"1";
    }
    _mapView.displayGids = @[self.groupID];
    [self.view addSubview:_mapView];
    [self resetMapPara];
    _mapView.showCompass = YES;
    _mapView.showCompass = YES;
    }
    self.displayGroupID = self.groupID;
}
//添加定位标注物
- (void)addLocationMarker
{
    if (!_locationMarker) {
        _locationMarker = [[FMKLocationMarker alloc] initWithPointerImageName:@"pointer.png" DomeImageName:@"dome.png"];
        [_mapView.map.locateLayer addLocationMarker:_locationMarker];
        _locationMarker.size = CGSizeMake(50, 50);
    }
    
}

//创建选择楼层滚动视图
- (void)createChooseScrollView
{
    _chooseFloorScrlooView = [[ChooseFloorScrollView alloc] initWithGids:_mapView.map.names];
    _chooseFloorScrlooView.delegate = self;
    [self.view addSubview:_chooseFloorScrlooView];
}
- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success
{
    self.locationMarker.hidden = [FMLocationManager shareLocationManager].isCallingService;
    self.currentMapCoord = mapCoord;
    if ([FMLocationManager shareLocationManager].isCallingService == YES) return;
    if (success == NO)
        return;
    
    if (mapCoord.mapID == kOutdoorMapID)
    {
        [self popToOtherMapByMapCoord:mapCoord];
    }
    else if (mapCoord.mapID != self.mapID.integerValue)
    {
        if ([self testIndoorMapIsxistByMapCoord:mapCoord]) {
            [self popToOtherMapByMapCoord:mapCoord];
        }
    }
}
//判断室内地图是否存在
- (BOOL)testIndoorMapIsxistByMapCoord:(FMKMapCoord)mapCoord
{
    NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
    BOOL indootMapIsExist = NO;
    for (NSString * indoorMapID in indoorMapIDs) {
        if (indoorMapID.intValue == mapCoord.mapID) {
            indootMapIsExist = YES;
            break;
        }
    }
    return indootMapIsExist;
}
//弹框提示切换到其他地图
- (void)popToOtherMapByMapCoord:(FMKMapCoord)mapCoord
{
    if (mapCoord.mapID != _cancelMapID.intValue)
    {
        self.currentMapCoord = mapCoord;
        self.showChangeMap = YES;
    }
}

- (void)setShowChangeMap:(BOOL)showChangeMap
{
    if (_showChangeMap != showChangeMap)
    {
        _showChangeMap = showChangeMap;
        if (_showChangeMap == YES && [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID != self.mapID.intValue)
        {
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"是否切换地图!!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           if (self.currentMapCoord.mapID == kOutdoorMapID) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           else
                                           {
                                               [self switchToOtherIndoorByMapCoord:self.currentMapCoord];
                                               [_locationMarker locateWithGeoCoord:self.currentMapCoord.coord];
                                           }
                                           _showChangeMap = NO;
                                       }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                _cancelMapID = @(self.currentMapCoord.mapID).stringValue;
            }];
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}
- (void)setDisplayGroupID:(NSString *)displayGroupID
{
    [self resetModelLayerDelegate];
    [self updateChooseScrollView];
}
- (void)updateChooseScrollView
{
    NSInteger index = [self.mapView.groupIDs indexOfObject:_displayGroupID];
    [_chooseFloorScrlooView updateScrollViewContentOffsetByIndex:index];
}

//室内切室内
- (void)switchToOtherIndoorByMapCoord:(FMKMapCoord)mapCoord
{
    [self.mapView.map.locateLayer removeLocateMark:_locationMarker];
    self.mapID = @(mapCoord.mapID).stringValue;
    _mapPath = [[NSBundle mainBundle] pathForResource:self.mapID ofType:@"fmap"];
    [self.mapView transformMapWithDataPath:_mapPath];
    [self resetMapPara];
    self.displayGroupID = @(mapCoord.coord.storey).stringValue;
    [_chooseFloorScrlooView createScrollView:self.mapView.map.names];
    _locationMarker = [[FMKLocationMarker alloc] initWithPointerImageName:@"pointer.png" DomeImageName:@"dome.png"];
    [self.mapView.map.locateLayer addLocationMarker:_locationMarker];
}
//设置地图显示的初始值
- (void)resetMapPara
{
    [[FMLocationManager shareLocationManager] setMapView:nil];
    [_mapView zoomWithScale:2.6];
    [_mapView rotateWithAngle:45.0];
    [_mapView setInclineAngle:60.0];
    _mapView.showCompass = YES;
    
    [_mapView setThemeWithLocalPath:[[NSBundle mainBundle] pathForResource:@"2002.theme" ofType:nil]];
    [[FMLocationManager shareLocationManager] setMapView:_mapView];
}
- (void)buttonClick:(NSInteger)page
{
    _mapView.displayGids = @[_mapView.groupIDs[page]];
    _displayGroupID = _mapView.groupIDs[page];
    [_mapView.map.lineLayer removeAllLine];
    //	[_mapView addAllLineByMapPath:_mapPath groupID:_displayGroupID];
    [self resetModelLayerDelegate];
}
//根据显示楼层重新设置模型层代理
- (void)resetModelLayerDelegate
{
    FMKModelLayer * modelLayer = [self.mapView.map getModelLayerWithGroupID:_displayGroupID];
    modelLayer.delegate = self;
}
- (void)mapViewDidFinishLoadingMap:(FMKMapView *)mapView
{
    [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
}
#pragma mark - FMLocationManagerDelegate

- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"__________________________________");
    self.isDistance = result;
   
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
        if (self.count < kCallingServiceCount)
        {
            ++self.count;
        }
    }
    if (self.count != kCallingServiceCount)
        return;
    NSLog(@"_________________%d____________________%d",mapCoord.mapID, [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID);
    if (macAddress != [[DataManager defaultInstance] getWaiterInfor].deviceId && [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID != self.mapID.intValue)
    {
        self.showChangeMap = YES;
        self.currentMapCoord = mapCoord;
    }
    _locationMarker.hidden = YES;
}
- (void)setIsDistance:(BOOL)isDistance
{
    if (_isDistance != isDistance)
    {
        _isDistance = isDistance;
        if (_isDistance == YES)
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

#pragma mark - 点击事件
- (void)reloadTask:(UIButton *)btn
{
    //通知inTask页面 完成任务
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"任务已完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTask" object:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)refreshTask:(UIButton *)btn
{
    //通知inTask页面，刷新任务
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTaskItemAction" object:nil];
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
