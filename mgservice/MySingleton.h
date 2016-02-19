/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description: 封装了请求服务器的url
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MySingleton : NSObject

+ (MySingleton *)sharedSingleton;

@property (nonatomic,strong) NSString *sessionId;

@property (nonatomic,readonly) NSString *baseInterfaceUrl;//接口地址根路径

@property (nonatomic,readonly) NSString *baseIntertestUrl;//测试接口地址根路径

@property (nonatomic,readonly) NSString *weixinInterfaceUrl;
@end
