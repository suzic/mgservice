//
//  NGRFeatureCollection.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/17/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGRTypes.h"

@class NGRFeature;

/*! 
 * @brief Feature的集合类，也代表着一个数据层的信息。
 */
@interface NGRFeatureCollection : NSObject

/*!
 * @brief 名字，相当于唯一标签
 */
@property (nonatomic, readonly)NSString *name;

/*!
 * @brief feature的数量
 */
@property (nonatomic, readonly)NSUInteger count;

/*!
 * @brief 初始化方法，需要指定一个name
 * @param name - 唯一name，不能为空
 * @return NGRFeatureCollection的实例
 */
- (instancetype)initWithName:(NSString *)name;

/*!
 * @brief 根据一个id返回对应的Feature
 * @param featureId - feature的唯一id
 * @return 这个NGRFeature代表着一个渲染元素，可以添加到任何NGRFeatureLayer中
 */
- (NGRFeature *)featureFromFeatureId:(NGRID)featureId;

/*!
 * @brief 根据索引搜索collection中的feature
 * @param index - 索引
 * @return 这个NGRFeature代表着一个渲染元素，可以添加到任何NGRFeatureLayer中
 */
- (NGRFeature *)featureAtIndex:(NSUInteger)index;

@end
