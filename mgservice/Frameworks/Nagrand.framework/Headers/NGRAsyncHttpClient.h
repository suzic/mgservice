//
//  NGRAsyncHttpClient.h
//  Nagrand
//
//  Created by Sanae on 16/4/15.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 
 * @brief 描述异步http请求的类
 * @discussion 控制http请求的服务器地址，如果想要http缓存请查看子类NGRCacheAsyncHttpClient
 */
@interface NGRAsyncHttpClient : NSObject

/*!
 * @brief 构造方法
 * @param root - 服务器地址
 * @return NGRAsyncHttpClient实例
 */
- (instancetype)initWithRoot:(NSString *)root;

@end
