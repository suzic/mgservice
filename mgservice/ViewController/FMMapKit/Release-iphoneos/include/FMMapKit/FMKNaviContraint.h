//
//  FMKNaviContraint.h
//  FMMapKit
//
//  Created by fengmap on 16/7/13.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"
#import "FMKNaviStruct.h"

@interface FMKNaviContraint : NSObject
/**
 *  初始化路径约束
 *
 *  @param mapPath 地图数据路径
 *
 *  @return 路径约束对象
 */
- (instancetype)initWithMapPath:(NSString *)mapPath;

/**
 *  更新路径约束所需参数
 *
 *  @param mapPoints 地图坐标点集合
 *  @param groupID   所在楼层ID
 */
- (void)updateNaviConstraintDataWith:(NSArray *)mapPoints
						 groupID:(NSString *)groupID;

/**
 *  路径约束点计算  path
 *
 *  @param lastMapPoint    上一个地图坐标
 *  @param currentMapPoint 当前地图坐标
 *
 *  @return 路径约束结果
 */
- (FMKNaviContraintResult)naviContraintByLastPoint:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint;

/**
 *  导航路径约束计算方法
 *
 *  @param lastMapPoint    上一个点
 *  @param currentMapPoint 当前点
 *
 *  @return 路径规划结果
 */
- (FMKNaviContraintResult)pathContraintByLastPoint:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint groupID:(NSString *)groupID;

/**
 *  获取两点之间的角度
 *
 *  @param lastMapPoint    上一个点
 *  @param currentMapPoint 当前点
 *
 *  @return 角度
 */
- (float)getTwoPointAngleByLastMapPoint:(FMKMapPoint)lastMapPoint andCurrentMapPoint:(FMKMapPoint)currentMapPoint;

- (FMKNaviContraintPara)pathContraintWithRoadInfo:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint groupID:(NSString *)groupID;

//- (FMKNaviConstraintRoadResult)naviConstraintWithRoadInfo:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint;

@end
