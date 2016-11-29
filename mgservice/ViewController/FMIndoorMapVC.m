//
//  FMIndoorMapVC.m
//  mgservice
//
//  Created by chao liu on 16/11/26.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FMIndoorMapVC.h"
#import "ChooseFloorScrollView.h"

@interface FMIndoorMapVC ()<FMKMapViewDelegate,FMKLocationServiceManagerDelegate,ChooseFloorScrollViewDelegate,FMKLayerDelegate,FMLocationManagerDelegate>

@property (nonatomic, strong) FMMangroveMapView * mapView;
@property (nonatomic, strong) NSString *mapPath;//地图数据路径
@property (nonatomic, strong) FMKLocationMarker *locationMarker;
@property (nonatomic, strong) ChooseFloorScrollView *chooseFloorScrlooView;
@property (nonatomic, strong) NSString *displayGroupID;

@end

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
    [self addLocationMarker];//定位图标
    [self createChooseScrollView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [FMLocationManager shareLocationManager].delegate = self;
    [[FMLocationManager shareLocationManager] setMapView:self.mapView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;

}

- (void)createMapView
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
//    _displayGroupID = self.groupID;
//    [self resetModelLayerDelegate];
    [self.view addSubview:_mapView];
    [_mapView zoomWithScale:2.6];
    [_mapView rotateWithAngle:45.0];
    [_mapView setInclineAngle:60.0];
    _mapView.showCompass = YES;
    
    
//    _isFirstLocate = YES;
    _mapView.showCompass = YES;
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
    if (success == NO)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_locationMarker locateWithGeoCoord:mapCoord.coord];
        if (mapCoord.mapID == kOutdoorMapID) {
            [self.navigationController popViewControllerAnimated:YES];
        }  
    });
    
    
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

#pragma mark - FMLocationManagerDelegate

- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++");
    if (result == YES)
    {
        [self.mapView stopTestDistance];
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
