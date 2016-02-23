//
//  SHRequest.m
//  lvmall
//
//  Created by Choi on 14-7-7.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import "SHRequest.h"

#define kTimeoutInterval 0.5

@interface SHRequest()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *_url;
    NSArray *_paramer;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
        
    BOOL _isrequesting;
}
@end
@implementation SHRequest

- (id)initWithURL:(NSString *)url Paramer:(NSArray *)paramer
{
    self = [super init];
    
    if (self) {
        _isrequesting = NO;
        _url = [url retain];
        _paramer = [paramer retain];
        }
    
    return self;
}

+ (SHRequest *)requestWithURL:(NSString *)url Paramer:(NSArray *)paramer
{
    SHRequest *request = [[[SHRequest alloc] initWithURL:url Paramer:paramer] autorelease];
    
    return request;
}

- (void)start
{
    if (_isrequesting) {
        return;
    }
    _isrequesting = YES;
    [self retain];
    
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    for (NSDictionary *dictionary in _paramer) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            if ([obj length] && [key length]) {
                [string appendFormat:@"%@=%@&",key,obj];
//            }
        }];
    }
    if ([string length]) {
        string = [string substringToIndex:[string length] - 1];
    }
    
    NSString *urlString = [_url stringByAppendingString:string];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"请求连接:%@",urlString);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[_url stringByAppendingString:string]]];
    //判断url是否可用！！！
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:20];
//    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = kTimeoutInterval;
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
}
- (void)cancel
{
    [_connection    cancel];
    [_connection    release];
    [_url           release];
    [_paramer       release];
    [_data          release];
    
    _connection     = nil;
    _url            = nil;
    _paramer        = nil;
    _data           = nil;
    _isrequesting   = NO;
}

- (BOOL)isRequsting
{
    return _isrequesting;
}

//代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data release];
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [_data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    _isrequesting = NO;
    [self autorelease];
    
    if ([_delegate respondsToSelector:@selector(request:DidFinish:)]) {
        [_delegate request:self DidFinish:_data];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _isrequesting = NO;
    [self autorelease];
    
    if ([_delegate respondsToSelector:@selector(requestFail:)]) {
        [_delegate requestFail:self];
    }
}


- (void)dealloc
{
    [_data release];
    [_url release];
    [_paramer release];
    
    [super dealloc];
}

@end
