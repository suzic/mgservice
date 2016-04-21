/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description:网络数据处理基类
 */

#import "BaseInterface.h"
#import "InterfaceCache.h"
#import "NSDictionary+AllKeytoLowerCase.h"

@implementation BaseInterface

@synthesize baseDelegate = _baseDelegate,request = _request;
@synthesize interfaceURL = _interfaceURL,headers = _headers,bodys = _bodys;

- (void)connect_json:(NSMutableDictionary *)parameter
{
    if (self.interfaceURL)
    {
        NSURL *url = [[NSURL alloc]initWithString:self.interfaceURL];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [self.request setValidatesSecureCertificate:NO];
        [url release];
        if (self.headers)
        {
            for (NSString *key in self.headers)
            {
                [self.request addRequestHeader:key value:[self.headers objectForKey:key]];
            }
        }
        NSString* value = [parameter JSONRepresentation];
        NSData* jsonbody = [value dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.request setTimeOutSeconds:30];
        [self.request appendPostData:jsonbody];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }
    else
    {
        //抛出异常
    }
}

- (void)connect_xml:(NSMutableDictionary*)parameter
{
    if (self.interfaceURL)
    {
        NSEnumerator* enumerator = [parameter keyEnumerator];
        NSString* key = @"";
        NSString* param = @"";
        int index = 0;
        while (key = [enumerator nextObject])
        {
            NSString* value = [parameter objectForKey:key];
            NSString* temp = [[key stringByAppendingString:@"="]stringByAppendingString:value];
            param = [param stringByAppendingString:temp];
            if (index < parameter.count - 1) {
                param = [param stringByAppendingString:@"&"];
            }
            index++;
        }
        self.interfaceURL = [[self.interfaceURL stringByAppendingString:@"?"]stringByAppendingString:param];

        NSURL *url = [[NSURL alloc]initWithString:self.interfaceURL];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [self.request setRequestMethod:@"GET"];
        [self.request setTimeOutSeconds:30];
        [url release];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }
}

- (void)connect_normal:(NSMutableDictionary *)parameter
{
    if (self.interfaceURL)
    {
        NSURL *url = [[NSURL alloc]initWithString:self.interfaceURL];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [self.request setRequestMethod:@"GET"];
        [url release];
        if (self.headers)
        {
            for (NSString *key in self.headers)
            {
                [self.request addRequestHeader:key value:[self.headers objectForKey:key]];
            }
        }
        NSEnumerator* enumerator = [parameter keyEnumerator];
        NSString* key = @"";
        while (key=[enumerator nextObject])
        {
            NSString* value = [parameter objectForKey:key];
            value = [self.request encodeURL:value];
            [self.request addPostValue:value forKey:key];
        }
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }
    else
    {
        //抛出异常
    }
}

#pragma mark - LNHTTPRequestDelegate

- (void)request:(LNHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    responseHeaders = [responseHeaders allKeytoLowerCase];
}

- (void)requestFinished:(LNHTTPRequest *)request
{
    if (self.baseDelegate != nil && [self.baseDelegate respondsToSelector:@selector(parseResult:)])
        [self.baseDelegate parseResult:request];
}

- (void)requestFailed:(LNHTTPRequest *)request
{
    if (self.baseDelegate != nil && [self.baseDelegate respondsToSelector:@selector(requestIsFailed:)])
        [self.baseDelegate requestIsFailed:request.error];
}

@end
