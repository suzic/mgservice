//
//  NGRFeature.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/17/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Nagrand/NGRDataModel.h>

/*! 
 * @brief 一个Feature代表着一个渲染元素。保存着空间数据和一些基本信息。Geometry用来描述空间数据，最终会绘制的图形。
 * @discussion Element用来描述像id、name等基本信息。其中id是最主要的信息，用来在一个FeatureLayer中标识这个Feature，一个Feature至少需要上面两个元素组成。不然无法成功的完成绘制。
 */
@interface NGRFeature : NGRDataModel

- (instancetype)initWithFeatureID:(NGRID)featureID point:(CGPoint)point properties:(NSDictionary *)properties;

@property (nonatomic) NSData *shape;

/*!
 * @brief 显示的名字
 */
@property (nonatomic, copy)NSString *display;

/*!
 * @brief 名字
 */
@property (nonatomic, copy)NSString *name;

/*!
 * @brief logo的url
 */
@property (nonatomic, copy)NSString *logo;

/*!
 * @brief 唯一的ID
 */
@property (nonatomic, assign)NGRID ID;

/*!
 * @brief 类别ID
 */
@property (nonatomic, assign)NGRID category;

/*!
 * @brief 所在平面图的ID
 */
@property (nonatomic, assign)NGRID planarGraph;

/*!
 * @brief feature的location类型
 */
@property (nonatomic, copy)NSString *locationType;


//abandoned property
/*!
 * @brief 获取featureId
 */
@property (nonatomic, readonly)NGRID featureId;

/*!
 * @brief 获取一个feature的categoryID
 */
@property (nonatomic, readonly)NGRID categoryID;


/*!
 * @brief 获取这个feature的图形中心
 * @return 中心坐标，世界坐标
 */
- (CGPoint)getCentroid; //return CGPointZero when error


@end
