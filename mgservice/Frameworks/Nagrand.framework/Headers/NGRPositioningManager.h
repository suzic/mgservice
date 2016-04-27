//
//  NGRPositioningManager.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/18/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRMapView.h>
#import <Nagrand/NGRDataSource.h>
#import <Nagrand/NGRLocation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, NGRLocationStatus) {
    START = 0,
    STOP,
    CLOSE,
    MOVE,
    ENTER,
    OUT,
    HEART_BEAT,
    ERROR
    
};

/*!
 * @brief NGRPositioningManager的代理协议
 */
@protocol NGRPositioningDelegate <NSObject>

@optional
/*!
 * @brief WIFI定位于蓝牙定位的回调方法
 * @param oldLocation - 上一次的location，第一次返回null
 * @param newLocation - 这一次的location
 */
- (void)didLocationChanged:(NGRLocation *)oldLocation newLocation:(NGRLocation *)newLocation status:(NGRLocationStatus)status;

/*!
 * @brief 定位异常回调方法
 * @param state - 异常参考NGRDataSourceState
 */
- (void)didLocationError:(NGRLocationStatus)status;

/*!
 * @brief 蓝牙数据库拉取成功
 */
- (void)didDownloadDatabaseSuccess;

/*!
 * @brief 蓝牙拉取数据库失败
 */
- (void)didDownloadDatabaseError;

@end


/*! 
 * @brief 定位类，WIFI与蓝牙定位
 */
@interface NGRPositioningManager : NSObject

/*!
 * @brief 必须设置代理，否则没有回调
 */
@property (nonatomic, weak)id<NGRPositioningDelegate> delegate;

/*!
 * @brief 设置true是轮询时间默认2秒，可以通过timeInterval修改，false为长连接
 */
@property (nonatomic, assign)BOOL poll;

/*!
 * @brief 控制轮询时间间隔
 */
@property (nonatomic, assign)NSUInteger timeInterval;
@property (nonatomic, assign)NSUInteger timeout;

@property (nonatomic, assign)BOOL isPositioning;


//WIFI
/*!
 * @brief wifi定位构造方法
 * @param mac - 设备的mac地址
 * @param appKey - 启动引擎的appkey
 * @return NGRPositioningManager的实例
 */
- (instancetype)initWithMacAddress:(NSString *)mac appKey:(NSString *)appKey;

/*!
 * @brief wifi定位构造方法
 * @param mac - 设备的mac地址
 * @param appKey - 启动引擎的appkey
 * @param url - 自定义url
 * @return NGRPositioningManager的实例
 */
- (instancetype)initWithMacAddress:(NSString *)mac appKey:(NSString *)appKey url:(NSString *)url;

/*!
 * @brief wifi定位构造方法
 * @param mac - 设备的mac地址
 * @param sceneId - 场景id
 * @return NGRPositioningManager的实例
 */
- (instancetype)initWithMacAddress:(NSString *)mac sceneId:(NGRID)sceneId;

/*!
 * @brief wifi定位构造方法
 * @param mac - 设备的mac地址
 * @param sceneId - 场景id
 * @param url - 自定义url
 * @return NGRPositioningManager的实例
 */
- (instancetype)initWithMacAddress:(NSString *)mac sceneId:(NGRID)sceneId url:(NSString *)url;

/*!
 * @brief 开始定位，用于Wifi定位
 */
- (void)start;


/*!
 * @brief 暂停定位，用于Wifi定位
 */
- (void)stop;

/*!
 * @brief 关闭定位，用于Wifi定位
 */
- (void)close;

//蓝牙
/*!
 * @brief 通过场景id与mapId初始化一个manager
 * @param license - 开发者网站获取license
 * @param mapID - mapID
 * @return NGRPositioningManager的实例
 */
- (instancetype)initWithLicense:(NSString *)license mapID:(NGRID)mapID;

/*!
 * @brief 设置beaconRegion
 */
- (void)setBeaconRegion;

/*!
 * @brief 开始定位，用于蓝牙定位
 */
- (void)startBLE;

/*!
 * @brief 停止定位， 用于蓝牙定位
 */
- (void)stopBLE;

@end

