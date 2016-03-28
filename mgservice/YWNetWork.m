//
//  YWNetWork.m
//  yiwuxunfengAFN
//
//  Created by 罗禹 on 16/3/18.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import "YWNetWork.h"

static NSDictionary * _headers;

@implementation YWNetWork

// 初始化请求 设置参数
- (instancetype)initWithTopHead:(NSString *)tophead serverAddress:(NSString *)serverAddress requestURL:(NSString *)url params:(NSDictionary *)params{
    if (self = [super init]) {
        self.topHead = tophead;
        self.serverAddress = serverAddress;
        self.requestURL = url;
        self.url = [NSString stringWithFormat:@"%@%@%@",_topHead,_serverAddress,_requestURL];
        self.params = params;
    }
    return self;
}

// 设置请求头
+ (void)setHeaders:(NSDictionary *)headers {
    _headers = headers;
}
// 取消单个请求（请用下面那个）
- (void)cancleRequest {
    [self.task cancel];
}

// 取消所有请求
- (void)cancleAllRequest {
    [_manager.operationQueue cancelAllOperations];
}

// post请求 返回NSURLSessionTask实例 用于区别请求 和控制请求
- (NSURLSessionTask *)POSTWithSuccess:(YiWuResponseSuccess)success failure:(YiWuResponseFailure)failure {
    
    AFHTTPSessionManager * manager = [self manager];
    //__weak __typeof(self) weakSelf = self;
    self.url = [NSString stringWithFormat:@"%@%@%@",_topHead,_serverAddress,_requestURL];
    NSURLSessionTask * urltask = [manager POST:self.url
                                 parameters:self.params
                                   progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
            NSLog(@"responseHeader = %@",response.allHeaderFields);
            success(responseObject,task,response.allHeaderFields);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        if (failure) {
            NSLog(@"responseHeader = %@",response.allHeaderFields);
            failure(error,task,response.allHeaderFields);
        }
    }];
    NSLog(@"urltask = %@",urltask);
    NSLog(@"url = %@",self.url);
    NSLog(@"params = %@",self.params);
    NSLog(@"header = %@",_headers);
    return urltask;
}

// 设置请求对象参数
- (AFHTTPSessionManager *)manager {
    self.manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer.timeoutInterval = 15;
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString * key in _headers) {
        [_manager.requestSerializer setValue:_headers[key] forHTTPHeaderField:key];
    }
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    return _manager;
}

@end
