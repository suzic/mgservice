//
//  SHRequest.h
//  lvmall
//
//  Created by Choi on 14-7-7.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

/*
 中文字符串处理成
 NSString *name = [self.textFieldLianXiRen.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 */

#import <Foundation/Foundation.h>

@protocol SHRequestDelegate;
@interface SHRequest : NSObject

@property (nonatomic, assign)id<SHRequestDelegate> delegate;

+ (SHRequest *)requestWithURL:(NSString *)url Paramer:(NSArray *)paramer;//简单get请求

- (void)start;
- (void)cancel;

- (BOOL)isRequsting;

@end


@protocol SHRequestDelegate <NSObject>

- (void)request:(SHRequest *)request DidFinish:(NSData *)data;
- (void)requestFail:(SHRequest *)request;
- (void)requestUrlIsNotReachable;

@end