//
//  NGRCacheAsyncHttpClient.h
//  Nagrand
//
//  Created by Sanae on 16/4/15.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Nagrand/NGRAsyncHttpClient.h>

@class NGRHttpCacheMethod;

@interface NGRCacheAsyncHttpClient : NGRAsyncHttpClient

- (void)reset:(NGRHttpCacheMethod *)method;

@end
