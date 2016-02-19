//
//  InterfaceCache.h
//  BeautyDiary
//
//  Created by 王 玲玲 on 13-8-5.
//  Copyright (c) 2013年 王 玲玲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNCacheDelegate.h"
#import "ASIFormDataRequest.h"
@interface InterfaceCache : NSObject<LNCacheDelegate>

{
    LNCachePolicy defaultCachPolicy;
    NSString *storePath;//默认为一个目录,名为“ASIHTTPRequestCache的临时目录
    NSRecursiveLock *accessLock;//锁
    BOOL shouldRespectCacheControlHeaders;//防止重新存储
}
+(id)sharedCache;//返回ASIDownloadCache的一个静态实例,全局缓存，调用
//[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]进行自动缓存
+(BOOL)serverAllowsResponseCachingForRequest:(LNHTTPRequest *)request;//通过查看请求的响应标头,决定服务器请求数据是否该被缓存
+(NSArray *)fileExtensionsToHandleAsHTML;//路径操作
@property (assign, nonatomic) LNCachePolicy defaultCachePolicy;
@property (retain, nonatomic) NSString *storagePath;
@property (retain) NSRecursiveLock *accessLock;//
@property (assign) BOOL shouldRespectCacheControlHeaders;
@end
