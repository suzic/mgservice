//
//  NGRCategory.h
//  Nagrand
//
//  Created by Sanae on 15/3/26.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRDataModel.h>

/*!
 * @brief 种类的封装类。
 */
@interface NGRCategoryModel : NGRDataModel

/*!
 * @brief 类别的ID
 */
@property (nonatomic, assign)NGRID ID;

/*!
 * @brief 类别的名字1
 */
@property (nonatomic, copy)NSString *name1;

/*!
 * @brief 类别的名字2
 */
@property (nonatomic, copy)NSString *name2;
/*!
 * @brief 类别的名字3
 */
@property (nonatomic, copy)NSString *name3;
/*!
 * @brief 类别的名字4
 */
@property (nonatomic, copy)NSString *name4;


@end
