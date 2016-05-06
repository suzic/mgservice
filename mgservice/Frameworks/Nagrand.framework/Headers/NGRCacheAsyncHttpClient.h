//
//  NGRCacheAsyncHttpClient.h
//  Nagrand
//
//  Created by Sanae on 16/4/15.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRAsyncHttpClient.h>

@class NGRHttpCacheMethod;

/*! 
 * @brief 描述带缓存的异步http请求
 * @discussion NGRAsyncHttpClient的子类，自带缓存，可以通过构造时的NGRHttpCacheMethod控制缓存
 */
@interface NGRCacheAsyncHttpClient : NGRAsyncHttpClient

/*!
 * @brief 设置缓存管理策略
 * @param method - 缓存方法
 */
- (void)reset:(NGRHttpCacheMethod *)method;

@end
