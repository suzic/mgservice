//
//  NGREngine.h
//  Nagrand
//
//  Created by Yongxian Wu on 11/10/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @brief 所有渲染引擎的模块都依赖这个类。包括权限的验证等。
 * @discussion 我们建议在使用任何引擎中的模块前，先对这个类进行注册，这样可以确保所有的模块都可以被成功的初始化。尤其是保证startWithLicense尽早被执行到，不然可能会导致一些不明确的错误， 比如NGRDataSource的功能不可用。
 */
@interface NGREngine : NSObject

/*!
 * @brief 验证license的有效性。
 * @param license - 请从开发者网站获取license
 */
+(void) startWithLicense:(NSString *)license;

/*!
 * @brief 结束引擎的工作，关闭所有模块，停止所有功能使用。
 */
+(void) shutdown;

@end
