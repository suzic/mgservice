//
//  NGROverlayer.h
//  Nagrand
//
//  Created by Sanae on 15/5/7.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Nagrand/NGRTypes.h>

@interface NGROverlayer : NSObject

/*!
 * @brief 通过一个UIView来初始化
 * @param view - 一个overlayer必须存在有个UIView
 * @return 实例化的对象
 */
- (instancetype)initWithView:(UIView *)view;

/*!
 * @brief 一个overlayer必须存在有个UIView
 */
@property (nonatomic, strong)UIView *view;

/*!
 * @brief 世界坐标
 */
@property (nonatomic, assign)CGPoint worldPosition;

/*!
 * @brief 如果设置floorID，overlayer只显示在设置的楼层上，如果不设置，每次切换楼层会自动删除
 */
@property (nonatomic, assign)NGRID floorId;

/*!
 * @brief 锚点
 */
@property (nonatomic, assign)CGPoint anchorPoint;

@end
