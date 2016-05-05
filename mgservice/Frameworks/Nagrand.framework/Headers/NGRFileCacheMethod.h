//
//  NGRFileCacheMethod.h
//  Nagrand
//
//  Created by Sanae on 16/4/15.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRHttpCacheMethod.h>

/*! 
 * @brief 文件缓存策略
 * @discussion 请求过的http会以文件的形式保存，再次请求时会先从文件读取，目前只支持GET请求
 */
@interface NGRFileCacheMethod : NGRHttpCacheMethod

/*!
 * @brief 构造方法
 * @param floderPath - 缓存文件的路径
 * @return NGRFileCacheMethod实例
 */
- (instancetype)initWithCacheFolder:(NSString *)floderPath;

/*!
 * @brief 清除缓存
 */
- (void)removeAll;

@end
