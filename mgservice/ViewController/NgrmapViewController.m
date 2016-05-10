//
//  NgrmapViewController.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/10/19.
//  Copyright © 2015年 palmaplus. All rights reserved.
// 686809 687255 688317

#import "NgrmapViewController.h"
#import "UIButton+Bootstrap.h"
#import "SelectStartingAndEndPoint.h"
#import "NavigationView.h"
#import "PointView.h"
#import <Nagrand/NGROverlayer.h>
#import "InSearchViewController.h"
#import "CompassView.h"
#import "BubblePopView.h"
#import "BubblePopView1.h"
#import "changeFloorToolView.h"
#import "MBProgressHUD.h"
#import "HPDProgress.h"
#import "FloorRegionModel.h"
#import "OneRegionModel.h"
#import "CollectionMessage.h"
#import "LocationErrorView.h"
#import "EnumAndDefine.h"
#import "InTaskController.h"

#define SCREENBOUNDS [UIScreen mainScreen].bounds
#define outDoorId 665520
/// show hud view
#define ShowHudViewOnSelfViewWithMessage(msg)    [[HPDProgress defaultProgressHUD] showHUDOnView:self.view message:msg]
#define HideHPDProgress                                     [[HPDProgress defaultProgressHUD] hide]

#define ShowOMGToast(msg)                                   [OMGToast showWithText:msg bottomOffset:70 duration:1];
typedef NS_ENUM(NSInteger, parkingState) {
    parking = 0,
    modifyParking,
    findingCar
};

@interface NgrmapViewController ()<NGRDataSourceDelegate,NGRMapViewDelegate,NGRNavigateManagerDelegate,NGRPositioningDelegate,selectStartAndEndPointDelegate,CLLocationManagerDelegate,searchPoiDelegate,floorChangeDelegate>{
    
    NGRFeatureLayer* _NgrFeatureLayerLocation;
    NGRFeatureLayer* _positionLayer;
    touchPointData* _startFloorData;
    touchPointData* _endFloorData;
    NGRFeatureLayer *_naviLayer;
    NGROverlayer * _selectStartAndEndOverlayer;
    NGROverlayer * _popImageOverlayerStart;//中间的过程的对话气泡
    NGROverlayer * _popImageOverlayerEnd;
    UIImageView *_selectPinView;
    UIImageView * _selectStartPinView;
    UIImageView *  _selectEndPinView;
    CLLocationManager* _locationManager;
    NGRPositioningManager* blueManager;
    CGFloat _currentAngleMap;
    CGPoint  _floorChangeButtoncenter;
    UISegmentedControl* _segmentCallOrNavigation ;
    UIButton* _selectstartButton;
    UIButton* _selectEndButton;
    CGPoint _appearCenterPoint;//手指点的地图位置
    BOOL _hasNavigatioLine;
    BOOL _isNavigatingActualTime;
    BubblePopView* _bubblePopStart;
    BubblePopView1* _bubblePopEnd;
    NSInteger _selectedIndoorID;
    UILabel* _labelDistance;
    BOOL _needShowAlertForNoSearchResult;
    UIImageView *_locationImageView;
}
@property (nonatomic,assign)NSInteger selectedIndex;
@property (strong,nonatomic)InSearchViewController* searchVC;
@property (assign,nonatomic)unsigned long floorTableViewStartPoint;
@property (strong,nonatomic)CompassView* compassView;
@property (strong,nonatomic)NavigationView* navigationStartView;
@property (strong,nonatomic)NSMutableArray* indoorPoiIdArray;
@property (strong,nonatomic)UIButton* outdoorButton;
@property (strong,nonatomic) NGRLocation *currentLocation;
@property (strong,nonatomic)changeFloorToolView* floorChangeToolView;
@property (strong,nonatomic)NGRPositioningManager* wifiManager;
@property (strong,nonatomic)SelectStartingAndEndPoint *selectStartAndEndPintView;//点击弹出底部界面
@property (strong,nonatomic)  NGRNavigateManager *navigationManager;
@property(strong,nonatomic) NSMutableArray* regionArray;
@property(assign,nonatomic)NGRID currentFloorId;
@property(strong,nonatomic)NGRDataSource *dataSource;
@property(strong,nonatomic)UIView* searchStartAndEndDiv;
@property(strong,nonatomic)NGROverlayer *selectStartOverlayer;
@property(strong,nonatomic) NGROverlayer *selectEndOverlayer;
@property(assign,nonatomic)BOOL hasOpenWifiLocation;
@property(assign,nonatomic)CGPoint navigationEndPoint;
@property(assign,nonatomic)BOOL shouldAutoChangFloor;
@property(strong,nonatomic)UIActionSheet* selectStartAndEndSheet;
@property(copy,nonatomic)NSString* currentFloorName;
@property(strong,nonatomic)NGROverlayer* locationOverlayer;
@property(nonatomic,strong)NSMutableDictionary* floorNameDic;
@property(nonatomic,assign)BOOL isClipNavigationLine;
@property(nonatomic,assign) CGPoint currentLocationPoint;
@property(nonatomic,strong)NSArray* locationErrorState;
@property(nonatomic,assign)NGRID locationFloorId;
@property(nonatomic,assign)NSInteger distanceCount;
@property(nonatomic,strong)NGROverlayer *selectPinOverlayer;
@property(strong,nonatomic)NSMutableArray* jsonFloorDataArray;
@property(nonatomic,strong)NSMutableArray* regionPointArray_45;
@property(nonatomic,strong)NSMutableArray* regionPointArrayOutDoor;
@property(nonatomic,strong)NSTimer* autoChangeMaptimer;
@property(nonatomic,strong)UIButton* autoChangeMapButton;
@property(nonatomic,assign)NSInteger interval;
@property(nonatomic,assign)CGPoint AngelpointCenter;
@property(nonatomic,assign)double autoRotationangle;
@property(nonatomic,assign)CGPoint navigationStartPoint;
@property(nonatomic,assign)BOOL isRequestingMap;
@property(nonatomic,strong)NSTimer* substractionTimer;
@property(nonatomic,assign)NSInteger substractionCount;
@property(nonatomic,strong)NGRFeatureCollection* nowfeaturecollection;
@property (strong,nonatomic)UIButton* Locationbtn;
@property(strong,nonatomic)NSMutableArray* collectionArray;
@property(strong,nonatomic)CollectionMessage* selectStartDisData;
@property(strong,nonatomic)CollectionMessage* selectEndDisData;
@property(strong,nonatomic)UIAlertView* finishNavAlert;
@property(strong,nonatomic)LocationErrorView* alertlocationEView;
@property(strong,nonatomic)UIButton* cancelNavigationButton;
@property (retain, nonatomic) UIBarButtonItem *rightBarButton;


@property (weak, nonatomic) IBOutlet UIView *inTaskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inTaskBottom;

@end

@implementation NgrmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inTaskTop.constant = kScreenHeight - 64;
    self.title = @"当前执行中任务";
    self.navigationItem.hidesBackButton = YES;
    self.inTaskTop.constant = self.view.frame.size.height - 124;
    self.inTaskBottom.constant = 64 - self.view.frame.size.height;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartDrawMap) name:NotiStartDrawMap object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopDrawMap) name:NotiStopDrawMap object:nil];
    
    [self configMapView:nil];
    _locationFloorId = 0;
    self.interval = 0;
    self.selectStartDisData = [[CollectionMessage alloc]init];
    self.selectEndDisData = [[CollectionMessage alloc]init];
    self.indoorPoiIdArray = [NSMutableArray array];
     self.navigationEndPoint = CGPointMake(0, 0);
    self.regionArray = [NSMutableArray array];
    self.jsonFloorDataArray = [NSMutableArray array];
    self.collectionArray = [NSMutableArray array];
    FloorRegionModel* floorRegion =[[FloorRegionModel alloc]init];
    floorRegion.floorid = @665520;
    floorRegion.floorName =@"道路上";
    floorRegion.mapID = @665520;
    floorRegion.mapName = @"户外";
    [self.jsonFloorDataArray  addObject:floorRegion];
    self.jsonFloorDataArray = [NSMutableArray array];
    self.regionPointArray_45 = [NSMutableArray array];
    self.regionPointArrayOutDoor = [NSMutableArray array];
    self.distanceCount = 0;
    self.mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.mapView.mapOptions.skewEnabled = NO;
//    self.mapView.mapOptions.sigleTapEnabled = NO;
    self.mapView.mergeGesture = true;
    self.mapView.transferGesture = true;
    self.mapView.fitScreenRatio = 1.0;
    _searchVC = [[InSearchViewController alloc]init];
    _searchVC.delegate = self;
    _currentLocationPoint = CGPointMake(0, 0);
//    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     //添加定位错误状态
    [self addlocationErrorState];
     //添加楼层列表
//    [self addFloorData];
     //切换楼层相关的
    [self addChangeFloorBGViewToolView];
     //添加地图数据
    [self addMapData];
     //添加选择起始点的view
//    [self addSelectStartAndEndView];
     //添加起始点的图片
//    [self addStartAndEndPointImageView];
     //添加起始点的图片添加导航头头的view
//    [self addTitleView];
     //添加起始点的图片搜索开始和结束的div
//    [self addSearchStartAndEndDiv];
     //加入指南针
    [self addCompassView];
     //已经开始导航之后的界面
//    [self addNavigationStartView];
     //添加左气泡
//    [self addProcessOverlayer];
     //添加限定区域的代码
//    [self addRegionPointData];
    //自动转换定位点偏角
    [self addLocationCompass];
    //添加长按事件
//    [self addLongTapGes];
    //添加定位的那个按钮
    [self addLocationButton];
     //顶部自动切换楼层的计时代码。
    [self addAutochangeMapButton];
     // 添加定位失败的提示
    [self addAlertLocationErrorView];
    //改变背景颜色
    [self.mapView setBackgroundColor:rgba(192, 192, 192, 0.8)];
}
-(void)viewWillDisappear:(BOOL)animated{
    HideHPDProgress;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.autoChangeMaptimer invalidate];
    self.autoChangeMaptimer = nil;
    [self.substractionTimer invalidate];
    self.substractionTimer = nil;
    self.intaskController.mapViewController = nil;
    self.intaskController = nil;
}

-(void)addAutochangeMapButton{
    self.autoChangeMapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.autoChangeMapButton addTarget:self action:@selector(autochangfloor) forControlEvents:UIControlEventTouchUpInside];
    self.autoChangeMapButton.frame = CGRectMake(75, 94, kScreenWidth-150, 20);
    [self.view addSubview:self.autoChangeMapButton];
    self.autoChangeMapButton.titleLabel.numberOfLines = 1;
    self.autoChangeMapButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.autoChangeMapButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.autoChangeMapButton setBackgroundColor:[UIColor lightGrayColor]];
    self.autoChangeMapButton.hidden = YES;
}

-(void)addAlertLocationErrorView{
    self.alertlocationEView = [[LocationErrorView alloc]initWithFrame:CGRectMake(75, 74, kScreenWidth-150, 20)];
    [self.view addSubview:self.alertlocationEView];
    self.alertlocationEView.backgroundColor = [UIColor lightGrayColor];
    self.alertlocationEView.hidden = YES;
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
//去掉自动跳转的功能
-(void)cancelAutochangeFloorTimer{
    [self.autoChangeMaptimer  invalidate];
    self.autoChangeMaptimer = nil;
    self.autoChangeMapButton.hidden = YES;
    self.shouldAutoChangFloor = NO;
}
-(void)gotoCurrentCenter{
   touchPointData* currentLocation = [self UserCurrentLocation];
    if (currentLocation) {
        //去掉自动跳转的功能
        [self cancelAutochangeFloorTimer];
        if (_currentLocationPoint.x!=0&&_currentFloorId==_locationFloorId) {
            [self.mapView moveToPoint:_currentLocationPoint animated:NO duration:300];
            [self.mapView resetOverlayers];
        }
        if (_currentFloorId != currentLocation.floorID) {
            if (currentLocation.floorID ==outDoorId) {
                [self requestMapOutDoorWithSearchPoi:nil andsearchType:searchNone];
            }else{
                __weak typeof(self) weakSelf =self;
                [_dataSource requestPoi:currentLocation.floorID success:^(NGRLocationModel *poi) {
                    [weakSelf comeInInDoorMapWithMapID:poi.parentID andFloorID:currentLocation.floorID WithSearchPoi:nil andSearchType:searchNone];
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
-(void)addProcessOverlayer{
    _bubblePopStart = [[NSBundle mainBundle]loadNibNamed:@"BubblePopView" owner:self options:nil][0];
    _bubblePopEnd = [[NSBundle mainBundle]loadNibNamed:@"BubblePopView1" owner:self options:nil][0];
    _bubblePopStart.layer.anchorPoint = CGPointMake(0.7, 1);
    _bubblePopEnd.layer.anchorPoint = CGPointMake(0.3, 1);
    _popImageOverlayerStart = [[NGROverlayer alloc]init];
    _popImageOverlayerStart.view = _bubblePopStart;
    _popImageOverlayerEnd = [[NGROverlayer alloc]init];
    _popImageOverlayerEnd.view = _bubblePopEnd;
  
}
#pragma mark-添加限定区域
//添加限定区域的代码
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
        [self.regionPointArray_45 addObject:oneReg];
    }
    NSString* path2 = [[NSBundle mainBundle]pathForResource:@"regionLocation" ofType:@"json"];
    NSData* pathData2 = [[NSData alloc]initWithContentsOfFile:path2];
    NSArray* jsonArray2 = [NSJSONSerialization JSONObjectWithData:pathData2 options:NSJSONReadingMutableContainers error:nil][@"regions"];
    for (NSDictionary* regionDic in jsonArray2) {
        OneRegionModel* oneReg = [[OneRegionModel alloc]init];
        oneReg.regionArray = regionDic[@"coordinates"];
        oneReg.name = regionDic[@"name"];
        [self.regionPointArrayOutDoor addObject:oneReg];
    }
    
}
-(NSString*)insidePolygonWithPoint:(CGPoint)touchpoint{
    NSString* regionName=@"";
    if (self.currentFloorId == outDoorId) {
        //循环是用来得到一个区域块的点位数据
        for (OneRegionModel* oneReg in self.regionPointArrayOutDoor) {
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
                    regionName = oneReg.name;
                }
            }
        }
    }else{
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (_currentFloorId == floorRegion.floorid.integerValue) {
                if(floorRegion.mapID.integerValue == 684545){
                    for (OneRegionModel* oneReg in self.regionPointArray_45) {
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
                                regionName = oneReg.name;
                            }
                        }
                    }
                }else{
                     regionName =floorRegion.mapName;
                }
               
            }
        }
    }
    return regionName;
}
/** 检查某点是否包含在多边形的范围内(只用与判断在多边形内部，不包含点在多边形边上的情况)~ */
-(void)addNavigationStartView{
    self.navigationStartView = [[[NSBundle mainBundle]loadNibNamed:@"NavigationView" owner:self options:nil]lastObject];
    self.navigationStartView.frame = CGRectMake(0, 0, kScreenWidth , 180);
    self.navigationStartView.center = CGPointMake(kScreenWidth/2, kScreenHeight +90);
    [self.view addSubview:self.navigationStartView];
    [self.navigationStartView.navigationButton addTarget:self action:@selector(dismissNavigationToolView) forControlEvents:UIControlEventTouchUpInside];
    _navigationStartView.navigationButton.userInteractionEnabled = NO;
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
-(void)addTitleView{
    //户外
    self.outdoorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.outdoorButton setImage:[UIImage imageNamed:@"icon_btn_bg_1"] forState:UIControlStateNormal];
    [self.outdoorButton addTarget:self action:@selector(requestMapOutDoorWithAlert) forControlEvents:UIControlEventTouchUpInside];
    self.outdoorButton.frame = CGRectMake(kScreenWidth-40, 74, 40, 40);
    [self.view addSubview:self.outdoorButton];
    self.outdoorButton.hidden = YES;
}

-(void)addChangeFloorBGViewToolView{
    self.floorChangeToolView = [[changeFloorToolView alloc]initWithFrame:CGRectMake(0,64+44+20, 0, 0)];
    self.floorChangeToolView.delegate = self;
    [self.view addSubview:self.floorChangeToolView];
}

-(void)addSearchStartAndEndDiv{
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight - 186, kScreenWidth, 186)];
    [self.view addSubview:bgView];
    _searchStartAndEndDiv = [[UIView alloc]initWithFrame:CGRectMake(10, 186 - 98, kScreenWidth - 20, 88)];
    [bgView addSubview:_searchStartAndEndDiv];
    _searchStartAndEndDiv.layer.cornerRadius = 4;
    _searchStartAndEndDiv.layer.masksToBounds = YES;
    _searchStartAndEndDiv.backgroundColor = rgba(239, 239, 244, 0.9);
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth - 20, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_searchStartAndEndDiv addSubview:lineView];
    UIImageView* startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    [_searchStartAndEndDiv addSubview:startImageView];
    startImageView.image = [UIImage imageNamed:@"ico_setbegin"];
    UIImageView* endImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12,44+12, 20, 20)];
    [_searchStartAndEndDiv addSubview:endImageView];
    endImageView.image = [UIImage imageNamed:@"ico_setend"];
    [_searchStartAndEndDiv addSubview:startImageView];
    [_searchStartAndEndDiv addSubview:endImageView];
    _selectstartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectstartButton.frame = CGRectMake(40+4,0,kScreenWidth - 30 - 40 - 4, 44);
    _selectstartButton.tag = searchStart;
    [_selectstartButton addTarget:self action:@selector(searchSelectStartPoint:) forControlEvents:UIControlEventTouchUpInside];
    [_searchStartAndEndDiv addSubview:_selectstartButton];
    [_selectstartButton setTitle:@"（设置您的起点）" forState:UIControlStateNormal];
    [_selectstartButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_selectstartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _selectstartButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectstartButton.titleLabel.adjustsFontSizeToFitWidth= YES;
    _selectEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectEndButton.frame = CGRectMake(40+4,44,kScreenWidth - 30 -40 - 4, 44);
    _selectEndButton.tag = searchEnd;
    [_selectEndButton addTarget:self action:@selector(searchSelectStartPoint:) forControlEvents:UIControlEventTouchUpInside];
    [_searchStartAndEndDiv addSubview:_selectEndButton];
    [_selectEndButton setTitle:@"（设置您的目的地）" forState:UIControlStateNormal];
    [_selectEndButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_selectEndButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _selectEndButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _selectEndButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //选择完起始点之后加入的view
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 88,kScreenWidth - 20, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [_searchStartAndEndDiv addSubview:lineView1];
    _labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(20, 88, kScreenWidth - 40 - 30, 44)];
    [_searchStartAndEndDiv addSubview:_labelDistance];
    _labelDistance.font = [UIFont systemFontOfSize:17];
    
    UIButton* startNavigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startNavigationButton addTarget:self action:@selector(startNavigate) forControlEvents:UIControlEventTouchUpInside];
    startNavigationButton.frame = CGRectMake(0, 132, (kScreenWidth - 22)/2.0, 44);
    [startNavigationButton loginStyle];
    startNavigationButton.layer.cornerRadius = 0;
    [_searchStartAndEndDiv addSubview:startNavigationButton];
    [startNavigationButton setTitle:@"开始" forState:UIControlStateNormal];
    
    self.cancelNavigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelNavigationButton addTarget:self action:@selector(cancelNavigation) forControlEvents:UIControlEventTouchUpInside];
    self.cancelNavigationButton.frame = CGRectMake(2+(kScreenWidth - 22)/2.0, 132, (kScreenWidth - 22)/2.0, 44);
    [self.cancelNavigationButton loginStyle];
    self.cancelNavigationButton.layer.cornerRadius = 0;
    [_searchStartAndEndDiv addSubview:self.cancelNavigationButton];
    [self.cancelNavigationButton setTitle:@"取消" forState:UIControlStateNormal];
}
-(void)cancelNavigation{
    [self dismissNavigationToolView];
}
- (UIBarButtonItem *)rightBarButton
{
    if (_rightBarButton == nil)
    {
        _rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchSelectStartPoint:)];
        _rightBarButton.tag = searchRightBarButton;
        self.navigationItem.rightBarButtonItem = _rightBarButton;
    }
    return _rightBarButton;
}

- (IBAction)tenM:(id)sender {
}
 //跳转到搜索起始点和终点的页面
-(void)searchSelectStartPoint:(UIButton*)sender{
    _searchVC.searchType = sender.tag;
    [self.navigationController pushViewController:_searchVC animated:YES];
}
-(void)changeLocationEngineer{
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //定位点旋转 90 ＋ 110
    _locationOverlayer.view.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading * M_PI/180.0 + _currentAngleMap +25);
}
-(void)changeMainView:(UIButton*)sender{
    
}

//结束导航
#pragma mark-导航结束a
-(void)dismissNavigationToolView{
    [self endNavigateAppearAllbutton];
    [_selectstartButton setTitle:@"（设置您的起点）" forState:UIControlStateNormal];
    [_selectEndButton setTitle:@"（设置您的目的地）" forState:UIControlStateNormal];
    _hasNavigatioLine = NO;
    HideHPDProgress;
    _selectStartAndEndPintView.selectStartData = nil;
    _selectStartAndEndPintView.selectEndData = nil;
    _selectStartAndEndPintView.selectData = nil;
    [self.mapView removeAllOverlayer];
    [self navigationViewDisappear];
    self.navigationStartView.center = CGPointMake(kScreenWidth/2, kScreenHeight +90);
    _isNavigatingActualTime = NO;
    _searchStartAndEndDiv.frame = CGRectMake(10, 186 - 98, kScreenWidth - 20, 88);
    self.navigationEndPoint = CGPointMake(0, 0);
    self.cancelNavigationButton.frame = CGRectMake(2+(kScreenWidth - 22)/2.0, 132, (kScreenWidth - 22)/2.0, 44);
    [_naviLayer clearFeatures];
    [_navigationManager clear];
}
-(void)addStartAndEndPointImageView{
    _selectPinOverlayer = [[NGROverlayer alloc] init];
    _selectPinView = [[UIImageView alloc] init];
    _selectPinView.frame = CGRectMake(0, 0, 30, 30);
    _selectPinView.image=[UIImage imageNamed:@"定位"];
    _selectPinView.layer.anchorPoint = CGPointMake(0.5, 1);

    _selectPinOverlayer.view = _selectPinView;
    _selectStartOverlayer = [[NGROverlayer alloc]init];
    _selectStartPinView = [[UIImageView alloc] init];
    _selectStartPinView.layer.anchorPoint = CGPointMake(0.5, 1);
    _selectStartPinView.image=[UIImage imageNamed:@"定位起点"];
    _selectStartPinView.frame = CGRectMake(0, 0, 30, 30);
    _selectStartOverlayer.view = _selectStartPinView;
    _selectStartOverlayer.floorId =  _currentFloorId;
    _selectEndOverlayer = [[NGROverlayer alloc]init];
    _selectEndPinView = [[UIImageView alloc] init];
    _selectEndPinView.layer.anchorPoint = CGPointMake(0.5, 1);
    _selectEndPinView.layer.anchorPoint = CGPointMake(0.5, 1);
    _selectEndPinView.image=[UIImage imageNamed:@"定位终点"];
    _selectEndPinView.frame = CGRectMake(0, 0, 30, 30);
    _selectEndOverlayer.view = _selectEndPinView;
    _selectEndOverlayer.floorId =  _currentFloorId;
    _locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _locationImageView.image = [UIImage imageNamed:@"locationPoint"];
    _locationOverlayer =[[NGROverlayer alloc]initWithView:_locationImageView];
}
 //选择wifi定位
-(void)selectWifi{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]){
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
                weakSelf.wifiManager.timeout = 1000;
                weakSelf.wifiManager.delegate = weakSelf;
                [weakSelf.wifiManager start];
                
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"未获得mac地址" message:nil delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }];
    }else{
        self.wifiManager = [[NGRPositioningManager alloc]initWithMacAddress:@"60:F8:1D:01:47:04" sceneId:10176 url:@"http://location.palmap.cn/comet/"];
        self.wifiManager.poll = YES;
        self.wifiManager.timeInterval = 2000;
        self.wifiManager.delegate = self;
        [self.wifiManager start];
    }
    
}
/**
 *  需要废除定位点的情况
 */
-(BOOL)abolishLocationPointBehaviourWithStatus:(NGRLocationStatus)status andNewLocation:(NGRLocation *)newLocation{
    if (status != MOVE){
//        ShowOMGToast(self.locationErrorState[status]);
        return YES;
    }else{
//         ShowOMGToast(@"move");
    }
    if (newLocation.point.x==0) {
        return  YES;
    }
    return NO;
}
//切割导航线
-(void)cutoffNavigationLineWithNewLocation:(NGRLocation *)newLocation{
    CGFloat pointdistance=0.0;
    if ([self.navigationManager respondsToSelector:@selector(getMinDistanceByPoint:)]) {
        pointdistance = [self.navigationManager getMinDistanceByPoint:newLocation.point];
    }
    if (pointdistance>30&&pointdistance!=0) {
        return;
    }
    self.isClipNavigationLine =YES;
    [self.navigationManager clipFeatureCollectionByCoordinate:newLocation.point];

}
//得到新的定位点之后刷新相关状态
-(void)getNewLocationRefreshStateNewLocation:(NGRLocation *)newLocation{
    _locationFloorId = newLocation.floorId;
    self.currentLocation = newLocation;
    self.currentLocationPoint = newLocation.point;

}

-(void)locationPointChangenewLocation:(NGRLocation *)newLocation{
    CGPoint adsorbPoint;
    adsorbPoint = newLocation.point;
    CGFloat pointdistance=0;
    if (_isNavigatingActualTime&&self.nowfeaturecollection.count>1) {
        if ([self.navigationManager respondsToSelector:@selector(getMinDistanceByPoint:)]) {
            pointdistance = [self.navigationManager getMinDistanceByPoint:newLocation.point];
        }
       
    }
    if (pointdistance<5&& pointdistance!=0) {
        adsorbPoint = [self.navigationManager getPointOfIntersectioanByPoint:self.currentLocationPoint] ;
    }else{
        adsorbPoint = newLocation.point;
    }
   
    if (_currentFloorId == newLocation.floorId){
        [self.mapView addOverlayer:_locationOverlayer];
        [UIView animateWithDuration:0.5 animations:^{
            _locationOverlayer.view.center = [self.mapView getScreenPositionFromWorldPosition:adsorbPoint];
            _locationOverlayer.worldPosition = adsorbPoint;
            
        }];
    }
}
-(void)LocationChangeStateAutochangFloor{
    self.autoChangeMapButton.hidden = NO;
    self.interval = 15;
    self.autoChangeMaptimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeSubtract) userInfo:nil repeats:YES];
    NSRunLoop* runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.autoChangeMaptimer forMode:NSDefaultRunLoopMode];
}
-(void)autoNavigateWithnewLocation:(NGRLocation *)newLocation{
    
    NSInteger index = [self.navigationManager.allPlanarGraph indexOfObject:[NSNumber numberWithInteger:_currentFloorId]];
    if ( index>self.navigationManager.allPlanarGraph.count ) {
        return;
    }
    if (newLocation.floorId == outDoorId) {
        return;
    }
    CGFloat distance=0.0;
    if ([self.navigationManager respondsToSelector:@selector(getMinDistanceByPoint:)]) {
        distance =[_navigationManager getMinDistanceByPoint:newLocation.point];
    }
    NSLog(@"distance= %lf",distance);
    int referenceL = 0;
    if (newLocation.floorId == outDoorId) {
        referenceL = 40;
    }else{
        referenceL = 15;
    }
    if ((distance>referenceL&&distance<10000)||self.selectStartAndEndPintView.selectStartData.floorID!=newLocation.floorId) {
        if (_isNavigatingActualTime == YES) {
            self.distanceCount++;
        }
    }else{
        self.distanceCount = 0;
    }
    if (_selectStartAndEndPintView.isGetingNavigationData == NO&&self.distanceCount>1) {
        self.distanceCount = 0;
       
        self.selectStartAndEndPintView.selectStartData =nil;
        self.selectStartAndEndPintView.selectStartData = [self UserCurrentLocation];
        [self againLoadNavigationStartData :[self UserCurrentLocation] EndData:_selectStartAndEndPintView.selectEndData];
    }
}
-(void)autoFinishNavigateWithnewLocation:(NGRLocation *)newLocation{
    double distancex = fabs(newLocation.point.x -self.navigationEndPoint.x);
    double distancey = fabs(newLocation.point.y - self.navigationEndPoint.y);
    double breakthrough=0.0;
    double distance;
    distance = sqrt(distancex*distancex + distancey*distancey);
    if (newLocation.floorId == outDoorId) {
        breakthrough = 25;
    }else{
        breakthrough = 15;
    }
    if (distance<breakthrough&&_currentFloorId == self.selectStartAndEndPintView.selectEndData.floorID&&_isNavigatingActualTime) {
        if (!self.finishNavAlert) {
             self.finishNavAlert = [ [UIAlertView alloc]initWithTitle:@"您已到达目的地附近，本次导航结束。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
        self.finishNavAlert.tag = 10;
        self.finishNavAlert.delegate = self;
        [self.finishNavAlert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==self.finishNavAlert) {
          [self dismissNavigationToolView];
    }
}
 //  定位点变化
- (void)didLocationChanged:(NGRPositioningManager *)manager oldLocation:(NGRLocation *)oldLocation newLocation:(NGRLocation *)newLocation status:(NGRLocationStatus)status{
    self.alertlocationEView.hidden = YES;
    if ([self abolishLocationPointBehaviourWithStatus:status andNewLocation:newLocation] ) {
        return;
    }
    [self getNewLocationRefreshStateNewLocation:newLocation];
    dispatch_async(dispatch_get_main_queue(), ^{
        //当前楼层等于定位点的楼层号不进行自动楼 层切换只进行定位点的位移。
        if (_currentFloorId == newLocation.floorId){
             self.shouldAutoChangFloor = YES;
            //定位点改变了
            [self locationPointChangenewLocation:newLocation];
            //切割导航线
            if (_isNavigatingActualTime&&self.nowfeaturecollection.count>1&&!self.isRequestingMap&&_hasNavigatioLine) {
                
                [self cutoffNavigationLineWithNewLocation:newLocation];
            }
        }//当前楼层不等于定位点的楼层，进行自动切换楼层的逻辑判断
        else if ((_isNavigatingActualTime||self.shouldAutoChangFloor == YES)&&self.autoChangeMapButton.hidden==YES){
            [self LocationChangeStateAutochangFloor];
        }
        NSInteger floorNum=0;
        if (self.nowfeaturecollection.name!=nil&&![self.nowfeaturecollection.name isEqualToString:@""]) {
            floorNum = self.nowfeaturecollection.name.integerValue;
        }
        if (_isNavigatingActualTime&&!self.isRequestingMap) {
            if (self.nowfeaturecollection.count>1) {
                 [self autoNavigateWithnewLocation:newLocation];
            }
             [self autoFinishNavigateWithnewLocation:newLocation];
        }
    });
}

//定位异常回调方法
- (void)didLocationError:(NGRPositioningManager *)manager error:(NGRLocationStatus)status{
//    ShowOMGToast(self.locationErrorState[status]);
    self.alertlocationEView.hidden = NO;
    self.alertlocationEView.alertMessageStr = @"网络不佳，无法定位";
}
#pragma mark-初始化地图的代码
-(void)addMapData{
    [self.mapView registerGestures];
    if (!_dataSource) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]) {
            _dataSource = [[NGRDataSource alloc] initWithRoot:@"http://10.11.88.105/"];
        }else{
//            _dataSource = [[NGRDataSource alloc] initWithRoot:@"http://172.16.10.235:8080/nagrand-service/"];
            _dataSource = [[NGRDataSource alloc] init];
        }
        _dataSource.delegate = self;
        _dataSource.timeout = 25000;
    }
    self.mapView.delegate=self;
    ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    [self requestMapOutDoorWithSearchPoi:nil  andsearchType:searchNone];
    //第一次加载地图可以自动切换
    self.shouldAutoChangFloor = YES;
}
-(void)requestMapOutDoorWithAlert{
     ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    [self requestMapOutDoorWithSearchPoi:nil  andsearchType:searchNone];
}
-(void)subtraction:(NSTimer*)timer{
    self.substractionCount--;
     [HPDProgress defaultProgressHUD].progressHud.labelText =[NSString stringWithFormat:@"网络不佳，规划时间不超过%ld秒",(long)self.substractionCount];
    if (self.substractionCount==0) {
        HideHPDProgress;
        [self invalidDelayLoadingTimer];
    }
}
-(void)delayLoadingAnimationWithTime:(NSInteger)count isNavigate:(BOOL)navigate{
    self.substractionCount = count;
    [self performSelector:@selector(afterTocheckTryingToLoad:) withObject:[NSNumber numberWithBool:navigate ] afterDelay:5];
}
-(void)afterTocheckTryingToLoad:(NSNumber*)navigate{
    if (navigate.boolValue) {//判断是导航需要的延时还是请求地图暂时没区别
        if (self.selectStartAndEndPintView.isGetingNavigationData) {
            self.substractionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtraction:) userInfo:nil repeats:YES];
            [self.substractionTimer fire];
        }
    }else{
        self.substractionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtraction:) userInfo:nil repeats:YES];
        [self.substractionTimer fire];
    }
}
-(void)invalidDelayLoadingTimer{
    [self.substractionTimer invalidate];
    self.substractionTimer = nil;
}

#pragma mark-加载地图完毕
-(void)requestMapOutDoorWithSearchPoi:(NGRLocationModel*)searchPoiModel andsearchType:(searchType)searchType{
    self.isRequestingMap = YES;
    //5秒后换提示语
    [self delayLoadingAnimationWithTime:20 isNavigate:NO];
    [self hiddenSelectStartOrEndView];
    self.shouldAutoChangFloor = NO;
    NSInteger errorFloorIdDataBack = (NSInteger)_currentFloorId;//导航失败的时候回复原来的floorid
    self.currentFloorId = 665520;
    //在切换楼层的这个时间差内currentfloorid＝＝newlocation.floorid会开启自动切换楼层所以在手动切换楼层的时候要先改变floorid
    _floorChangeToolView.hidden = YES;
   _floorChangeToolView.hidden = YES;
    _currentFloorName = @"室外马路上";
    __weak typeof (self)weakSelf = self;
    [self.dataSource requestPlanarGraph:665520 success:^(NGRPlanarGraph *planarGraph) {
        [weakSelf invalidDelayLoadingTimer];
        weakSelf.outdoorButton.hidden = YES;
        HideHPDProgress;
        [weakSelf startDraw:planarGraph];
        
        weakSelf.isRequestingMap = NO;
        [weakSelf.mapView visibleAllLayerFeature:@"Area" isVisible:NO];//23025000  23024000
        [weakSelf.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];
        [weakSelf.mapView visibleLayerFeature:@"Facility" key:@"category" value:@(23024000) isVisible:YES];
        [weakSelf.mapView visibleLayerFeature:@"Facility" key:@"category" value:@(23025000) isVisible:YES];        if (searchPoiModel)
        {
            [weakSelf getSearchResultThanAutoHandelLocationModel:searchPoiModel andSearchType:searchType];
        }
       
        [weakSelf.mapView rotateIn:weakSelf.mapView.center andAngle:-54.2];
        [weakSelf performSelector:@selector(resetOverLayer) withObject:nil afterDelay:0.3];
        if (weakSelf.currentLocationPoint.x!=0&&weakSelf.currentFloorId==weakSelf.locationFloorId) {
            [weakSelf.mapView moveToPoint:weakSelf.currentLocationPoint animated:NO duration:300];
             [weakSelf performSelector:@selector(resetOverLayer) withObject:nil afterDelay:0.3];
        }
        if (!weakSelf.hasOpenWifiLocation) {
            [weakSelf selectWifi];
            weakSelf.hasOpenWifiLocation = YES;
        }
        /**
         *  绘制导航线的
         */
        weakSelf.currentFloorId = 665520;
        weakSelf.isClipNavigationLine = NO;
        [weakSelf.navigationManager switchPlanarGraph: 665520];
    } error:^(NSError *error) {
        [weakSelf invalidDelayLoadingTimer];
        HideHPDProgress;
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"加载地图失败"
                                                      message:@"当前网络不佳快给我找个wifi!"
                                                     delegate:weakSelf
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        weakSelf.currentFloorId = errorFloorIdDataBack;
        weakSelf.isRequestingMap = NO;
    }];
}

-(void)resetOverLayer{
    [self.mapView resetOverlayers];
}

#pragma mark-加载地图

//- (void)mapViewDidEndZooming:(NGRMapView *)mapView{
//    if (mapView.zoomLevel >= 4) {
//        [self.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];
//    }else{
//        [self.mapView visibleAllLayerFeature:@"Facility" isVisible:YES];
//    }
//}

#pragma mark-uitableview的回调方法711007  711398
-(void)tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:(NSInteger)floorid andFloorName:(NSString*)floorName WithSearchPoi:(NGRLocationModel*)searchPoiModel andSearchType:(searchType)searchType{
    //5秒后换提示语
    [self delayLoadingAnimationWithTime:20 isNavigate:NO];
    [self hiddenSelectStartOrEndView];
    ShowHudViewOnSelfViewWithMessage(@"正在加载地图");
    self.isRequestingMap = YES;
    self.currentFloorName = floorName;
    self.currentFloorId = floorid;
    self.shouldAutoChangFloor = NO;
    __weak typeof(self)weakSelf = self;
    [self.dataSource requestPlanarGraph:floorid success:^(NGRPlanarGraph *planarGraph) {
        [weakSelf invalidDelayLoadingTimer];
        if (weakSelf.selectStartAndEndPintView.isGetingNavigationData) {
            
        }else{
            HideHPDProgress;
        }
        [weakSelf startDraw:planarGraph];
        
        weakSelf.isRequestingMap = NO;
        if (searchPoiModel) {
            [weakSelf getSearchResultThanAutoHandelLocationModel:searchPoiModel andSearchType:searchType ];
        }
//        [weakSelf.mapView visibleAllLayerFeature:@"Facility" isVisible:NO];//厕所
        [weakSelf.mapView visibleLayerFeature:@"Facility" key:@"category" value:@(23043000) isVisible:NO];
        [weakSelf.mapView visibleLayerFeature:@"Facility" key:@"category" value:@(23041000) isVisible:NO];
        
//        [weakSelf.mapView visibleAllLayerFeature:@"Area" isVisible:NO];
//        [weakSelf.mapView setMaxZoom:300];//缩小665520
//        [weakSelf.mapView setMinZoom:40];//放大
        if (weakSelf.mapView.currentID) {
            weakSelf.isClipNavigationLine = NO;
            [weakSelf.navigationManager switchPlanarGraph:weakSelf.mapView.currentID];
        }
        [weakSelf.mapView rotateIn:weakSelf.mapView.center andAngle:-54.2];
        [weakSelf performSelector:@selector(resetOverLayer) withObject:nil afterDelay:0.3];
        if (weakSelf.currentLocationPoint.x!=0&&floorid==weakSelf.locationFloorId) {
            [weakSelf.mapView moveToPoint:weakSelf.currentLocationPoint animated:NO duration:300];
            [weakSelf performSelector:@selector(resetOverLayer) withObject:nil afterDelay:0.3];
        }
        HideHPDProgress;
    } error:^(NSError *error) {
        [weakSelf invalidDelayLoadingTimer];
        weakSelf.isRequestingMap = NO;
        HideHPDProgress;
    }];
}

#pragma mark-进入室内地图进入室内的数据处理
 //进入室内的方式
-(void)comeInInDoorMapWithMapID:(NGRID)mapid andFloorID:(NGRID)floorID WithSearchPoi:(NGRLocationModel*)searchPoiModel andSearchType:(searchType)searchType{
    self.shouldAutoChangFloor = NO;
    _currentFloorId =0;
    NGRID validMapid;
    if (mapid == 0 ) {
        validMapid = _selectedIndoorID;
    }else{
        validMapid = mapid;
    }
    __weak typeof(self) weakSelf = self;
    [_dataSource requestPoiChildren:validMapid success:^(NSArray *pois){
         HideHPDProgress;
        if (pois.count==0) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"没有楼层数据" message:nil
                                                          delegate:weakSelf
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
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
                NSArray *nameArray = [floor.address componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"-"]];
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
                    [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:floorID andFloorName:floorAddress WithSearchPoi:searchPoiModel andSearchType:searchType];
                }
            }
            if (hasLoadFloor==NO) {
                NSInteger floorID =  [[weakSelf.floorChangeToolView.floorNumberDataArray lastObject] integerValue];
                NSString* floorAddress =[weakSelf.floorChangeToolView.floorNameDataArray lastObject];
                [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:floorID andFloorName:floorAddress WithSearchPoi:searchPoiModel andSearchType:searchType];
                [weakSelf.floorChangeToolView reLoadDataWithSelectRow:weakSelf.floorChangeToolView.floorNumberDataArray.count-1];
            }
        }else{
            //自动切换楼层的
            for (int i = 0; i < weakSelf.floorChangeToolView.floorNumberDataArray.count; i++) {
                if ([weakSelf.floorChangeToolView.floorNumberDataArray[i] integerValue] ==floorID) {
                    [weakSelf.floorChangeToolView reLoadDataWithSelectRow:i];
                    NSInteger intfloorID = [[weakSelf.floorChangeToolView.floorNumberDataArray objectAtIndex:i] integerValue];
                    NSString* floorAddress =[weakSelf.floorChangeToolView.floorNameDataArray objectAtIndex:i];
                    [weakSelf tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:intfloorID andFloorName:floorAddress WithSearchPoi:searchPoiModel andSearchType:searchType];
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
    if (!self.selectStartAndEndPintView.selectStartData.isLocationTransform) {
        self.cancelNavigationButton.frame = CGRectMake(2+(kScreenWidth - 22)/2.0, 132, (kScreenWidth - 22)/2.0, 44);
    }
    [UIView animateWithDuration:0.5 animations:^{
        _searchStartAndEndDiv.frame = CGRectMake(10, 0, kScreenWidth - 20, 176);
    }];
}

-(void)navigationViewDisappear{
    HideHPDProgress;
    self.cancelNavigationButton.frame = CGRectMake(2+(kScreenWidth - 22)/2.0, 132, (kScreenWidth - 22)/2.0, 44);
    [UIView animateWithDuration:0.5 animations:^{
        _searchStartAndEndDiv.frame = CGRectMake(10, 186 - 98, kScreenWidth - 20, 88);
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
    [_dataSource searchPOI:destination start:0 count:30 parents:nil categories:nil];
    _needShowAlertForNoSearchResult = need;
}
- (void)didErrorOccurred:(NGRDataSource *)dataSource error:(NSError *)error{
    [_searchVC stopAnimating];
}
-(void)didPOISearchRespond:(NGRDataSource *)dataSource pois:(NSArray *)pois{
    [_searchVC stopAnimating];
    [_searchVC.searchResultArray removeAllObjects];
    for (NGRLocationModel *poiModel in pois) {
        if (poiModel.name==nil&&poiModel.display==nil) {
            continue;
        }
        [_searchVC.searchResultArray addObject:poiModel];
    }
    if (_searchVC.searchResultArray.count == 0&&_needShowAlertForNoSearchResult) {
        [_searchVC showAlertNoSearchResult];
    }
    [_searchVC reloadTableview];
    
}
//选择起点终点控件的代理方法
-(void)searchPoiFeature:(NGRLocationModel*)locationModel andSearchType:(searchType)searchType{
    //隐藏掉15秒之后切换楼层的显示
    [self cancelAutochangeFloorTimer];
    if([locationModel.type isEqualToString: kTypeLocation]){
        if (locationModel.parentID == outDoorId) {
            if (outDoorId!=_currentFloorId) {
                [self requestMapOutDoorWithSearchPoi:locationModel andsearchType:searchType];
            }else{
                [self getSearchResultThanAutoHandelLocationModel:locationModel andSearchType:searchType];
            }
        }else{
            __weak typeof(self) weakSelf = self;
            [_dataSource requestPoi:locationModel.parentID success:^(NGRLocationModel *poi) {
                [weakSelf comeInInDoorMapWithMapID:poi.parentID andFloorID:locationModel.parentID WithSearchPoi:locationModel andSearchType:searchType] ;
            } error:^(NSError *error) {
                
            }];
        }
    }else if([locationModel.type isEqualToString:kTypeBuilding]){
        if (outDoorId!=_currentFloorId) {
            ShowHudViewOnSelfViewWithMessage(@"正在跳转搜索到的位置");
            [self requestMapOutDoorWithSearchPoi:locationModel andsearchType:searchNone];
        }else{
            [self getSearchResultThanAutoHandelLocationModel:locationModel andSearchType:searchType];
        }
    }else if ([locationModel.type isEqualToString: kTypeFloor]){
         ShowHudViewOnSelfViewWithMessage(@"正在跳转搜索到的位置");
        [self comeInInDoorMapWithMapID:locationModel.parentID andFloorID:locationModel.ID WithSearchPoi:locationModel andSearchType:searchType];
    }
}
//得到搜索结果之后自动处理
-(void)getSearchResultThanAutoHandelLocationModel:(NGRLocationModel*)locationModel andSearchType:(searchType)searchType{

    NGRFeature *feature =  [self.mapView searchFeatureWithId:locationModel.ID];//672677
    CGPoint point = [feature getCentroid];
    touchPointData* touchPoint = [[touchPointData alloc]init];
    touchPoint.location = point;
    [self addOverlayer:self.selectPinOverlayer andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:point] andFloorId:locationModel.parentID];
    
    if([locationModel.type isEqualToString: kTypeLocation]){
        if (locationModel.parentID == outDoorId) {
            touchPoint.floorID = (NSInteger)locationModel.parentID;
            touchPoint.floorName = @"户外";
           
        }else{
            for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
                if (locationModel.parentID == floorRegion.floorid.integerValue) {
                    touchPoint.floorID = (NSUInteger)locationModel.parentID;
                    touchPoint.floorName = [NSString stringWithFormat:@"%@-%@",floorRegion.mapName,floorRegion.floorName];
                }
            }
        }
    }else if([locationModel.type isEqualToString:kTypeBuilding]){
        touchPoint.floorID = outDoorId;
        touchPoint.floorName = locationModel.address;
    }else if ([locationModel.type isEqualToString: kTypeFloor]){
        for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
            if (locationModel.ID == floorRegion.floorid.integerValue) {
                touchPoint.floorID = (NSInteger)locationModel.ID;
                touchPoint.floorName = [NSString stringWithFormat:@"%@-%@",floorRegion.mapName,floorRegion.floorName] ;
            }
        }
    }
    self.selectStartAndEndPintView.selectData = touchPoint;
    switch (searchType) {
        case searchRightBarButton:
            break;
        case searchStart:
            [self.selectStartAndEndPintView addStartData];
            break;
        case searchEnd:
            [self.selectStartAndEndPintView addEndData];
            break;
        default:
            break;
    }

}
-(touchPointData*)searchVCgetCurrentUserLocation{
    return [self UserCurrentLocation];
}

-(void)addSelectStartAndEndView{
    _selectStartAndEndPintView =[[SelectStartingAndEndPoint alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _selectStartAndEndPintView.delegate = self;
    _selectStartAndEndOverlayer = [[NGROverlayer alloc]init];
    _selectStartAndEndOverlayer.view = _selectStartAndEndPintView;
}
#pragma mark-导航相关
-(void)startNavigateDisappearAllButton{
    self.floorChangeToolView.userInteractionEnabled = NO;
    [self.outdoorButton removeFromSuperview];
    [self.Locationbtn removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
   
}
-(void)endNavigateAppearAllbutton{
    if (_currentFloorId != outDoorId) {
        self.floorChangeToolView.userInteractionEnabled = YES;
    }
    [self.view addSubview: self.outdoorButton ];
    [self.view addSubview:self.Locationbtn];
     self.navigationItem.rightBarButtonItem = self.rightBarButton;
    

}
/**
 *  开始导航，更新界面
 */
-(void)startNavigate{
    //取消自动跳转的过场
    [self cancelAutochangeFloorTimer];
    //所有按钮失效
    [self startNavigateDisappearAllButton];
    _isNavigatingActualTime = YES;//点击了开始导航
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:1 animations:^{
        _searchStartAndEndDiv.frame = CGRectMake(10, 186 - 98, kScreenWidth - 20, 88);
    } completion:^(BOOL finished) {
        //导航步骤数据的添加
        [self addNavigationDisplayData];
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationStartView.center = CGPointMake(kScreenWidth/2, kScreenHeight - 90);
        }];
        //自动切换到导航的起点
        [self autoChangeToNavigationStartFloor];
    }];
}
-(void)autoChangeToNavigationStartFloor{
    if (self.currentFloorId!=self.selectStartAndEndPintView.selectStartData.floorID) {
        //重新计数，为的是防治在切换楼层的时候自动重新规划路径
        self.distanceCount = 0;
        if (self.selectStartAndEndPintView.selectStartData.floorID == outDoorId) {
            if (self.currentFloorId == outDoorId) {
                //不做跳转
            }else{
                ShowHudViewOnSelfViewWithMessage(@"正在跳转到导航起点位置");
                [self requestMapOutDoorWithSearchPoi:nil andsearchType:searchNone];
            }
        }else{
            for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
                if (self.selectStartAndEndPintView.selectStartData.floorID == floorRegion.floorid.integerValue) {
                    ShowHudViewOnSelfViewWithMessage(@"正在跳转到导航起点位置");
                    [self comeInInDoorMapWithMapID:floorRegion.mapID.integerValue andFloorID:self.selectStartAndEndPintView.selectStartData.floorID WithSearchPoi:nil andSearchType:searchNone];
                }
            }
        }
    }else{//起始点楼层跟本楼层一样，需要手动进行旋转（自动旋转在navigationresponse调用的，不自动切换楼层不会旋转）
        //            [self autoRotationtoVerticalToScreen];
    }
}
-(void)addNavigationDisplayData{
    [self.collectionArray removeAllObjects];
    [self.collectionArray addObject:self.selectStartDisData];
    for (NSNumber* flooridItem in self.navigationManager.allPlanarGraph)
    {
        if(flooridItem.integerValue!=self.selectStartAndEndPintView.selectStartData.floorID&&flooridItem.integerValue!=self.selectStartAndEndPintView.selectEndData.floorID)
        {
            CollectionMessage* collectModel = [self getfloorMessageFromFloorID:flooridItem];
            [self.collectionArray addObject:collectModel];
            
        }
    }
    [self.collectionArray addObject:self.selectEndDisData];
    self.navigationStartView.dataArray = self.collectionArray;
    [self.navigationStartView viewReloadData];
    

}
-(CollectionMessage*)getfloorMessageFromFloorID:(NSNumber*)floorID{
     CollectionMessage* collectModel = [[CollectionMessage alloc]init];
    for (FloorRegionModel* floorRegion in self.jsonFloorDataArray) {
        if (floorID.integerValue == floorRegion.floorid.integerValue) {
            NSString* str = [NSString stringWithFormat:@"%@-%@",floorRegion.mapName,floorRegion.floorName];
            collectModel.floorName = str;
            collectModel.floorId = floorRegion.floorid;
        }
    }
    if (collectModel.floorName==nil) {
        collectModel.floorName=@"室外";
    }
    return collectModel;
}
-(void)setSelectDisplayTitle:(id)target andpoint:(CGPoint)point andFloorid:(NSNumber*)floorID{
    NSString* poiStr=nil;
    NGRFeature* feature;
    if ([self.mapView respondsToSelector:@selector(searchFeatureWithPoint:)]) {
        feature = [self.mapView searchFeatureWithPoint:[self.mapView getScreenPositionFromWorldPosition:point]];
        poiStr =  feature.display;
    }
    
    if (poiStr==nil) {
        poiStr= @"道路上";
    }
    CollectionMessage* floorMessage = [self getfloorMessageFromFloorID:floorID];
    if (target == _selectstartButton) {
        self.selectStartDisData.floorName = [NSString stringWithFormat:@"%@-%@",floorMessage.floorName,poiStr];
        [(UIButton*)target setTitle:self.selectStartDisData.floorName forState:UIControlStateNormal];
    }else if(target == _selectEndButton){
        self.selectEndDisData.floorName = [NSString stringWithFormat:@"%@-%@",floorMessage.floorName,poiStr];
        [(UIButton*)target setTitle:self.selectEndDisData.floorName forState:UIControlStateNormal];
    }else if(target == _bubblePopStart){
       _bubblePopStart.bubblePopTitle = [NSString stringWithFormat:@"%@-%@",floorMessage.floorName,poiStr];
    }else if(target == _bubblePopEnd){
        _bubblePopEnd.bubblePopTitle = [NSString stringWithFormat:@"%@-%@",floorMessage.floorName,poiStr];
    }
    
}
 //添加选择起点终点的界面
- (void)addAnnotation:(CGPoint)point ImageName:(NSString *)name ChangtoFloor:(NSUInteger)floorID{
    if ([name isEqualToString:@"luoyao起点.png"]) {
        [self addOverlayer:_selectStartOverlayer andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:point]  andFloorId:self.selectStartAndEndPintView.selectStartData.floorID];
        if (self.selectStartAndEndPintView.selectStartData.isLocationTransform) {
            self.selectStartDisData.floorName = @"我的位置";
            [_selectstartButton setTitle:self.selectStartDisData.floorName forState:UIControlStateNormal];
        }else{
            [self setSelectDisplayTitle:_selectstartButton andpoint:point andFloorid:[NSNumber numberWithInteger: self.selectStartAndEndPintView.selectStartData.floorID]];
        }
    }else if([name isEqualToString:@"luoyao终点.png"]){
        [self addOverlayer:_selectEndOverlayer andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:point]  andFloorId:self.selectStartAndEndPintView.selectEndData.floorID];
        
         [self setSelectDisplayTitle:_selectEndButton andpoint:point andFloorid:[NSNumber numberWithInteger: self.selectStartAndEndPintView.selectEndData.floorID]];
    }else{
        
    }
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
    touchpoint.floorName =floorName ;
    return touchpoint;
}

-(BOOL)featurecollectionNull:(NGRFeatureCollection *)featureCollection{
    if (self.isClipNavigationLine) {
        return NO;//如果是在切割导航线的状态下
    }
    if (featureCollection == nil) {
        //没有任何导航数据
        if (self.selectStartAndEndPintView.isGetingNavigationData) {
            self.selectStartAndEndPintView.isGetingNavigationData = NO;
            [self dismissNavigationToolView];
            return YES;
        }else{
            return YES;
        }
        
    }else if (featureCollection.count <2&&self.selectStartAndEndPintView.selectStartData.floorID==self.selectStartAndEndPintView.selectEndData.floorID){
        [self dismissNavigationToolView];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"距离目的地太近无法导航" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        return YES;
    }
    return NO;
}
-(void)navigationresponseStateHandleWith:(NGRFeatureCollection *)featureCollection{
    _hasNavigatioLine = YES;//这个时候让点击事件无效直到结束之后再变成NO
     _selectStartAndEndPintView.isGetingNavigationData = NO;
    _navigationStartView.navigationButton.userInteractionEnabled = YES;
    [self invalidDelayLoadingTimer];
}
-(void)addNavigationLayer:(NGRFeatureCollection *)featureCollection{
    [_naviLayer clearFeatures];
     _naviLayer = [[NGRFeatureLayer alloc] initWithFeatureName:@"navigate"];
    [_naviLayer setCoordinateOffset:self.mapView.coordinateOffset];
    [self.mapView addLayer:_naviLayer];
    [_naviLayer addFeatures:featureCollection];
}
-(void)autoScroll:(NGRFeatureCollection *)featureCollection{
    if (featureCollection.count<2) {
        return;//不能组成一条直线
    }
    NSInteger lastPointIndex =  [_navigationManager getPointCount:featureCollection]-1;
    self.navigationEndPoint = [_navigationManager getPointFromFeatureCollection:featureCollection atIndex:lastPointIndex];
    self.navigationStartPoint = [_navigationManager getPointFromFeatureCollection:featureCollection atIndex:0];
    CGPoint navigationStartPoint2 = [_navigationManager getPointFromFeatureCollection:featureCollection atIndex:1];
    //旋转地图
    double linex = fabs(self.navigationStartPoint.x - navigationStartPoint2.x);
    double liney = fabs(self.navigationStartPoint.y - navigationStartPoint2.y);
    self.autoRotationangle = atan(linex/liney)*180.0/3.141;
    NSLog(@"self.mapView.angel=%lf  %lf   %lf",self.autoRotationangle,linex,liney);
    self.AngelpointCenter =  [self.mapView getScreenPositionFromWorldPosition:self.navigationStartPoint];
    if (navigationStartPoint2.y >self.navigationStartPoint.y) {
        if(navigationStartPoint2.x >self.navigationStartPoint.x){
            
        }else{
            self.autoRotationangle = 360-self.autoRotationangle;
        }
    }else{
        if(navigationStartPoint2.x >self.navigationStartPoint.x){
            self.autoRotationangle = 180-self.autoRotationangle;
        }else{
            self.autoRotationangle = self.autoRotationangle+180;
        }
    }
    if (liney==0.0) {
        if (linex>0) {
            self.autoRotationangle = 90;
        }else{
            self.autoRotationangle = -90;
        }
    }
    self.autoRotationangle = -self.autoRotationangle;
    if (_isNavigatingActualTime) {
//        [self autoRotationtoVerticalToScreen];
    }
}
-(void)addPopViewwith:(NGRFeatureCollection *)featureCollection{
    
    if (self.selectStartAndEndPintView.selectStartData.floorID == _currentFloorId) {
        if (self.isClipNavigationLine==YES) {
            self.isClipNavigationLine =NO;
        }else{
            [self addOverlayer:_selectStartOverlayer andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:self.navigationStartPoint]  andFloorId:self.selectStartAndEndPintView.selectStartData.floorID];
        }
        
    }else{
        //添加气泡
        if (self.selectStartAndEndPintView.selectEndData.floorID!=self.selectStartAndEndPintView.selectStartData.floorID) {
            [self addOverlayer:_popImageOverlayerStart andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:self.navigationStartPoint] andFloorId:_currentFloorId];
            //            _bubblePopStart.title.text =  _bubblePopTitle;//修改
        }
    }
    
    if (self.selectStartAndEndPintView.selectEndData.floorID == _currentFloorId) {
        [self addOverlayer:_selectEndOverlayer andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:self.navigationEndPoint]  andFloorId:self.selectStartAndEndPintView.selectEndData.floorID];
    }else{
        //添加气泡
        if (self.selectStartAndEndPintView.selectEndData.floorID!=self.selectStartAndEndPintView.selectStartData.floorID) {
            [self addOverlayer:_popImageOverlayerEnd andScreenPoint:[self.mapView getScreenPositionFromWorldPosition:self.navigationEndPoint] andFloorId:_currentFloorId];
            //            _bubblePopEnd.title.text = _bubblePopTitle1;//修改
        }
    }

}
-(void)setDistanceFromEndPoint:(int)distance{
    int time  = (int)distance/1.5/60;
    time<1? time=1:time;
    NSString* str = [NSString stringWithFormat:@"距离目的地%d米,需要步行%d分钟",distance,time];
    _labelDistance.text = str ;
}
-(void)addCenterstepwith:(NGRFeatureCollection *)featureCollection{
    if (_isNavigatingActualTime) {
        return;
    }
    NGRFeature* featureStart;
    NGRFeature* featureEnd;
    NSMutableString* mutStr = [[NSMutableString alloc]initWithCapacity:50];
    if (self.selectStartAndEndPintView.selectStartData.floorID == self.selectStartAndEndPintView.selectEndData.floorID &&self.selectStartAndEndPintView.selectEndData.floorID== _currentFloorId) {
        CGPoint screenPoint = [self.mapView getScreenPositionFromWorldPosition:self.selectStartAndEndPintView.selectEndData.location];
        NSLog(@"screenLocation = %@", NSStringFromCGPoint(screenPoint));
        if ([self.mapView respondsToSelector:@selector(searchFeatureWithPoint:)]) {
            featureEnd = [self.mapView searchFeatureWithPoint:[self.mapView getScreenPositionFromWorldPosition:self.selectStartAndEndPintView.selectEndData.location]];//崩溃
        }
    
        if (featureEnd.display) {
            [mutStr appendString:featureEnd.display];
        }else{
            [mutStr appendString:@"出入口"];
        }
        
    }else if (self.selectStartAndEndPintView.selectStartData.floorID == self.currentFloorId){
        if ([self.mapView respondsToSelector:@selector(searchFeatureWithPoint:)]) {
            featureEnd =  [self.mapView searchFeatureWithPoint:[self.mapView getScreenPositionFromWorldPosition:self.selectStartAndEndPintView.selectEndData.location]];
        }
        if (featureEnd.display) {
            [mutStr appendString:featureEnd.display];
        }else{
            [mutStr appendString:@"出入口"];
        }
    }else if (self.selectStartAndEndPintView.selectEndData.floorID == self.currentFloorId){
        CGPoint scrPoint = [self.mapView getScreenPositionFromWorldPosition:self.selectStartAndEndPintView.selectStartData.location];
        if ([self.mapView respondsToSelector:@selector(searchFeatureWithPoint:)]) {
            featureStart =  [self.mapView searchFeatureWithPoint:scrPoint];//崩溃
        }
        
        if (featureStart.display) {
            [mutStr appendString:featureStart.display];
        }else{
            [mutStr appendString:@"走廊"];
        }
    }
    NSLog(@"featureCollection.name=%@",featureCollection.name);
    self.navigationStartView.currentaddressLabel.text = [NSString stringWithFormat:@"导航中(到%@的%@)",_currentFloorName,mutStr];
}
- (void)didNavigationRequestError:(NGRNavigateManager *)manager state:(NGRNaviagteState)state{
    HideHPDProgress;
    [self invalidDelayLoadingTimer];
    if (self.selectStartAndEndPintView.isGetingNavigationData) {
        self.selectStartAndEndPintView.isGetingNavigationData = NO;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"导航失败" message:@"目的地不可达" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissNavigationToolView];
    }else{
        HideHPDProgress;
    }
}
//导航数据返回
#pragma mark-导航结果返回，矫正导航起始点
- (void)didNavigationRespond:(NGRNavigateManager *)manager feature:(NGRFeatureCollection *)featureCollection state:(NGRNaviagteState)state{
    self.nowfeaturecollection = featureCollection;
    HideHPDProgress;
    //导航数据有问题的处理
    if ([self featurecollectionNull:featureCollection]) {
        return;
    }
    //加载出导航线相关的状态处理
    [self navigationresponseStateHandleWith:featureCollection];
    //添加导航线
    [self addNavigationLayer:featureCollection];
    //自动旋转放大地图
    [self autoScroll:featureCollection];
    //添加气泡
    if (state==NAVIGATE_SWITCH_SUCCESS||state==NAVIGATE_OK) {
        [self.mapView removeAllOverlayer];
         [self addPopViewwith:featureCollection];
    }
    //添加中间步骤
    [self addCenterstepwith:featureCollection];
    //距离终点多少米的显示
    [self setDistanceFromEndPoint:_navigationManager.navigationTotalLineLength];

}
 //开始导航之后自动旋转
-(void)autoRotationtoVerticalToScreen{
    [self.mapView rotateIn:self.AngelpointCenter andAngle:self.autoRotationangle];
    [self.mapView moveToRect:CGRectMake(self.navigationStartPoint.x-10, self.navigationStartPoint.y-10, 20, 20) animated:YES duration:300];
    [self performSelector:@selector(resetOverLayer) withObject:nil afterDelay:0.3];
}
-(NSString*)appearPopViewType:(pointType)pointtype WithCGPoint:(CGPoint)point{
    NSString* selectName;
    if (pointtype == startPoint) {
        [self setSelectDisplayTitle:_bubblePopStart andpoint:point andFloorid:[NSNumber numberWithInteger:self.selectStartAndEndPintView.selectStartData.floorID] ];
    }else{
           [self setSelectDisplayTitle:_bubblePopEnd andpoint:point andFloorid:[NSNumber numberWithInteger:self.selectStartAndEndPintView.selectEndData.floorID] ];
    }
    return selectName;
}
 //调用导航的接口导航
- (void)shopPopoverViewnavigationWithStartData:(touchPointData *)startPoi EndData:(touchPointData *)endPoi{
    _selectStartAndEndPintView.isGetingNavigationData = YES;
    
    if (!_navigationManager) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"netType"]isEqualToString:@"innet"]) {
             _navigationManager = [[NGRNavigateManager alloc] initWithUrl:@"http://10.11.88.105/"];
           
        }else{
//            _navigationManager = [[NGRNavigateManager alloc] initWithUrl:@"http://172.16.10.235:8080/nagrand-service/"];
            _navigationManager = [[NGRNavigateManager alloc] init];
        }
        _navigationManager.delegate = self;
        _navigationManager.timeout = 15000;
    }
    self.isClipNavigationLine = NO;
    [_navigationManager navigationFromPoint:startPoi.location fromFloor:startPoi.floorID toPoint:endPoi.location toFloor:endPoi.floorID defaultFloor:self.mapView.currentID];
    ShowHudViewOnSelfViewWithMessage(@"正在加载导航数据");
   [self delayLoadingAnimationWithTime:20 isNavigate:YES];//5秒后提醒
    [self navigationViewAppear];
}

-(void)againLoadNavigationStartData:(touchPointData *)startPoi EndData:(touchPointData *)endPoi{
    
    [_naviLayer clearFeatures];
    [_navigationManager clear];
    //中间层气泡
    [self appearPopViewType:startPoint WithCGPoint:self.selectStartAndEndPintView.selectStartData.location];
    [self appearPopViewType:endPoint WithCGPoint:self.selectStartAndEndPintView.selectEndData.location];
//    _selectStartAndEndPintView.isGetingNavigationData = YES;
    self.isClipNavigationLine = NO;
    [_navigationManager navigationFromPoint:startPoi.location fromFloor:startPoi.floorID toPoint:endPoi.location toFloor:endPoi.floorID defaultFloor:self.mapView.currentID];
    _hasNavigatioLine = YES;//这个时候让点击事件无效直到结束之后再变成NO
}

-(void)touchPoint:(CGPoint)point withFeature:(NGRFeature *)feature {
    /*
    self.selectStartAndEndPintView.poinName = feature.display;
    NSString* regionName = [self insidePolygonWithPoint:[self.mapView getWorldPositionFromScreenPosition:point]];
    NSLog(@"regionName＝%@",regionName);
    if (feature !=nil && feature.ID != 0) {
        if ([feature.locationType isEqualToString:@"BUILDING"])
        {
            _selectedIndoorID = feature.featureId;
            _selectStartAndEndPintView.comeInIndooorButton.hidden = NO;
            
        }else{
            _selectStartAndEndPintView.comeInIndooorButton.hidden = YES;
        }
    }
    // 有导航线，可以进入室内
    if ( _hasNavigatioLine == YES) {
        _selectStartAndEndPintView.startButton.hidden = YES;
        _selectStartAndEndPintView.endButton.hidden = YES;

    }else{
        _selectStartAndEndPintView.startButton.hidden = NO;
        _selectStartAndEndPintView.endButton.hidden = NO;
    }
    _appearCenterPoint =CGPointMake(point.x - 70,point.y - 50);
    //这是没有点在地图以内665620
    if (feature == nil) {
        [self hiddenSelectStartOrEndView];
        [self hiddenSelectStartOrEndView];
    }else{
        if( _selectStartAndEndPintView.selectStartData == nil && _selectStartAndEndPintView.selectEndData == nil){
            //第一次点地图上的点就是说地图上的起始点都没被选中
            [self addOverlayer:_selectPinOverlayer andScreenPoint:point andFloorId:_currentFloorId];
            [self showSelectStartOrEndView];
        }else if(_selectStartAndEndPintView.selectStartData != nil || _selectStartAndEndPintView.selectEndData != nil){
              //起点终点都有了
            if(_selectStartAndEndPintView.selectStartData != nil && _selectStartAndEndPintView.selectEndData != nil){
                [self showSelectStartOrEndView];
            }else{
                [self addOverlayer:_selectPinOverlayer andScreenPoint:point andFloorId:_currentFloorId];
                [self showSelectStartOrEndView];
            }
        }
        touchPointData* touchPoint = [[touchPointData alloc]init];
        touchPoint.floorID = (NGRID)_currentFloorId;
        touchPoint.floorName = _currentFloorName;
        touchPoint.location =[self.mapView getWorldPositionFromScreenPosition:point];//[feature  getCentroid];
        _selectStartAndEndPintView.selectData = touchPoint;
    }
    */
}

-(void)addOverlayer:(NGROverlayer*)overlayer andScreenPoint:(CGPoint)screenPoint andFloorId:(NGRID)floorid{
        overlayer.worldPosition = [self.mapView getWorldPositionFromScreenPosition:screenPoint];
        overlayer.floorId = floorid;
        [self.mapView addOverlayer: overlayer];
    
}
-(void)showSelectStartOrEndView{
    [self.selectStartAndEndPintView reSetFrame];
    if (_hasNavigatioLine&&self.selectStartAndEndPintView.comeInIndooorButton.hidden) {
        return;
    }
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_selectStartAndEndPintView];
       _selectStartAndEndPintView.bgImageView.center = CGPointMake(kScreenWidth/2, kScreenHeight);
    [UIView animateWithDuration:0.2 animations:^{
        _selectStartAndEndPintView.bgImageView.center = CGPointMake(kScreenWidth/2, kScreenHeight-(_selectStartAndEndPintView.height/2)-10);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hiddenSelectStartOrEndView{
    [self.mapView removeOverlayer:self.selectPinOverlayer];
    [_selectStartAndEndPintView removeFromSuperview];
}

-(void)removeSelectImageViewWith:(BOOL)select AndStart:(BOOL)start andEnd:(BOOL)end{
    [self hiddenSelectStartOrEndView];
    if (select == YES) {
        [self.mapView removeOverlayer:_selectPinOverlayer];
    }
    if (start == YES) {
        [self.mapView removeOverlayer:_selectStartOverlayer];
    }
    if(end == YES){
        [self.mapView removeOverlayer:_selectEndOverlayer];
    }
}

- (void)longPressHandle:(UILongPressGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        CGPoint tapLocation = [sender locationInView:self.mapView];
//        id feature = [self.mapView searchFeatureWithPoint:tapLocation];
//        [self touchPoint:tapLocation withFeature:feature];
//    }
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
        [self requestMapOutDoorWithSearchPoi:nil  andsearchType:searchNone];
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
                            [self tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:intfloorID andFloorName:floorAddress WithSearchPoi:nil andSearchType:searchNone];
                        }
                    }
                }else{
                    [self comeInInDoorMapWithMapID:floorRegion.mapID.integerValue andFloorID:_locationFloorId WithSearchPoi:nil andSearchType:searchNone];
                    
                }
               _currentFloorId = _locationFloorId;//15分钟自动切换或者点击切换。
                
            }
        }
        
    }
    self.autoChangeMapButton.hidden = YES;
}
// 切换是呼叫服务还是路线导航
-(void)changeServices:(UISegmentedControl*)sender{
    self.selectedIndex = sender.selectedSegmentIndex;
}
- (void)StartDrawMap
{
    [self.mapView start];
}
- (void)StopDrawMap
{
    [self.mapView stop];
}

- (IBAction)tenMButton:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"任务已完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.intaskController NETWORK_reloadWorkStatusTask];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)showMapButton:(id)sender
{
    [self showMsgView:NO];
    [self.intaskController.conversationView.messageInputView resignFirstResponder];
    self.intaskController.showTalk = NO;
    [self.intaskController deallocInstantMessageing];
    [self.intaskController.conversation markConversationAsRead];
    self.intaskController.showMessageLabel = YES;
    self.intaskController.messageLabel.hidden = YES;
}

- (void)showMsgView:(BOOL)show
{
    self.navigationItem.rightBarButtonItem = show ? self.showMap : nil;
    CGRect showHistoryRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    CGRect hideHistoryRect = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, self.view.frame.size.height - 64);
    [UIView animateWithDuration:0.25f animations:^{
        [self.inTaskView setFrame:show ? showHistoryRect : hideHistoryRect];
        self.inTaskTop.constant = show ? 0.0f : self.view.frame.size.height - 124;
        self.inTaskBottom.constant = show ? 0.0f : 60 - self.view.frame.size.height;
    } completion:^(BOOL finished) {
    }];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showInTask"])
    {
        self.intaskController = (InTaskController *)[segue destinationViewController];
        self.intaskController.mapViewController = self;
    }
}

@end