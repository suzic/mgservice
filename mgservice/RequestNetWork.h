//
//  RequestNetWork.h
//  mgservice
//
//  Created by 罗禹 on 16/3/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "YWNetWork.h"
#import "NetWorkHelp.h"
#import "Parser.h"

@protocol RequestNetWorkDelegate <NSObject>
@required
/**
 *  @abstract 请求开始
 */
- (void)startRequest:(NSURLSessionTask *)task;

/**
 *  @abstract 派发成功数据
 */
- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString*)code withMessage:(NSString*)msg andData:(NSMutableArray*)datas;

/**
 *  @abstract 派发失败数据
 */
- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg;

@end

@interface RequestNetWork : YWNetWork

+ (instancetype)defaultManager;

- (void)registerDelegate:(id<RequestNetWorkDelegate>) delegate;

- (void)removeDelegate:(id<RequestNetWorkDelegate>) delegate;

- (NSURLSessionTask *)POSTWithTopHead:(NSString *)tophead webURL:(NSString *)url params:(NSDictionary *)params withByUser:(BOOL)byUser;

@end
