//
//  NGRNavigateManager.h
//  Nagrand
//
//  Created by Sanae on 15/4/1.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Nagrand/NGRDataSource.h>
#import "NGRFeatureCollection.h"

@class NGRNavigateManager, NGRNavigate, NGRLocation;

typedef NS_ENUM(NSInteger, NGRNaviagteState) {
    NAVIGATE_OK = 0,                //请求导航线成功
    NAVIGATE_SWITCH_SUCCESS,        //切换导航线成功
    NAVIGATE_CLIP_SUCCESS,          //切割导航线成功
    NAVIGATE_REQUEST_ERROR,			//导航请求失败
    NAVIGATE_REQUEST_TIMEOUT,      //导航请求超时
    NAVIGATE_UNKNOWN_ERROR,			//导航未知错误
    NAVIGATE_NOT_FOUND,				//导航线未找到
    CLIP_NAVIGATE_ERROR,			//切割导航线失败
    PLANARGRAPH_ERROR				//楼层错误
    
};


/*! 
 * @brief 导航数据的回调
 */
@protocol NGRNavigateManagerDelegate <NSObject>

/*!
 * @brief 数据请求成功的回调
 * @param featureCollection - 渲染数据，可以用于构造featureLayer来显示在地图上
 */
- (void)didNavigationRespond:(NGRNavigateManager *)manager feature:(NGRFeatureCollection *)featureCollection state:(NGRNaviagteState)state;

/*!
 * @brief 数据请求失败
 * @param state - 错误代码
 */
- (void)didNavigationRequestError:(NGRNavigateManager *)manager state:(NGRNaviagteState)state;

@end

/*! 
 * @brief 导航类，用于管理导航
 * @discussion 主要是导航数据的请求，跨楼层的实现等
 */
@interface NGRNavigateManager : NSObject

/*!
 * @brief 导航代理
 */
@property (nonatomic, weak)id<NGRNavigateManagerDelegate> delegate;

/*!
 * @brief 控制超时时间，单位毫秒
 */
@property (nonatomic, assign)NSUInteger timeout;

/*!
 * @brief featureCollection的size
 */
@property (nonatomic, assign)NSUInteger size;

/*!
 * @brief featureCollection对应的id
 */
@property (nonatomic, strong)NSArray<NSNumber *> *keys;

/*!
 * @brief 所有楼层的planarGraphID
 */
@property (nonatomic, strong, readonly)NSArray<NSNumber *> *allPlanarGraph;

/*!
 * @brief 初始化manager，需要传入接口的地址
 * @param url - 网络请求的地址
 * @return NGRNavigationManager实例
 */
- (instancetype)initWithUrl:(NSString *)url;

/*!
 * @brief 用于请求导航数据，设置delegate后，会有成功或失败的回调
 * @param fromPoint - 起始点坐标，世界坐标
 * @param fromFloor - 起始点所在的floorID
 * @param toPoint - 终点坐标，世界坐标
 * @param toFloor - 终点所在的floorID
 * @param defaultFloor - 默认的floorID，如果存在这个floor的导航数据，第一个返回，如果为0，顺序返回
 */
- (void)navigationFromPoint:(CGPoint)fromPoint fromFloor:(NGRID)fromFloor toPoint:(CGPoint)toPoint toFloor:(NGRID)toFloor defaultFloor:(NGRID)defaultFloor;

/*!
 * @brief 用于请求导航数据，设置delegate后，会有成功或失败的回调
 * @param fromPoint - 起始点坐标，世界坐标
 * @param fromFloor - 起始点所在的floorID
 * @param toPoint - 终点坐标，世界坐标
 * @param toFloor - 终点所在的floorID
 */
- (void)navigationFromPoint:(CGPoint)fromPoint fromFloor:(NGRID)fromFloor toPoint:(CGPoint)toPoint toFloor:(NGRID)toFloor;


/*!
 * @brief 切换楼层方法，在切换楼层时调用，会有数据请求成功didNavigationRespond的回调
 * @param floorId - 切换的floorID
 */
- (void)switchPlanarGraph:(NGRID)floorId;

/*!
 * @brief 根据导航返回的featureCollection与index，获取导航线上的节点
 * @param featureCollection - 导航线的合集
 * @param index - 数组目录
 * @return 导航线上的节点
 */
- (CGPoint)getPointFromFeatureCollection:(NGRFeatureCollection *)featureCollection atIndex:(NSUInteger)index;

/*!
 * @brief 根据导航返回的featureCollection获取节点的个数
 * @param featureCollection - 导航线的合集
 * @return 节点的个数
 */
- (NSUInteger)getPointCount:(NGRFeatureCollection *)featureCollection;

/*!
 * @brief 获取一个点到导航线的最近距离
 * @param point - 世界坐标的point
 * @return 点到导航线的最近距离，如果导航数据不存在，返回0
 */
- (CGFloat)getMinDistanceByPoint:(CGPoint)point;

/*!
 * @brief 获取一个点在导航线上最近距离的映射点
 * @param point - 世界坐标的point
 * @return 导航线上的映射点，如果导航数据不存在，返回CGPointZero
 */
- (CGPoint)getPointOfIntersectioanByPoint:(CGPoint)point;

/*!
 * @brief 获取指定楼层的导航线距离
 * @param floorId - 指定的floorId
 * @return 返回的导航线长度，单位米，如果没有数据返回0
 */
- (CGFloat)navigationLineLengthInFloor:(NGRID)floorId;

/*!
 * @brief 获取所有导航线的总长度
 * @return 返回导航线的总长度
 */
- (CGFloat)navigationTotalLineLength;

/*!
 * @brief 获取指定楼层某一段的导航距离
 * @param floorId - 指定的floorId
 * @param index - 指定目录
 * @return 返回某一段的长度，单位米
 */
- (CGFloat)navigationLineLengthInFloor:(NGRID)floorId atIndex:(NSUInteger)index;

/*!
 * @brief 以一个新的点为起点，裁剪导航线
 * @param point - 导航线上的新起点
 */
- (void)clipFeatureCollectionByCoordinate:(CGPoint)point;

/*!
 * @brief 根据featureCollection的id获取对应的featureCollection
 * @param key - 可以通过keys属性获取
 * @return 对应的featureCollection
 */
- (NGRFeatureCollection *)featureCollectionByKey:(NGRID)key;

/*!
 * @brief 清除当前保留的导航数据，用于下一次请求
 */
- (void)clear;
@end


@interface NGRNavigate : NSObject

- (NGRFeatureCollection *)getFeatureCollection:(NGRID)floorId;

@end
