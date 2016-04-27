//
//  NGRBuildingModel.h
//  Nagrand
//
//  Created by Sanae on 15/11/18.
//  Copyright © 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRLocationModel.h>

/*! 
 * @brief building的数据模型
 */
@interface NGRBuildingModel : NGRLocationModel

/*!
 * @brief 电话
 */
@property (nonatomic, copy)NSString *phone;

/*!
 * @brief 邮编
 */
@property (nonatomic, assign)NSInteger *zip;

/*!
 * @brief 开门时间
 */
@property (nonatomic, copy)NSString *openingTime;

/*!
 * @brief 是否有停车场
 */
@property (nonatomic, assign)BOOL parking;

@end
