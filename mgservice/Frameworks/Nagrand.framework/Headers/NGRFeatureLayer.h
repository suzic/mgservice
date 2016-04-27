//
//  NGRFeatureLayer.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/17/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NGRLayer.h"
#import "NGRTypes.h"

@class NGRFeature, NGRFeatureCollection, NGRCoordinateOffset, NGRMapView;

/*! 
 * @brief 一个用于管理Feature的图层类。
 * @discussion 这个类至少需要一个name，不然无法完成构造。如果构造传入的是一个NGRFeatureCollection，那么就会使用这个数据层的名字来作为图层的名字。这个name主要的作用是映射到lua中关于样式配置的那个属性，请参考开发者平台的相关文档。
 */
@interface NGRFeatureLayer : NGRLayer

/*!
 * @brief 设置这个图层的偏移量，存在坐标转换的问题，如果在一个坐标系统内想要正常得显示图层，就需要配置这个属性
 */
@property (nonatomic, strong)NGRCoordinateOffset *coordinateOffset;

/*!
 * @brief 通过一个name来构造一个图层，请确保这个name不为空，然后需要在lua中添加这个name的配置信息，才可以正确显示地图。
 * @param name - 唯一name，不能重复
 * @return NGRFeatureLayer的实例
 */
- (instancetype)initWithFeatureName:(NSString *)name;

/*!
 * @brief 通过一个featureCollection来构造一个图层
 * @param collection - 不能为空
 * @return NGRFeatureLauer实例
 */
- (instancetype)initWithFeatureCollection:(NGRFeatureCollection *)collection;

/*!
 * @brief 将一个NGRFeature添加至这个图层中，请确保这个NGRFeature的正确性，否则无法成功将其绘制。
 * @param feature - 一个图形feature元素
 */
- (void)addFeature:(NGRFeature *)feature;

/*!
 * @brief 将一个NGRFeatureCollection添加至这个图层中，请确保这个NGRFeatureCollection的正确性，否则无法成功将其绘制。
 * @param featureCollention - 多个feature元素
 */
- (void)addFeatures:(NGRFeatureCollection *)featureCollention;

/*!
 * @brief 隐藏指定的feature
 * @param key - 想要隐藏的feature的key值
 * @param value - 与key对应的value（e.g. key = @"category" 对应的value = @(33042000)）
 * @param isVisible - false为隐藏
 */
- (void)visibleLayerFeature:(NSString *)key value:(id)value isVisible:(BOOL)isVisible;

/*!
 * @brief 隐藏所有的feature
 * @param isVisible - false为隐藏
 */
- (void)visibleAllLayerFeature:(BOOL)isVisible;

/*!
 * @brief 将一个NGRFeature移动一个距离
 * @param featureId - 确保这个id在Layer中是存在的 distance - 偏移向量
 */
- (void)moveFeature:(NGRID)featureId distance:(CGVector)distance animated:(BOOL)animated duration:(CGFloat)duration;

/*!
 * @brief 通过featureID，去旋转一个指定的feature
 * @param featureId - 指定旋转的featureId
 * @param angle - 旋转角度
 */
- (void)rotateFeature:(NGRID)featureId angle:(CGFloat)angle;

/*!
 * @brief 清除掉这个图层上的所有feature
 */
- (void)clearFeatures;

/*!
 * @brief 改变一个feature的颜色
 * @param featureId - 查询用的featureId
 * @param color - 颜色（ARGB颜色代码，如：0xFFFF0000为红色）
 * @return 是否成功
 */
- (BOOL)setRenderableColor:(NGRID)featureId color:(NSUInteger)color;

/*!
 * @brief 还原feature的颜色，还原的颜色为lua配置的颜色
 * @param featureId - featureId
 * @return 是否成功
 */
- (BOOL)resetOriginStyle:(NGRID)featureId;

/*!
 * @brief 改变一个feature的style
 * @param featureId - 查询用的featureId
 * @param styleId - 与lua配置文件中updatestyles的索引对应
 */
- (void)updateRenderableStyle:(NGRID)featureId styleId:(NGRID)styleId;

@end
