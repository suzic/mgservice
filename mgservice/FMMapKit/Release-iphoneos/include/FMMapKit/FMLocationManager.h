//
//  FMLocationManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMManager.h"

@class FMLocationBuilderInfo;
@class FMKImageMarker;

@interface FMLocationManager : FMManager
/**
 *  添加定位信息图片标注物
 *
 *  @param loc 定位信息
 */
- (void)addLocOnMap:(FMLocationBuilderInfo *)loc;
/**
 *  删除定位信息图片标注物
 *
 *  @param loc 定位信息
 */
- (void)removeLocOnMap:(FMLocationBuilderInfo *)loc;


/**
 判断两点之间的距离是否大于设定阈值

 @param location1 位置点1
 @param location2 位置点2
 @param distance  设定距离

 @return 比较结果 小于 返回YES
 */
- (BOOL)testDistanceWithLocation1: (FMLocationBuilderInfo *)location1 location2: (FMLocationBuilderInfo *)location2 distance: (double)distance;

@end
