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
 *  @params  task   请求返回实例
 */
- (void)startRequest:(NSURLSessionTask *)task;

/**
 *  @abstract 派发成功数据
 *  @params  task   请求返回实例
 *  @params  code   返回头信息 网络请求状态
 *  @params  msg    返回头信息 返回的消息
 *  @params  datas  请求成功 返回的数据
 */
- (void)pushResponseResultsFinished:(NSURLSessionTask *)task responseCode:(NSString*)code withMessage:(NSString*)msg andData:(NSMutableArray*)datas;

/**
 *  @abstract 派发失败数据
 *  @params  task   请求返回实例
 *  @params  code   返回头信息 网络请求状态
 *  @params  msg    返回头信息 返回的消息
 */
- (void)pushResponseResultsFailed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg;

@end


@interface RequestNetWork : YWNetWork


@property (nonatomic,weak) id <RequestNetWorkDelegate> delegete;
/**
 *  @abstract 创建单例对象
 */
+ (instancetype)defaultManager;

/**
 *  @abstract 注册代理
 *  @params  delegate  代理的对象
 */
- (void)registerDelegate:(id<RequestNetWorkDelegate>) delegate;

/**
 *  @abstract 注销代理
 *  @params  delegate  代理的对象
 */
- (void)removeDelegate:(id<RequestNetWorkDelegate>) delegate;

/**
 *  @abstract 发送请求
 *  @params  tophead   http: or https:(pch文件中typedef)
 *  @params  url       请求URL，（服务器地址后的）
 *  @params  params    请求参数
 *  @params  byUser    是否是主动刷新 强制刷新需要
 */
- (NSURLSessionTask *)POSTWithTopHead:(NSString *)tophead webURL:(NSString *)url params:(NSDictionary *)params withByUser:(BOOL)byUser;

@end
