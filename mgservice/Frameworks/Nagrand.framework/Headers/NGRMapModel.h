//
//  NGRMap.h
//  Nagrand
//
//  Created by Yongxian Wu on 11/10/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRDataModel.h>

/*! 
 * @brief 地图数据的封装类。map类
 */
@interface NGRMapModel : NGRDataModel

/*!
 * @brief map的id，用来蓝牙定位
 */
@property (nonatomic, assign)NGRID ID;

/*!
 * @brief map的poiID，用来获取楼层信息等
 */
@property (nonatomic, assign)NGRID poi;

/*!
 * @brief 类型，参考NGRDataModel的kTypeLocation，kTypeFloor等
 */
@property (nonatomic, copy)NSString *type;

/*!
 * @brief 名字
 */
@property (nonatomic, copy)NSString *name;

/*!
 * @brief 显示的名字
 */
@property (nonatomic, copy)NSString *display;

/*!
 * @brief 地址
 */
@property (nonatomic, copy)NSString *address;

/*!
 * @brief 经纬度
 */
@property (nonatomic, assign)NGRCoordinate coordinate;

@end
