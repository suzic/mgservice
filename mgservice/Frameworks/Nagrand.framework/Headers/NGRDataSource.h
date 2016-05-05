//
//  NGRDataSource.h
//  Nagrand
//
//  Created by Sanae on 15/9/6.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Nagrand/NGRDataSourceDelegate.h>
#import <Nagrand/NGRTypes.h>

@class NGRPlanarGraph, NGRLocationModel, NGRMapModel, NGRCategoryModel;
@class NGRAsyncHttpClient;

/*!
 * @typedef NGRResourceState
 * @brief NGRDataSource错误代码
 * @constant OK - 正常
 * @constant UNSUPPORTED_PROTOCOL - 不支持协议
 * @constant COULDNT_CONNECT - 连接失败
 * @constant REMOTE_ACCESS_DENIED - 访问被拒绝
 * @constant HTTP_RETURNED_ERROR - Http返回错误
 * @constant READ_ERROR - 读本地文件错误
 * @constant UNKNOWN_ERROR - 未知错误
 */
typedef NS_ENUM(NSInteger, NGRResourceState) {
    OK = 0,
    UNSUPPORTED_PROTOCOL,	//不支持协议
    COULDNT_CONNECT,		//连接失败
    REMOTE_ACCESS_DENIED,	//访问被拒绝
    HTTP_RETURNED_ERROR,	//Http返回错误
    READ_ERROR,				//读本地文件错误
    UNKNOWN_ERROR,          //未知错误
    OPERATION_TIMEDOUT,     //timeout
    CACHE                   //cache
    
};


typedef void (^NGRMapBlock)(NGRMapModel *mapModel);
typedef void (^NGRMapsBlock)(NSArray *maps);
typedef void (^NGRPoiBlock)(NGRLocationModel *poi);
typedef void (^NGRPoiChildrenBlock)(NSArray *poiChildren);
typedef void (^NGRPlanarGraphBlock)(NGRPlanarGraph *planarGraph);
typedef void (^NGRCategoryBlock)(NGRCategoryModel *category);
typedef void (^NGRCategoriesBlock)(NSArray *categories);
typedef void (^NGRSearchBlock)(NSArray *searchResponds);
typedef void (^NGRCoordBeContained)(NSArray *containedPois);
typedef void (^NGRErrorBlock)(NSError *error);

//-------------------------------------------

/*!
 * @brief 用于请求地图PlanarGraph，POI信息等的接口
 * @discussion 依赖于NGREngine，需要通过license验证之后才能正常使用。所有接口均是异步的，且返回并非在主线程，请注意线程问题。如果请求出错，会返回相对应的错误代码，请参考枚举NGRResourceState。
 */
@interface NGRDataSource : NSObject

/*!
 * @brief NGRDataSource的代理
 */
@property (assign, nonatomic)id <NGRDataSourceDelegate> delegate;

/*!
 * @brief 控制超时时间，单位毫秒
 */
@property (nonatomic, assign)NSUInteger timeout;

/*!
 * @brief 初始化NGRDataSource
 * @discussion 需要提供一个地图数据服务器的地址。请通过开发者平台获取我们提供的地图数据服务器的地址。默认请使用http://api.ipalmap.com/
 * @param root - 地图数据服务器的地址
 * @return NGRDataSource的实例
 */
- (instancetype)initWithRoot:(NSString *)root;

/*!
 * @brief 初始化NGRDataSource
 * @discussion 根据一个NGRAsyncHttpClient实例构造datasource
 * @param client - 可以通过client控制请求的服务器地址跟缓存，详情见NGRAsyncHttpClient类
 * @return NGRDataSource的实例
 */
- (instancetype)initWithHttpClient:(NGRAsyncHttpClient *)client;

/*!
 * @brief 请求当前可用Map的列表
 */
- (void)requestMaps;

/*!
 * @brief 请求mapId所对应的map数据
 * @param mapId - map的id
 */
- (void)requestMap:(NGRID)mapId;


/*!
 * @brief 根据poiId请求POI的数据
 * @param poiId - POI的id
 */
- (void)requestPoi:(NGRID)poiId;


/*!
 * @brief 根据一个poiId请求它子类的信息，比如传进一个NGRMapModel的poiId，返回的就是NGRFloorModel的集合，传进一个NGRFloorModel的id，返回的就是楼层的所有NGRLocationModel既楼层的商铺、公共设施等
 * @param poiId - POI的id
 */
- (void)requestPoiChildren:(NGRID)poiId;

/*!
 * @brief 根据floorId请求一个NGRPlanarGraph的数据。
 * @param floorId - 楼层的id
 */
- (void)requestPlanarGraph:(NGRID)floorId;

/*!
 * @brief 根据categoryId请求Category的信息
 * @param categoryId - category的id
 */
- (void)requestCategory:(NGRID)categoryId;

/*!
 * @brief 根据mapId，locationId请求Category的集合
 * @param mapId - NGRMapModel的ID属性
 * @param locationId - NGRLocationModel的ID
 */
- (void)requestCategories:(NGRID)mapId inLocation:(NGRID)locationId;


/*!
 * @brief 根据搜索条件去检索符合条件的POI的集合
 * @param keyWords - 搜索关键字
 * @param start - 开始的索引
 * @param count - 返回的搜索结果条数
 * @param parents - 父类poi的集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param categories - 搜索的categories集合，可以根据此参数做限制条件，传空时为搜索所有的
 */
- (void)searchPOI:(NSString *)keyWords start:(NSUInteger)start count:(NSUInteger)count parents:(NSArray *)parents categories:(NSArray *)categories;

/*!
 * @brief 根据一个点的坐标搜索包含它POI的集合
 * @param point - 查询的点位坐标
 * @param start - 开始的索引
 * @param count - 返回的搜索结果条数
 * @param parents - 父类poi的集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param categories - 搜索的categories集合，可以根据此参数做限制条件，传空时为搜索所有的
 */
- (void)CoordBeContained:(CGPoint)point start:(NSUInteger)start count:(NSUInteger)count parents:(NSArray<NSNumber *> *)parents categories:(NSArray<NSNumber *> *)categories;

//-----------------------------------blocks------------------------------
/*!
 * @brief 请求当前可用Map的列表
 * @param successBlock - 请求成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestMapsSuccess:(NGRMapsBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 请求mapId所对应的map数据
 * @param mapId - map的id
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestMap:(NGRID)mapId success:(NGRMapBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据poiId请求POI的数据
 * @param poiId - POI的id
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestPoi:(NGRID)poiId success:(NGRPoiBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据一个poiId请求它子类的信息，比如传进一个NGRMapModel的poiId，返回的就是NGRFloorModel的集合，传进一个NGRFloorModel的id，返回的就是楼层的所有NGRLocationModel既楼层的商铺、公共设施等
 * @param poiId - POI的id
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestPoiChildren:(NGRID)poiId success:(NGRPoiChildrenBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据floorId请求一个NGRPlanarGraph的数据。
 * @param floorId - 楼层的id
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestPlanarGraph:(NGRID)floorId success:(NGRPlanarGraphBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据categoryId请求Category的信息
 * @param categoryId - category的id
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestCategory:(NGRID)categoryId success:(NGRCategoryBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据mapId，locationId请求Category的集合
 * @param mapId - NGRMapModel的ID属性
 * @param locationId - NGRLocationModel的ID
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)requestCategories:(NGRID)mapId inLocation:(NGRID)locationId success:(NGRCategoriesBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据搜索条件去检索符合条件的POI的集合
 * @param keyWords - 搜索关键字
 * @param start - 开始的索引
 * @param count - 返回的搜索结果条数
 * @param parents - 父类poi的集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param categories - 搜索的categories集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)searchPOI:(NSString *)keyWords start:(NSUInteger)start count:(NSUInteger)count parents:(NSArray *)parents categories:(NSArray *)categories success:(NGRSearchBlock)successBlock error:(NGRErrorBlock)errorBlock;

/*!
 * @brief 根据一个点的坐标搜索包含它POI的集合
 * @param point - 查询的点位坐标
 * @param start - 开始的索引
 * @param count - 返回的搜索结果条数
 * @param parents - 父类poi的集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param categories - 搜索的categories集合，可以根据此参数做限制条件，传空时为搜索所有的
 * @param successBlock - 成功回调
 * @param errorBlock - 失败回调
 */
- (void)CoordBeContained:(CGPoint)point start:(NSUInteger)start count:(NSUInteger)count parents:(NSArray<NSNumber *> *)parents categories:(NSArray<NSNumber *> *)categories success:(NGRCoordBeContained)successBlock error:(NGRErrorBlock)errorBlock;


@end
