//
//  NGLMapViewController.h
//  Nagrand
//
//  Created by Yongxian Wu on 9/4/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NGRPlanarGraph.h"
#import "NGRFeature.h"
#import "NGRFeatureLayer.h"

/*! 
 * @brief 自带mapView的controller
 * @discussion 方便的自带mapView的controller，提供一些简单的设置，也可以对mapView进行更深的定制化
 */
@interface NGRMapViewController : UIViewController

/*!
 * @brief 获取自带的mapView
 */
@property (nonatomic, strong)NGRMapView *mapView;

/*!
 * @brief 初始化MapView，必须调用，需要在绘制地图之前调用
 * @param name - 可以自定义mapView的name，如果为空name为default
 */
- (void)configMapView:(NSString *)name;

/*!
 * @brief 开始绘制
 * @param planarGraph - 绘制地图所用数据
 */
- (void)startDraw:(NGRPlanarGraph *)planarGraph;

/*!
 * @brief 结束绘制
 */
- (void)stopDraw;



@end
