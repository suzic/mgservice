//
//  NgrmapViewController.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/10/19.
//  Copyright © 2015年 palmaplus. All rights reserved.
// 686809 687255 688317

#import "NgrmapViewController.h"
#import "NavigationView.h"
#import "touchPointData.h"
#import "PointView.h"
#import <Nagrand/NGROverlayer.h>
#import "CompassView.h"
#import "BubblePopView.h"
#import "BubblePopView1.h"
#import "changeFloorToolView.h"
#import "OMGToast.h"
#import "MBProgressHUD.h"
#import "HPDProgress.h"
#import "FloorRegionModel.h"
#import "OneRegionModel.h"

typedef NS_ENUM(NSInteger, parkingState) {
    parking = 0,
    modifyParking,
    findingCar
};

@interface NgrmapViewController ()<NGRDataSourceDelegate,NGRMapViewDelegate,NGRNavigateManagerDelegate,UIActionSheetDelegate,NGRPositioningDelegate,CLLocationManagerDelegate,floorChangeDelegate,UIActionSheetDelegate>
{
    CLLocationManager* _locationManager;
    NGRPositioningManager* blueManager;
    CGFloat _currentAngleMap;
    
     //手指点的地图位置
    BOOL _isNavigating;
    BOOL _isNavigatingActualTime;
    BubblePopView* _bubblePopStart;
    BubblePopView1* _bubblePopEnd;
    NSString* _bubblePopTitle;
    NSString* _bubblePopTitle1;
    NSInteger _selectedIndoorID;
    UILabel* _labelDistance;
    BOOL _needShowAlertForNoSearchResult;
    UIImageView *_locationImageView;
}

@property (assign,nonatomic)unsigned long floorTableViewStartPoint;
@property (strong,nonatomic)CompassView* compassView;
@property (strong,nonatomic)NavigationView* navigationStartView;
@property (strong,nonatomic)NSMutableArray* indoorPoiIdArray;
@property (strong,nonatomic)UIButton* outdoorButton;
@property(strong,nonatomic) NGRLocation *currentLocation;
@property (strong,nonatomic)UILabel* featureLabel;
@property (strong,nonatomic)changeFloorToolView* floorChangeToolView;
@property (strong,nonatomic)NGRPositioningManager* wifiManager;
@property (strong,nonatomic)  NGRNavigateManager *navigationManager;
@property(strong,nonatomic) NSMutableArray* regionArray;
@property(assign,nonatomic)NGRID currentFloorId;
@property(strong,nonatomic)NGRDataSource *dataSource;
@property(strong,nonatomic)UIScrollView* searchStartAndEndDiv;
@property(strong,nonatomic)NGROverlayer *selectStartOverlayer;
@property(strong,nonatomic) NGROverlayer *selectEndOverlayer;
@property(assign,nonatomic)BOOL hasOpenWifiLocation;
@property(assign,nonatomic)CGPoint navigationEndPoint;
@property(assign,nonatomic)BOOL shouldAutoChangFloor;
@property(strong,nonatomic)UIActionSheet* selectStartAndEndSheet;
@property(copy,nonatomic)NSString* currentFloorName;
@property(copy,nonatomic)NSString* locationFloorName;
@property(strong,nonatomic)NGROverlayer* locationOverlayer;
@property(nonatomic,strong)NSMutableDictionary* floorNameDic;
@property(nonatomic,assign)BOOL isClipNavigationLine;
@property(nonatomic,assign) CGPoint currentLocationPoint;
@property(nonatomic,strong)NSArray* locationErrorState;
@property(nonatomic,assign)NGRID locationFloorId;
@property(nonatomic,assign)NSInteger distanceCount;
@property(nonatomic,strong)NGROverlayer *selectPinOverlayer;
@property(strong,nonatomic)NSMutableArray* jsonFloorDataArray;
@property(nonatomic,strong)NSMutableArray* regionPointArray;
@property(nonatomic,strong)NSMutableArray* regionPointArray1;
@property(nonatomic,strong)NSTimer* autoChangeMaptimer;
@property(nonatomic,strong)UIButton* autoChangeMapButton;
@property(nonatomic,assign)NSInteger interval;
/**
 *  取消导航进程
 */
@property (strong,nonatomic)UIButton* cancelNavigateProcess;
@property (strong,nonatomic)UIButton* Locationbtn;
@end

@implementation NgrmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMap) name:NotiStopDrawMap object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMap ) name:NotiStartDrawMap object:nil];
    
    [self configMapView:nil];
//    _locationFloorId = 666659;
    _locationFloorId = 0;
    self.interval = 0;
    self.indoorPoiIdArray = [NSMutableArray array];
     self.navigationEndPoint = CGPointMake(0, 0);
    self.regionArray = [NSMutableArray array];
    self.jsonFloorDataArray = [NSMutableArray array];
    self.regionPointArray = [NSMutableArray array];
    self.regionPointArray1 = [NSMutableArray array];
    self.distanceCount = 0;
    self.mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.mapView.mapOptions.skewEnabled = NO;
    self.mapView.mergeGesture = true;
    self.mapView.transferGesture = true;
    self.mapView.fitScreenRatio = 1.0;
    
    _currentLocationPoint = CGPointMake(0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    /**
     *  添加定位错误状态
     */
    [self addlocationErrorState];
    /**
     *  添加楼层列表
     */
    [self addFloorData];
    /**
     *  切换楼层相关的
     */
    [self addChangeFloorBGViewToolView];

    /**
     *  添加地图数据
     */
    [self addMapData];
    /**
     *  加入指南针
     */
    [self addCompassView];
    /**
     *  用来显示楼层mapid的
     */
    [self addfeatureLabel];
    /**
     *  添加限定区域的代码
     */
    [self addRegionPointData];
     /**
      *  自动转换定位点偏角
      */
     [self addLocationCompass];
    
    [self addLongTapGes];
    
    [self addLocationButton];
    /**
     *  顶部自动切换楼层的计时代码。
     */
    [self addAutochangeMapButton];
}
// 解决程序退出后台因为友盟和地图问题造成的崩溃
- (void)stopMap
{
    [self.mapView stop];
}
- (void)startMap
{
    [self.mapView start];
}

-(void)shareManager{
//    static NGRMapViewController* shareself = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        self = [[self alloc]init];
//    });
//    return shareself;
    
}
-(void)addAutochangeMapButton{
    self.autoChangeMapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.autoChangeMapButton addTarget:self action:@selector(autochangfloor) forControlEvents:UIControlEventTouchUpInside];
    self.autoChangeMapButton.frame = CGRectMake(kScreenWidth/2-100, 74, 200, 44);
    [self.view addSubview:self.autoChangeMapButton];
//    self.autoChangeMapButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.autoChangeMapButton.titleLabel.numberOfLines = 1;
    self.autoChangeMapButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.autoChangeMapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.autoChangeMapButton.hidden = YES;
}
-(void)addLocationButton{
    
    _Locationbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _Locationbtn.layer.masksToBounds = YES;
    _Locationbtn.layer.cornerRadius = 3;
    _Locationbtn.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    _Locationbtn.layer.borderWidth = 1.0;
    [_Locationbtn setBackgroundImage:[UIImage imageNamed:@"组-15"] forState:UIControlStateNormal] ;
    _Locationbtn.backgroundColor = [UIColor whiteColor];
    [_Locationbtn addTarget:self action:@selector(gotoCurrentCenter) forControlEvents:UIControlEventTouchUpInside];
    
    _Locationbtn.frame = CGRectMake(10 , 20+ 64 +40, 40, 40);
    [self.view addSubview:_Locationbtn];
}

-(void)gotoCurrentCenter{
   touchPointData* currentLocation = [self UserCurrentLocation];
    
    if (currentLocation) {
        //去掉自动跳转的功能
        [self.autoChangeMaptimer  invalidate];
        self.autoChangeMaptimer = nil;
        self.autoChangeMapButton.hidden = YES;
        self.shouldAutoChangFloor = NO;
        if (_currentLocationPoint.x!=0&&_currentFloorId==_locationFloorId) {
            [self.mapView moveToPoint:_currentLocationPoint animated:YES duration:300];
        }
        
        if (_currentFloorId != currentLocation.floorID) {
            if (currentLocation.floorID ==outDoorId) {

                [self requestMapOutDoorWithSearchPoi:nil];
            }else{
                __weak typeof(self) weakSelf =self;
                [_dataSource requestPoi:currentLocation.floorID success:^(NGRLocationModel *poi) {

                    [weakSelf comeInInDoorMapWithMapID:poi.parentID andFloorID:currentLocation.floorID WithSearchPoi:nil];
                } error:^(NSError *error) {
                    
                }];
            }
        }
    }
}

-(void)addlocationErrorState{

    self.locationErrorState = @[@"START",@"STOP",@"CLOSE",@"MOVE",@"ENTER",@"OUT",@"HEART_BEAT",@"ERROR"];
    
}
-(void)addFloorData{
    self.floorNameDic = [NSMutableDictionary dictionary];
    [self.floorNameDic setObject:@"1-" forKey:@"国际会展中心"];
    [self.floorNameDic setObject:@"2-" forKey:@"椰林酒店"];
    [self.floorNameDic setObject:@"3-" forKey:@"棕榈酒店"];
    [self.floorNameDic setObject:@"4|5-" forKey:@"皇后棕&大王棕酒店"];
    [self.floorNameDic setObject:@"6-" forKey:@"菩提酒店"];
    [self.floorNameDic setObject:@"7-" forKey:@"木棉酒店A"];
    [self.floorNameDic setObject:@"8-" forKey:@"木棉酒店B"];
}
- (void)addLongTapGes {
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [self.mapView addGestureRecognizer:longPressGes];
}
 -(void)addLocationCompass{
     _locationManager = [[CLLocationManager alloc]init];
     _locationManager.delegate = self;
     _locationManager.headingFilter =kCLHeadingFilterNone;
     [_locationManager startUpdatingHeading];
     
 }
#pragma mark-添加限定区域
/**
 *  添加限定区域的代码
 */
-(void)addRegionPointData{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"floor_idTable" ofType:@"json"];
    NSData* pathData = [[NSData alloc]initWithContentsOfFile:path];
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:pathData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* itemDic in jsonArray) {
        NSNumber* mapid = itemDic[@"id"];
        NSString* mapName = itemDic[@"name"];
        for (NSDictionary* floorDic in itemDic[@"children"]) {
            FloorRegionModel* floorRegion =[[FloorRegionModel alloc]init];
            floorRegion.floorid = floorDic[@"id"];
            
            floorRegion.floorName = floorDic[@"address"];
            floorRegion.mapID = mapid;
            floorRegion.mapName = mapName;
            [self.jsonFloorDataArray addObject:floorRegion];
        }

    }
    
    NSString* path1 = [[NSBundle mainBundle]pathForResource:@"regionLocation_45" ofType:@"json"];
    NSData* pathData1 = [[NSData alloc]initWithContentsOfFile:path1];
    NSArray* jsonArray1 = [NSJSONSerialization JSONObjectWithData:pathData1 options:NSJSONReadingMutableContainers error:nil][@"regions"];
    for (NSDictionary* regionDic in jsonArray1) {
        OneRegionModel* oneReg = [[OneRegionModel alloc]init];
        oneReg.regionArray = regionDic[@"coordinates"];
        oneReg.name = regionDic[@"name"];
        [self.regionPointArray addObject:oneReg];
    }
    
    
    NSString* path2 = [[NSBundle mainBundle]pathForResource:@"regionLocation" ofType:@"json"];
    NSData* pathData2 = [[NSData alloc]initWithContentsOfFile:path2];
    NSArray* jsonArray2 = [NSJSONSerialization JSONObjectWithData:pathData2 options:NSJSONReadingMutableContainers error:nil][@"regions"];
    for (NSDictionary* regionDic in jsonArray2) {
        OneRegionModel* oneReg = [[OneRegionModel alloc]init];
        oneReg.regionArray = regionDic[@"coordinates"];
        oneReg.name = regionDic[@"name"];
        [self.regionPointArray1 addObject:oneReg];
    }
    
}
-(NSString*)insidePolygonWithPoint:(CGPoint)touchpoint{
    if (self.currentFloorId == outDoorId) {
        //循环是用来得到一个区域块的点位数据
        for (OneRegionModel* oneReg in self.regionPointArray1) {
            //循环得到一个xy坐标
                CGMutablePathRef pathRef = CGPathCreateMutable();
                double startX = 0 ;
                double startY = 0 ;
                for (int i = 0; i<[oneReg.regionArray count]; i++) {
                    NSArray* pointXY = oneReg.regionArray[i];
                    double x = [pointXY[0] doubleValue];
                    double y = [pointXY[1] doubleValue];
                    
                    if (i== 0) {
                        startX = x;
                        startY = y;
                        CGPathMoveToPoint(pathRef, NULL, x, y);
                    }else if(i == [oneReg.regionArray count] - 1){
                        CGPathAddLineToPoint(pathRef, NULL, x, y);
                        CGPathAddLineToPoint(pathRef, NULL, startX, startY);
                        CGPathCloseSubpath(pathRef);
                    }else{
                        CGPathAddLineToPoint(pathRef, NULL, x, y);
                    }
                    
                if (CGPathContainsPoint(pathRef, NULL, touchpoint, NO)) {
                    
                    return oneReg.name;
                }
            }
        }
    }else if(_currentFloorId == 684545){
        for (OneRegionModel* oneReg in self.regionPointArray) {
            //循环得到一个xy坐标
            CGMutablePathRef pathRef = CGPathCreateMutable();
            double startX = 0 ;
            double startY = 0 ;
            for (int i = 0; i<[oneReg.regionArray count]; i++) {
                NSArray* pointXY = oneReg.regionArray[i];
                double x = [pointXY[0] doubleValue];
                double y = [pointXY[1] doubleValue];
                
                if (i== 0) {
                    startX = x;
                    startY = y;
                    CGPathMoveToPoint(pathRef, NULL, x, y);
                }else if(i == [oneReg.regionArray count] - 1){
                    CGPathAddLineToPoint(pathRef, NULL, x, y);
                    CGPathAddLineToPoint(pathRef, NULL, startX, startY);
                    CGPathCloseSubpath(pathRef);
                }else{
                    CGPathAddLineToPoint(pathRef, NULL, x, y);
                }
                
                if (CGPathContainsPoint(pathRef, NULL, touchpoint, NO)) {
                    
                    return oneReg.name;
                }
            }
        }
    }else{
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (_currentFloorId == floorRegion.floorid.integerValue) {
                return [NSString stringWithFormat:@"%@-%@",floorRegion.mapName,floorRegion.floorName] ;
            }
        }
    }
    return @"";
}
/** 检查某点是否包含在多边形的范围内(只用与判断在多边形内部，不包含点在多边形边上的情况)~ */

-(void)addfeatureLabel{
    self.featureLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 74, 280, 40)];
//    [self.featureLabel setFont:[UIFont systemFontOfSize:15]];
    self.featureLabel.adjustsFontSizeToFitWidth = YES;
    [self.mapView addSubview:self.featureLabel];
}

-(void)addCompassView{
    //添加指南针视图
    self.compassView = [[CompassView alloc]init];
    [self.view addSubview:self.compassView];
}
- (void)mapViewDidRotating:(NGRMapView *)mapView rotation:(CGFloat)rotation{
    
    [self.compassView compassViewRotateWithAngleFromNorth: mapView.angleFromNorth -54.2074];
    
    //定位点的旋转
    _currentAngleMap = - mapView.angleFromNorth* M_PI/180-54.2074 ;
    
}
-(void)addChangeFloorBGViewToolView
{
    self.floorChangeToolView = [[changeFloorToolView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.floorChangeToolView.delegate = self;
    [self.view addSubview:self.floorChangeToolView];
}


-(void)setDistanceFromEndPoint:(int)distance{
    
    int time  = (int)distance/1.5/60;
    
    time<1? time=1:time;
    
    
    NSString* str = [NSString stringWithFormat:@"距离目的地%d米,需要步行%d分钟",distance,time];
    _labelDistance.text = str ;
    
}


-(void)changeLocationEngineer{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //定位点旋转 90 ＋ 110
    _locationOverlayer.view.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading * M_PI/180.0 + _currentAngleMap +25);
}

-(void)changeMainView:(UIButton*)sender{
    
}

/**
 *  选择wifi定位
 */
-(void)selectWifi{
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]){

        __weak typeof (self) weakSelf = self;
        NSString *urlStr = @"http://10.11.88.104/cgi-bin/mac.sh";
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSString* macStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (macStr.length>0) {
                macStr = [macStr substringToIndex:macStr.length - 1];
                weakSelf.wifiManager = [[NGRPositioningManager alloc]initWithMacAddress:macStr appKey:@"" url:@"http://10.11.88.108:80/comet/"];
                weakSelf.wifiManager.poll = YES;
                weakSelf.wifiManager.timeInterval = 2000;
                weakSelf.wifiManager.timeout = 3;
                weakSelf.wifiManager.delegate = weakSelf;
                [weakSelf.wifiManager start];
                
            }else{
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"未获得mac地址" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }];
//    }else{
//        self.wifiManager = [[NGRPositioningManager alloc]initWithMacAddress:@"60:F8:1D:01:47:04" sceneId:10176 url:@"http://location.palmap.cn/comet/"];
//        self.wifiManager.poll = YES;
//        self.wifiManager.timeInterval = 2000;
//        self.wifiManager.delegate = self;
//        [self.wifiManager start];
//
//    }
    
}


/**
 *  定位点变化
 *  @param oldLocation 老定位点
 *  @param newLocation 新定位点
 */
- (void)didLocationChanged:(NGRLocation *)oldLocation newLocation:(NGRLocation *)newLocation status:(NGRLocationStatus)status{
  //如果是定位到室外区域就是写室外区域室内区域就写室内区域
  
    if (status == MOVE) {
        if (newLocation.point.x == 0) {
            return;
        }
    
        _locationFloorId = newLocation.floorId;
        ShowOMGToast(@"move");
        if (newLocation.floorId==outDoorId) {
            self.locationFloorName = @"户外";
        }else{
            self.locationFloorName = @"室内区域";
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //切割导航线
            if (_isNavigating&&_isNavigatingActualTime&&_currentFloorId==newLocation.floorId)
            {
//                [self.navigationManager clipFeatureCollectionByCoordinate:newLocation.point];
//                self.isClipNavigationLine =YES;
            }
            
            self.currentLocation = newLocation;
            self.currentLocationPoint = newLocation.point;
            //当前楼层等于定位点的楼层号不进行自动楼层切换只进行定位点的位移。
            if (_currentFloorId == newLocation.floorId)
            {
                CGFloat pointdistance = [self.navigationManager getMinDistanceByPoint:newLocation.point];
                CGPoint adsorbPoint;
                if (pointdistance<5&& pointdistance!=0) {
                    adsorbPoint = [self.navigationManager getPointOfIntersectioanByPoint:self.currentLocationPoint] ;
                }else{
                    adsorbPoint = newLocation.point;
                }
                
                self.shouldAutoChangFloor = YES;

                if (_currentFloorId == newLocation.floorId)
                {
                    [self.mapView addOverlayer:_locationOverlayer];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        _locationOverlayer.view.center = [self.mapView getScreenPositionFromWorldPosition:adsorbPoint];
                         _locationOverlayer.worldPosition = adsorbPoint;
                        
                    }];
                }
            }//当前楼层不等于定位点的楼层，进行自动切换楼层的逻辑判断
            else if (self.shouldAutoChangFloor == YES&&self.autoChangeMapButton.hidden==YES){
                
                self.autoChangeMapButton.hidden = NO;
                self.interval = 15;
                self.autoChangeMaptimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeSubtract) userInfo:nil repeats:YES];
                NSRunLoop* runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:self.autoChangeMaptimer forMode:NSDefaultRunLoopMode];
                
                
        }
        
        });
    }else{
        ShowOMGToast(self.locationErrorState[status]);
    }
}
/*!
 * @brief 定位异常回调方法
 * @param state - 异常参考NGRDataSourceState
 */
- (void)didLocationError:(NGRLocationStatus)status{
    
//    ShowOMGToast(self.locationErrorState[status]);
}
-(void)getMacStr{
    NSString *urlStr = @"http://10.11.88.104/cgi-bin/mac.sh";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString* macStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if (macStr) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"获取到了2mac地址：" message:macStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"获取不到2mac" message:macStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
}

#pragma mark-初始化地图的代码
-(void)addMapData
{
    _selectPinOverlayer = [[NGROverlayer alloc] init];
    UIImageView *selectPinView = [[UIImageView alloc] init];
    selectPinView.frame = CGRectMake(0, 0, 30, 30);
    selectPinView.image=[UIImage imageNamed:@"定位"];
    selectPinView.layer.anchorPoint = CGPointMake(0.5, 1);
    _selectPinOverlayer.view = selectPinView;

    [self.mapView registerGestures];
    
    if (!_dataSource) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]) {
            _dataSource = [[NGRDataSource alloc] initWithRoot:@"http://10.11.88.105/"];
//            _dataSource = [[NGRDataSource alloc] init];
        }else{
            _dataSource = [[NGRDataSource alloc] init];
        }
        _dataSource.delegate = self;
        _dataSource.timeout = 20;
    }
    
    self.mapView.delegate=self;
    ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    [self requestMapOutDoorWithSearchPoi:nil];
    //第一次加载地图可以自动切换
    
    self.shouldAutoChangFloor = YES;
}
-(void)requestMapOutDoorWithAlert{
     ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    [self requestMapOutDoorWithSearchPoi:nil];
}
#pragma mark-加载地图完毕
-(void)requestMapOutDoorWithSearchPoi:(NGRLocationModel*)searchPoiModel{
    
    
    
    self.shouldAutoChangFloor = NO;
    NSInteger errorFloorIdDataBack = _currentFloorId;//导航失败的时候回复原来的floorid
    self.currentFloorId = 665520;
    //在切换楼层的这个时间差内currentfloorid＝＝newlocation.floorid会开启自动切换楼层所以在手动切换楼层的时候要先改变floorid

    _floorChangeToolView.hidden = YES;
   
    _currentFloorName = @"室外马路上";
    _floorChangeToolView.hidden = YES;

    __weak typeof (self)weakSelf = self;

        [self.dataSource requestPlanarGraph:665520 success:^(NGRPlanarGraph *planarGraph) {
            weakSelf.outdoorButton.hidden = YES;
              HideHPDProgress;
            [weakSelf startDraw:planarGraph];
          
            [weakSelf.mapView visibleAllLayerFeature:@"Area" isVisible:NO];
            [weakSelf.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];
            //            [self.mapView setMaxZoom:900];//缩小665520
            //            [self.mapView setMinZoom:250];//放大
            //            [self.mapView zoom:1.5 animated:YES duration:100];
            
            if (searchPoiModel) {
                NGRFeature *feature =  [weakSelf.mapView searchFeatureWithId:searchPoiModel.ID];
                
                CGPoint point = [feature getCentroid];
                
                [weakSelf addOverlayer:weakSelf.selectPinOverlayer andScreenPoint:[weakSelf.mapView getScreenPositionFromWorldPosition:point] andFloorId:searchPoiModel.parentID];
            }
           
            
            [weakSelf.mapView rotateIn:weakSelf.mapView.center andAngle:-54.2];
              [weakSelf.mapView resetOverlayers];
            if (weakSelf.currentLocationPoint.x!=0&&weakSelf.currentFloorId==weakSelf.locationFloorId) {
                [weakSelf.mapView moveToPoint:weakSelf.currentLocationPoint animated:NO duration:300];
            }
            if (!weakSelf.hasOpenWifiLocation) {
                [weakSelf selectWifi];
                weakSelf.hasOpenWifiLocation = YES;
            }
            
            /**
             *  绘制导航线的
             */
            weakSelf.currentFloorId = 665520;
            [weakSelf.navigationManager switchPlanarGraph: 665520];
            
        } error:^(NSError *error) {
            HideHPDProgress;
            NSArray* arr =@[@"OK",@"不支持协议",@"连接失败",@"访问被拒绝",@"Http返回错误",@"读本地文件错误",@"未知错误",@"timeout",@"cache"];
            
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"加载地图失败" message:arr[error.code] delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            weakSelf.currentFloorId = errorFloorIdDataBack;
//            OK = 0,
//            UNSUPPORTED_PROTOCOL,	//不支持协议
//            COULDNT_CONNECT,		//连接失败
//            REMOTE_ACCESS_DENIED,	//访问被拒绝
//            HTTP_RETURNED_ERROR,	//Http返回错误
//            READ_ERROR,				//读本地文件错误
//            UNKNOWN_ERROR,          //未知错误
//            OPERATION_TIMEDOUT,     //timeout
//            CACHE                   //cache
        }];

}
#pragma mark-加载地图

- (void)mapViewDidEndZooming:(NGRMapView *)mapView{
    //    NSLog(@"zoomLevel=%ld",(unsigned long)mapView.zoomLevel);
    if (mapView.zoomLevel >= 4) {
        [self.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];
    }else{
        [self.mapView visibleAllLayerFeature:@"Facility" isVisible:YES];
    }
}





/*!
 * @brief 蓝牙拉取数据库失败
 */
- (void)didDownloadDatabaseError{
    
}
//3    672784  673073   (x = 12188991, y = 2071224.25)

//2    672424  672784 (x = 12188980, y = 2071207)
#pragma mark-uitableview的回调方法711007  711398
-(void)tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:(NSInteger)floorid andFloorName:(NSString*)floorName WithSearchPoi:(NGRLocationModel*)searchPoiModel{
    
    
    ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    self.currentFloorName = floorName;
    self.currentFloorId = floorid;
    self.shouldAutoChangFloor = NO;
    __weak typeof(self)weakSelf = self;

    [self.dataSource requestPlanarGraph:floorid success:^(NGRPlanarGraph *planarGraph) {
        
            HideHPDProgress;
        [weakSelf startDraw:planarGraph];
      
        if (searchPoiModel) {
            NGRFeature *feature =  [weakSelf.mapView searchFeatureWithId:searchPoiModel.ID];
            
            CGPoint point = [feature getCentroid];
            
            [weakSelf addOverlayer:weakSelf.selectPinOverlayer andScreenPoint:[weakSelf.mapView getScreenPositionFromWorldPosition:point] andFloorId:searchPoiModel.parentID];
        }

//        [weakSelf.mapView visibleAllLayerFeature:@"Area" isVisible:NO];
        [weakSelf.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];
        //        [weakSelf.mapView setMaxZoom:300];//缩小665520
        //        [weakSelf.mapView setMinZoom:40];//放大
        if (weakSelf.mapView.currentID) {
            NSLog(@"weakSelf.mapView.currentID＝%llu",weakSelf.mapView.currentID);
            [weakSelf.navigationManager switchPlanarGraph:weakSelf.mapView.currentID];
        }
        
        [weakSelf.mapView rotateIn:weakSelf.mapView.center andAngle:-54.2];
           [weakSelf.mapView resetOverlayers];
        
        if (weakSelf.currentLocationPoint.x!=0&&floorid==weakSelf.locationFloorId) {
            [weakSelf.mapView moveToPoint:weakSelf.currentLocationPoint animated:NO duration:300];
        }
        HideHPDProgress;
    } error:^(NSError *error) {
        HideHPDProgress;
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    HideHPDProgress;
    [self.autoChangeMaptimer invalidate];
    self.autoChangeMaptimer = nil;
}
#pragma mark-进入室内地图进入室内的数据处理
/**
 *  进入室内的方式
 *
 *  @param mapid   如果是0代表是_selectedIndoorID 否则是传过来的mapid（传过来的是定位楼层反查询获取的）
 *  @param floorID 如果是0代表跳转自定位到的楼层不用跳转default楼层了
 */
-(void)comeInInDoorMapWithMapID:(NGRID)mapid andFloorID:(NGRID)floorID WithSearchPoi:(NGRLocationModel*)searchPoiModel{
  self.shouldAutoChangFloor = NO;
   
    _currentFloorId =0;

    long validMapid;
    if (mapid == 0 ) {
        validMapid = _selectedIndoorID;
    }else{
        validMapid = mapid;
    }
    __weak typeof(self) weakSelf = self;
    [_dataSource requestPoiChildren:validMapid success:^(NSArray *pois){
         HideHPDProgress;
        if (pois.count==0) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"没有楼层数据" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return ;
        }
        
        [weakSelf.floorChangeToolView restart];

        //颠倒顺序
        for (long i = pois.count - 1; i >= 0; i--) {
            NGRFloorModel* floor = pois[i];
            if (floor.address ==nil) {
                continue;
            }else{
                
                NSArray *nameArray = [floor.address componentsSeparatedByCharactersInSet: [NSCharacterSet
                                                                           characterSetWithCharactersInString:@"-"]];
            
               NSString* primaryStr = [weakSelf.floorNameDic objectForKey:nameArray[0]];
            
                NSString* prefectName = [NSString stringWithFormat:@"%@%@",primaryStr,nameArray[1]];
                
                 [weakSelf.floorChangeToolView.floorNameDataArray addObject:prefectName];
                
                [weakSelf.floorChangeToolView.floorNumberDataArray addObject:[NSNumber numberWithInt:(int)floor.ID]] ;
            }
            
        }
        //点击进入室内按钮，所以没有floorid
        if (floorID==0) {
            BOOL hasLoadFloor = NO;
            for (int i = 0; i< weakSelf.floorChangeToolView.floorNameDataArray.count; i++) {
                NSString* floorAddress = weakSelf.floorChangeToolView.floorNameDataArray[i];
                if ([[[floorAddress componentsSeparatedByString:@"-"]lastObject]isEqualToString:@"F1"]) {
                    
                    hasLoadFloor = YES;
                    [weakSelf.floorChangeToolView reLoadDataWithSelectRow:i];
                    NSInteger floorID = [[weakSelf.floorChangeToolView.floorNumberDataArray objectAtIndex:i] integerValue];
                    [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:floorID andFloorName:floorAddress WithSearchPoi:searchPoiModel];
                }
                
            }
            if (hasLoadFloor==NO) {
                NSInteger floorID =  [[weakSelf.floorChangeToolView.floorNumberDataArray lastObject] integerValue];
                NSString* floorAddress =[weakSelf.floorChangeToolView.floorNameDataArray lastObject];
                [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:floorID andFloorName:floorAddress WithSearchPoi:searchPoiModel ];
                [weakSelf.floorChangeToolView reLoadDataWithSelectRow:weakSelf.floorChangeToolView.floorNumberDataArray.count-1];
            }

        }else{
            //自动切换楼层的
            for (int i = 0; i< weakSelf.floorChangeToolView.floorNumberDataArray.count; i++) {
                
                if ([weakSelf.floorChangeToolView.floorNumberDataArray[i] integerValue] ==floorID) {
                    [weakSelf.floorChangeToolView reLoadDataWithSelectRow:i];
                    NSInteger intfloorID = [[weakSelf.floorChangeToolView.floorNumberDataArray objectAtIndex:i] integerValue];
                    NSString* floorAddress =[weakSelf.floorChangeToolView.floorNameDataArray objectAtIndex:i];
                    [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:intfloorID andFloorName:floorAddress WithSearchPoi:searchPoiModel];
                }
                
            }
        }
        
        
        weakSelf.outdoorButton.hidden = NO;
        
    
    } error:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"没有楼层数据" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        HideHPDProgress;
    }];
    
}



-(void)navigationViewAppear{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _searchStartAndEndDiv.frame = CGRectMake(15, 0, kScreenWidth -30, 176);
        
    }];
}

-(void)navigationViewDisappear{
    HideHPDProgress;
  
    [UIView animateWithDuration:0.5 animations:^{
        _searchStartAndEndDiv.frame = CGRectMake(15, 186 - 98, kScreenWidth -30, 88);
    }];
    
}
#pragma mark-获取起点终点的方法
-(void)getfeaturestartend{
    //    CGPoint navigationEndPoint = [_navigationManager getPointFromFeatureCollection:featureCollection atIndex:lastPointIndex];
    //    CGPoint navigationStartPoint = [_navigationManager getPointFromFeatureCollection:featureCollection atIndex:0];
}
- (void)dealloc
{
    _dataSource.delegate = nil;
    
}
#pragma mark-搜索相关
-(void)searchPoiWithDestinationString:(NSString*)destination andNeewShowAlert:(BOOL)need{
    
    [_dataSource searchPOI:destination start:0 count:30 parents:@[[NSNumber numberWithInt:665520]] categories:nil];
    
    _needShowAlertForNoSearchResult = need;
}

-(touchPointData*)searchVCgetCurrentUserLocation{
    
    return [self UserCurrentLocation];
}

/**
 *  切换到刚开始的楼层
 */
-(void)changetoStartpointFloor{
    //    if (_currentFloorId != _selectStartAndEndPintView.selectStartData.floorID ) {
    //        NSInteger index = [_floorNumberDataArray indexOfObject:[NSNumber numberWithInteger: _selectStartAndEndPintView.selectStartData.floorID]];
    ////        NSString* floorName = [_floorDataArray objectAtIndex:index];
    ////        [_tableViewOfFloors selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    //
    ////        [_tableViewOfFloors setContentOffset: CGPointMake(0, 44*( index)) animated:YES];
    //        [_dataSource requestPlanarGraph:_selectStartAndEndPintView.selectStartData.floorID];
    //        _currentFloorId = _selectStartAndEndPintView.selectStartData.floorID;
    //
    //    }
}


#pragma mark-导航相关
-(void)addCancelNavigateButton{
    self.cancelNavigateProcess = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelNavigateProcess.frame = CGRectMake(kScreenWidth - 60, 74, 50, 30);
    [self.cancelNavigateProcess setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelNavigateProcess addTarget:self action:@selector(dismissNavigationToolView) forControlEvents:UIControlEventTouchUpInside];
    self.cancelNavigateProcess.backgroundColor = [UIColor lightGrayColor];
    self.cancelNavigateProcess.layer.cornerRadius = 3;
    self.cancelNavigateProcess.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cancelNavigateProcess.layer.shadowOffset = CGSizeMake(0, 0);
    self.cancelNavigateProcess.layer.shadowOpacity = 0.9;//阴影透明度，默认0
    self.cancelNavigateProcess.layer.shadowRadius = 6;
    self.cancelNavigateProcess.alpha = 0;
    [self.view addSubview:self.cancelNavigateProcess];
    
}
/**
 *  用户当前位置
 *
 *  @return touchpoint类
 */
- (touchPointData*)UserCurrentLocation{
    if (_currentLocationPoint.x == 0) {
        return  nil;
    }
    touchPointData* touchpoint = [[touchPointData alloc]init];
    touchpoint.floorID =_locationFloorId ;
    touchpoint.location = _currentLocationPoint;
    touchpoint.floorName = self.locationFloorName;
    
    return touchpoint;
}

/**
 *  调用导航的接口导航
 *  @param startPoi 起点
 *  @param endPoi   终点
 */
- (void)shopPopoverViewnavigationWithStartData:(touchPointData *)startPoi EndData:(touchPointData *)endPoi{
    
    
    if (!_navigationManager) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]) {
             _navigationManager = [[NGRNavigateManager alloc] initWithUrl:@"http://10.11.88.105/"];
           
        }else{

//            _navigationManager = [[NGRNavigateManager alloc] initWithUrl:@"http://172.16.10.113:8080/nagrand-service/"];
            _navigationManager = [[NGRNavigateManager alloc] init];
        }
        
        _navigationManager.delegate = self;
        _navigationManager.timeout = 7;
    }
    [_navigationManager navigationFromPoint:startPoi.location fromFloor:startPoi.floorID toPoint:endPoi.location toFloor:endPoi.floorID defaultFloor:self.mapView.currentID];
    
    ShowHudViewOnSelfViewWithMessage(@"正在加载导航数据");
  
    [self navigationViewAppear];
    _isNavigating = YES;//这个时候让点击事件无效直到结束之后再变成NO
    
    
}


#pragma mark-点击地图相关点击事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex=%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    ;
}

-(void)touchPoint:(CGPoint)point withFeature:(NGRFeature *)feature {
    
    NSString* regionName = [self insidePolygonWithPoint:[self.mapView getWorldPositionFromScreenPosition:point]];
}

//(x = 12189120, y = 2071017.875) 687255
//(x = 12189069, y = 2070789.875) 686809
//(x = 12189144, y = 2070989.5) 686809
-(void)addOverlayer:(NGROverlayer*)overlayer andScreenPoint:(CGPoint)screenPoint andFloorId:(NGRID)floorid{
    
   
        overlayer.worldPosition = [self.mapView getWorldPositionFromScreenPosition:screenPoint];
        overlayer.floorId = floorid;
        [self.mapView addOverlayer: overlayer];
    
}

-(void)timeSubtract{
    
    NSMutableString * floorName = [NSMutableString stringWithCapacity:40];
    if (_locationFloorId ==outDoorId) {
        [floorName appendString:@"户外"];
    }else{
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (_locationFloorId == floorRegion.floorid.integerValue) {
                [floorName appendString:floorRegion.mapName];
                [floorName appendString:floorRegion.floorName];
            }
        }
    }
    [self.autoChangeMapButton setTitle:[NSString stringWithFormat:@"%lds后,进入%@",(long)self.interval,floorName] forState:UIControlStateNormal];
    
    if (self.interval == 0){
        [self.autoChangeMaptimer  invalidate];
        self.autoChangeMaptimer = nil;
        [self autochangfloor];
        
        
    }else{
        self.interval--;
    }
}
-(void)autochangfloor{
    [self.autoChangeMaptimer  invalidate];
    self.autoChangeMaptimer = nil;
    //防治在自动切换楼层的时候重新规划路径
    if (_locationFloorId == 0) {
        return;
    }
    if (_locationFloorId ==outDoorId) {
        [self requestMapOutDoorWithSearchPoi:nil];
    }else{
        NSInteger currentMapid = 0;//主要是判断是否是当前楼层，如果是当前楼层的话就不用切换了
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (_currentFloorId == floorRegion.floorid.integerValue) {
                currentMapid = floorRegion.mapID.integerValue;
            }
        }
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (_locationFloorId == floorRegion.floorid.integerValue) {
                if (floorRegion.mapID.integerValue == currentMapid) {
                    //如果楼层本来就在当前楼层就自动切换楼层
                    for (int i = 0; i< self.floorChangeToolView.floorNumberDataArray.count; i++) {
                        if ([self.floorChangeToolView.floorNumberDataArray[i] integerValue] ==_locationFloorId) {
                            [self.floorChangeToolView reLoadDataWithSelectRow:i];
                            NSInteger intfloorID = [[self.floorChangeToolView.floorNumberDataArray objectAtIndex:i] integerValue];
                            NSString* floorAddress =[self.floorChangeToolView.floorNameDataArray objectAtIndex:i];
                            [self tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:intfloorID andFloorName:floorAddress WithSearchPoi:nil];
                        }
                    }
                }else{
                    [self comeInInDoorMapWithMapID:floorRegion.mapID.integerValue andFloorID:_locationFloorId WithSearchPoi:nil];
                    
                }
               _currentFloorId = _locationFloorId;//15分钟自动切换或者点击切换。
                
            }
        }
        
    }
    self.autoChangeMapButton.hidden = YES;
}
@end