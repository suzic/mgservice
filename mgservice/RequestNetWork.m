//
//  RequestNetWork.m
//  mgservice
//
//  Created by 罗禹 on 16/3/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "RequestNetWork.h"

@interface RequestNetWork ()

@property (nonatomic,strong) NSMutableArray * delegateArray;

@end

@implementation RequestNetWork

// 单例
+ (instancetype)defaultManager {
    static RequestNetWork * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        manager.delegateArray = [[NSMutableArray alloc]init];
    });
    
    return manager;
}

#pragma mark - 设置代理
// 注册代理
- (void)registerDelegate:(id<RequestNetWorkDelegate>)delegate {
    if (delegate) {
        for (id<RequestNetWorkDelegate> delegatenet in self.delegateArray) {
            if (delegatenet == delegate) {
                self.delegete = delegate;
                return;
            }
        }
        [self.delegateArray addObject:delegate];
        self.delegete = delegate;
    }
}

// 注销代理
- (void)removeDelegate:(id<RequestNetWorkDelegate>)delegate {
    if (delegate) {
        [self.delegateArray removeObject:delegate];
    }
}

#pragma mark - 网络请求方法

// 开始请求
- (NSURLSessionTask *)POSTWithTopHead:(NSString *)tophead webURL:(NSString *)url params:(NSDictionary *)params withByUser:(BOOL)byUser {
    self.topHead = tophead;
    self.requestURL = url;
    self.params = params;
    self.serverAddress = [MySingleton sharedSingleton].baseInterfaceUrl;
    NetWorkHelp *netWorkHelp = [[NetWorkHelp alloc] init];
    
    // 判断查询间隔是否满足足够长的状态（当byUser为NO时，间隔不够时将不发送实际请求）
    BOOL sendNetWork = [netWorkHelp ComparingNetworkRequestTime:url ByUser:byUser];
    if (sendNetWork == NO) {
        return nil;
    }else {
        NSTimeInterval timestamp = [Util timestamp];
        // 设置请求头
        NSMutableDictionary* header = [[NSMutableDictionary alloc]init];
        [header setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
        [header setObject:@"" forKey:@"mymhotel-ticket"];
        [header setObject:@"1002" forKey:@"mymhotel-type"];
        [header setObject:@"4.0" forKey:@"mymhotel-version"];
        [header setObject:@"JSON" forKey:@"mymhotel-dataType"];
        [header setObject:@"JSON" forKey:@"mymhotel-ackDataType"];
        [header setObject:[Util getMacAdd] forKey:@"mymhotel-sourceCode"];
        [header setObject:[NSString stringWithFormat:@"%f",timestamp] forKey:@"mymhotel-dateTime"];
        [header setObject:@"no-cache" forKey:@"Pragma"];
        [header setObject:@"no-cache" forKey:@"Cache-Control"];
        [YWNetWork setHeaders:header];
        // 代理方法请求开始
        for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(startRequest:)] && delegate == self.delegete) {
                [delegate startRequest:nil];
            }
        }
        //__weak __typeof(self) weakSelf = self;
        NSURLSessionTask * urltask =  [self POSTWithSuccess:^(id responseObject,NSURLSessionTask * task,NSDictionary * headers) {
            [self parseResult:responseObject urltask:task url:(NSString *)url headers:headers];
            //NSLog(@"response = %@",responseObject);
        } failure:^(NSError *error,NSURLSessionTask * task,NSDictionary * headers) {
            [self parseResult:error urltask:task url:url headers:headers];
            //NSLog(@"error = %@",error);
        }];
        return urltask;
    }
}

#pragma mark - 请求结果
// 返回结果
- (void)parseResult:(id)responseObj urltask:(NSURLSessionTask *)task url:(NSString *)viewURL headers:(NSDictionary *)headers{
    NSDictionary *header = headers;
    NSString *responseCode = [header objectForKey:@"mymhotel-status"];
    NSString *responseMsg = [header objectForKey:@"mymhotel-message"];
    
    // 无响应：网络连接失败
    if (responseCode == NULL)
    {
        for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailed:responseCode:withMessage:)] && delegate == self.delegete) {
                [delegate pushResponseResultsFailed:task responseCode:responseCode withMessage:responseMsg];
            }
        }
        return;
    }
    // 有网络连接
    NSString *unicodeStr = [NSString stringWithCString:[responseMsg cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
    NSLog(@"返回的数据:%@", unicodeStr);
    
    // 解析状态数据
    NSArray* msgs = [unicodeStr componentsSeparatedByString:@"|"];
    // 登录失败或者超时的情况，自动登录一次（之前的操作未完成，需要用户重新点击发起操作）
    if ([msgs[0] isEqualToString:@"EBA013"]
        ||[msgs[0] isEqualToString:@"TICKET_ISNULL"]
        ||[msgs[0] isEqualToString:@"TOKEN_INVALID"]
        ||[msgs[0] isEqualToString:@"UNLOGIN"]
        ||[msgs[0] isEqualToString:@"EBF001"]
        ||[msgs[0] isEqualToString:@"ES0003"]
        ||[msgs[0] isEqualToString:@"ES0001"]) {
        for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailed:responseCode:withMessage:)] && delegate == self.delegete) {
                [delegate pushResponseResultsFailed:task responseCode:responseCode withMessage:msgs[1]];
            }
        }
        return;
    }
    // 返回无数据的状态
    if (msgs != nil && msgs.count > 1) {
        NSRange range = [msgs[1] rangeOfString:@"不存在"];
        if ([responseCode isEqualToString:@"ERR"]
            || [msgs[1]isEqualToString:@"无数据"]
            || [msgs[1]isEqualToString:@"数据空"]
            || range.length > 0) {
            for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
                if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailed:responseCode:withMessage:)] && delegate == self.delegete) {
                    [delegate pushResponseResultsFailed:task responseCode:responseCode withMessage:msgs[1]];
                }
            }
            return;
        }
    }else {
        for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailed:responseCode:withMessage:)] && delegate == self.delegete) {
                [delegate pushResponseResultsFailed:task responseCode:responseCode withMessage:unicodeStr];
            }
        }
    }
    
    if (responseObj != nil) {
        @try
        {
            Parser *parser = [[Parser alloc]init];
            NSMutableArray* array = [parser parser:viewURL fromData:responseObj];
            // 不需要返回数据的请求
            if (array.count < 1){
                for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFinished:responseCode:withMessage:andData:)] && delegate == self.delegete) {
                        [delegate pushResponseResultsFinished:task responseCode:responseCode withMessage:@"" andData:nil];
                    }
                }
                return;
            }
            // 有返回数据的请求
            for (id<RequestNetWorkDelegate> delegate in self.delegateArray) {
                if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFinished:responseCode:withMessage:andData:)] && delegate == self.delegete) {
                    [delegate pushResponseResultsFinished:task responseCode:responseCode withMessage:@"" andData:array];
                }
            }
        }
        @catch (NSException *exception){
        }
    }
}

@end
