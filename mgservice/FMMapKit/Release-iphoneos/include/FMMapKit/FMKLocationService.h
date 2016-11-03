//
//  FMKLocationService.h
//  mgmanager
//
//  Created by fengmap on 16/8/19.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMKGeometry.h"
#import "FMKNaviStruct.h"
#import "FMKNaviContraint.h"
@class DevicePositionInfo;

@protocol FMKLocationServiceDelegate <NSObject>

@optional
/**
 *  更新位置
 *
 *  @param mapPoint fengmap地图坐标
 */
- (void)didUpdateLocation:(FMKMapPoint)mapPoint location:(CLLocation *)location;

/**
 *  更新设备朝向
 *
 *  @param heading 设备朝向
 */
- (void)didUpdateHeading:(double)heading;

/**
 *  更新WIFI定位坐标返回
 *
 *  @param devicePositionInfo 设备的位置信息
 */
- (void)didUpdateWifiLocation:(DevicePositionInfo *)devicePositionInfo;

@end

@interface FMKLocationService : NSObject

@property (nonatomic, weak)id<FMKLocationServiceDelegate>delegate;
@property (nonatomic, assign) BOOL isGPSLocating;
@property (nonatomic, assign) BOOL isWIFILocating;
@property (nonatomic, assign) FMKMapCoord startMapCoord;
@property (nonatomic, assign) FMKMapCoord endMapCoord;
@property (nonatomic, assign) BOOL isLocating;

+ (instancetype)shareLocationService;

/**
 *  开始GPS定位
 */
- (void)startGPSLocation;

/**
 *  停止GPS定位
 */
- (void)stopGPSLocation;

/**
 *  开始WIFI定位
 *
 *  @param macAddr MAC地址
 */
- (void)startWifiLocationWithMacAddr:(NSString *)macAddr;
/**
 *  停止WIFI定位
 */
- (void)stopWifiLocation;


- (FMKNaviContraintPara)naviConstraintWithLastMapPoint:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint;


- (void)setupUploadUrl:(NSString *)url port:(NSInteger)port;

@end
