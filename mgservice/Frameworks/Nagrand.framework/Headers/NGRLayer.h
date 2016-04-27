//
//  NGRLayer.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/17/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NGRMapView;


/*! 
 * @brief 所有图层的基类。
 */
@interface NGRLayer : NSObject

/*!
 * @brief layer的唯一name
 */
@property (nonatomic, readonly)NSString *name;

/*!
 * @brief 通过一个图层的名字构造一个图层。
 * @param name - 图层的名字
 * @return NGRLayer的实例
 */
- (instancetype)initWithName:(NSString *)name;

@end
