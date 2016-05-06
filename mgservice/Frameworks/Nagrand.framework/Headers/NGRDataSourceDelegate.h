//
//  NGRDataSourceDelegate.h
//  Nagrand
//
//  Created by Sanae on 15/12/24.
//  Copyright © 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nagrand/NGRDataSource.h>

@class NGRDataSource, NGRPlanarGraph, NGRLocationModel, NGRMapModel, NGRCategoryModel;


/*!
 * @brief NGRDataSource的代理协议，包含所有数据请求的返回方法
 */
@protocol NGRDataSourceDelegate <NSObject>

@optional
/*!
 * @brief requestMaps的回调方法
 * @param maps - NGRMap数组
 */
- (void)didMapsRespond:(NGRDataSource *)dataSource maps:(NSArray *)maps;

/*!
 * @brief requestMap的回调方法
 * @param map - 返回的NGRMap数据
 */
- (void)didMapRespond:(NGRDataSource *)dataSource map:(NGRMapModel *)map;


/*!
 * @brief requestPoi的回调方法
 * @param poi - NGRLocationModel的实例，或者它的子类
 */
- (void)didPoiRespond:(NGRDataSource *)dataSource poi:(NGRLocationModel *)poi;

/*!
 * @brief requestPoiChildren的回调方法
 * @param pois - NGRLocationModel的数组，包含其子类
 */
- (void)didPoiChildrenRespond:(NGRDataSource *)dataSource pois:(NSArray *)pois;

/*!
 * @brief requestPlanarGraph的回调方法
 * @param planarGraph - NGRPlanarGraph用于地图绘制
 */
- (void)didPlanarGraphRespond:(NGRDataSource *)dataSource planarGraph:(NGRPlanarGraph *)planarGraph;

/*!
 * @brief requestCategory的回调方法
 * @param category - NGRCategory的对象
 */
- (void)didCategoryRespond:(NGRDataSource *)dataSource category:(NGRCategoryModel *)category;

/*!
 * @brief requestCategories:inLocation:的回调方法
 * @param categories - NGRCategory数组
 */
- (void)didCategoriesRespond:(NGRDataSource *)dataSource categories:(NSArray *)categories;


/*!
 * @brief searchPOI的回调方法
 * @param pois - NGRLocationModel数组
 */
- (void)didPOISearchRespond:(NGRDataSource *)dataSource pois:(NSArray *)pois;

/*!
 * @brief CoordBeContained的回调方法
 * @param pois - NGRLocationModel数组
 */
- (void)didCoordBeContainedRespond:(NGRDataSource *)dataSource pois:(NSArray *)pois;

/*!
 * @brief 请求数据错误时返回，错误代码参考NGRResourceState
 * @param error - 错误代码
 */
- (void)didErrorOccurred:(NGRDataSource *)dataSource error:(NSError *)error;
@end
