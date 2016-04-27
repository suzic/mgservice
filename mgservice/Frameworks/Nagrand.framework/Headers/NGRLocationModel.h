//
//  NGRPOI.h
//  Nagrand
//
//  Created by 吾雍贤 on 3/17/15.
//  Copyright (c) 2015 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRDataModel.h>

@class NGRCategoryModel;

/*! 
 * @brief 一个数据信息的抽象，这里可以获取大多数的信息。
 */
@interface NGRLocationModel : NGRDataModel

/*!
 * @brief 唯一的ID
 */
@property (nonatomic, assign)NGRID ID;

/*!
 * @brief 上层的ID（例如一个楼层的parentID是一个building的ID）
 */
@property (nonatomic, assign)NGRID parentID;

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

@property (nonatomic, strong)NGRCategoryModel *category;


@end

