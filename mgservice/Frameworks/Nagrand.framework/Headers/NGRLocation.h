//
//  NGRLocation.h
//  Nagrand
//
//  Created by Sanae on 15/3/30.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Nagrand/NGRTypes.h>

@class NGRFeature;

/*! 
 * @brief 表示一个定位点。这里还包含着Feature信息。
 */
@interface NGRLocation : NSObject



/*!
 * @brief 获取这个定位点的floorId
 */
@property (nonatomic, readonly)NGRID floorId;

/*!
 * @brief 获取这个定位点的点信息，这是一个世界坐标。
 */
@property (nonatomic, readonly)CGPoint point;

/*!
 * @brief 获取自身到另一个location的距离
 * @param toLocation - 另一个location
 * @return 两个location之间的距离
 */
-(CGVector)getDistanceTo:(NGRLocation *)toLocation;

@end
