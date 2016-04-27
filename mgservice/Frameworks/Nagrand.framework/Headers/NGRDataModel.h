//
//  NGRDataModel.h
//  Nagrand
//
//  Created by Sanae on 15/11/18.
//  Copyright © 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nagrand/NGRElement.h>
#import <Nagrand/NGRTypes.h>
#import <Nagrand/NGRBase.h>


///poi and map types
NGR_EXTERN NSString *const kTypeLocation;
NGR_EXTERN NSString *const kTypeBuilding;
NGR_EXTERN NSString *const kTypeFloor;
NGR_EXTERN NSString *const kTypePlanarGraph;

/*! 
 * @brief NGRDataModel，所有数据的基类
 */
@interface NGRDataModel : NSObject

/*!
 * @brief 根据key获取元素
 * @param key - 关键字
 * @return 元素
 */
- (NGRElement *)elementWithKey:(const char *)key;

- (NSString *)getStringWithKey:(const char *)key;
- (NGRID)getNGRIDWithKey:(const char *)key;
- (NSInteger)getIntegerWithKey:(const char *)key;
- (BOOL)getBoolWithKey:(const char *)key;

@end
