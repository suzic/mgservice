//
//  NGRFloor.h
//  Nagrand
//
//  Created by Sanae on 15/4/24.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRLocationModel.h>

/*! 
 * @brief 楼层数据。每一个NGRMap下都包含着若干个NGRFloor。
 */
@interface NGRFloorModel : NGRLocationModel

/*!
 * @brief 是否是默认楼层
 */
@property (nonatomic, assign)BOOL isDefault;


@end
