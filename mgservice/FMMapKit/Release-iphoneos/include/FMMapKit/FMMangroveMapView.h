//
//  FMMangroveMapView.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKMapView.h"

@class FMActivity,FMRoute,FMZone,FMLocationBuilderInfo;

@interface FMMangroveMapView : FMKMapView

/**
 *  高亮poi
 *
 *  @param activety poi
 */
- (void)highlightActivityOnMapCenter:(FMActivity *)activety;
/**
 *  show pois
 *
 *  @param activeties pois
 */
- (void)showActivityListOnMap:(NSArray *)activities;

/**
 *  hidden pois
 *
 *  @param activities pois
 */
- (void)hiddenActivityListOnMap:(NSArray *)activities;

/**
 *  所有的poi恢复普通状态
 */
- (void)showAllOnMap;

/**
 *  展示路线相关
 *
 *  @param route 路线
 */
- (void)showRouteOnMap:(FMRoute *)route;
/**
 *  隐藏路线相关
 *
 *  @param route 路线
 */
- (void)hiddenRoute:(FMRoute *)route;
/**
 *  展示区域相关
 *
 *  @param zone 区域
 */
- (void)showZoneOnMap:(FMZone *)zone;
/**
 *  隐藏区域展示
 *
 *  @param zone 区域
 */
- (void)hiddenZone:(FMZone *)zone;

/**
 *  获取当前设备的MAC地址（未实现）
 *
 *  @return macAddress
 */
- (NSString *)getCurrentMacAddr;

/**
 *  添加定位标注物（未实现）
 *
 *  @param loc 定位标注信息
 */
- (void)addLocOnMap:(FMLocationBuilderInfo *)loc;

/**
 *  清除定位标注物(未实现)
 *
 *  @param loc 定位标注信息
 */
- (void)removeLocOnMap:(FMLocationBuilderInfo *)loc;

/**
 *  放大路线上相应的图片标注物
 *
 *  @param route 路线
 *  @param index 图片下标
 */
- (void)zoomImageMarkerOnRoute:(FMRoute *)route index:(int)index size:(CGSize)imageMarkerSize;

@end
