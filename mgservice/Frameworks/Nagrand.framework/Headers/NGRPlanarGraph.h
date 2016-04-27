//
//  NGRPlanarGraph.h
//  Nagrand
//
//  Created by Yongxian Wu on 11/10/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nagrand/NGRDataModel.h>

@class NGRFeatureCollection;

/*! 
 * @brief 平面图的类，这里封装这地图渲染需要的数据。每一个NGRFloor都有一个对应着的NGRPlanarGraph
 */
@interface NGRPlanarGraph : NGRDataModel


/*!
 * @brief 该平面图包含的图层数
 */
@property (nonatomic, readonly)NSUInteger layerCount;

/*!
 * @brief 根据索引值返回一个NGRFeatureCollection
 * @param index - 索引值，不能超过layerCount的大小
 * @return 返回一个图层数据
 */
- (NGRFeatureCollection *)getFeatures:(NSUInteger)index;

@end
