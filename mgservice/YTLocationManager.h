//
//  YTLocationManager.h
//  WanDaMall
//
//  Created by Choi on 14-8-8.
//  Copyright (c) 2014年 WanDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SHRequest.h"
#import "GCDAsyncUdpSocket.h"

static const NSString *YTLocation_MacAddressKey = @"YTLocation_MacAddressKey";


@class YTLocation;
@protocol YTLocationManagerDelegate;

@interface YTLocationManager : NSObject<SHRequestDelegate, GCDAsyncUdpSocketDelegate>

@property (nonatomic, assign)id<YTLocationManagerDelegate> delegate;
@property (nonatomic, assign)float updateTime;//更新时间，最小1秒

- (id)initWithUrlString:(NSString *)urlString MacAddress:(NSString *)macAddress;

@property (nonatomic, strong)NSString *urlString;
@property (nonatomic, copy)NSString *macAddress;

/**
 *  开启定位
 */
- (void)startUpdateLocation;

/**
 *  关闭定位
 */
- (void)stopUpdateLocation;

/**
 *  最后一次接收到的位置信息
 *
 *  @return 位置
 */
- (YTLocation *)lastLocation;

/**
 *  是否在定位
 *
 */
- (BOOL)isLocation;

@end


@interface YTLocation : NSObject

@property (nonatomic, assign)float x;
@property (nonatomic, assign)float y;
@property (nonatomic, strong)NSNumber *floorID;

@end


@protocol YTLocationManagerDelegate <NSObject>

/**
 *  代理，更新位置
 *
 *  @param manager
 *  @param newLocation 新位置
 *  @param oldLocation 上一次更新的位置
 */
- (void)ytLocationManager:(YTLocationManager *)manager
      didUpdateToLocation:(YTLocation *)newLocation
             fromLocation:(YTLocation *)oldLocation;

/**
 *  离开室内区域
 *
 *  @param manager
 */
- (void)isOutSideYtLocationManager:(YTLocationManager *)manager;

//testDelegate
- (void)logURL:(NSString *)url;
- (void)didUdpSocketConnectSuccess:(NSData *)date;
- (void)didUdpSocketConnectFailed;

@end