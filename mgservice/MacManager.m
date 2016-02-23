//
//  MacManager.m
//  WanDaMall
//
//  Created by Sanae on 15-1-10.
//  Copyright (c) 2015年 WanDa. All rights reserved.
//

#import "MacManager.h"
#import "YTLocationManager.h"

@implementation MacManager {
    NSString *_macAddress;
    
    MacResponseBlock _responseBlock;
    MacFailedBlock _failedBlock;
}

+ (instancetype)sharedInstance {
    static MacManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;

}

- (BOOL)hasMac {
    NSString *mac = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)YTLocation_MacAddressKey];
    if ([mac length] == 17) {
        return YES;
    }
    
    return NO;
}

- (void)getMacFromService:(MacResponseBlock)responseBlock failed:(MacFailedBlock)failedBlock {
    
    _responseBlock = [responseBlock copy];
    _failedBlock = [failedBlock copy];
    
    SHRequest *request = [SHRequest requestWithURL:@"10.11.88.104/cgi-bin/mac.sh" Paramer:nil];
    request.delegate = self;
    [request start];
    
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"10.11.88.104/cgi-bin" customHeaderFields:nil];
//    MKNetworkOperation *op = [engine operationWithPath:@"mac.sh" params:nil httpMethod:@"GET"];
//    [op onCompletion:^(MKNetworkOperation *operation){
//        if ([[op responseString] length] >= 17) {
//            _macAddress = [[op responseString] substringToIndex:17];
//            [[NSUserDefaults standardUserDefaults] setObject:_macAddress forKey:(NSString *)YTLocation_MacAddressKey];
//
//        }else {
//            NSError *error = [[NSError alloc] initWithDomain:kWrongMac code:2 userInfo:nil];
//            failedBlock(error);
//        }
//        
//        responseBlock(_macAddress);
//        
//    }onError:^(NSError *error){
//        
//        failedBlock(error);
//    }];
//    [engine enqueueOperation:op];

}

- (void)request:(SHRequest *)request DidFinish:(NSData *)data {
    NSString *Mac = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([Mac length] >= 17) {
        _macAddress = [Mac substringToIndex:17];
        [[NSUserDefaults standardUserDefaults] setObject:_macAddress forKey:(NSString *)YTLocation_MacAddressKey];

        _responseBlock(_macAddress);
    }else {
        NSError *error = [[NSError alloc] initWithDomain:kWrongMac code:2 userInfo:nil];
        _failedBlock(error);
        
    }
    
}

- (void)requestFail:(SHRequest *)request {
    NSError *error = [[NSError alloc] initWithDomain:@"请求失败" code:2 userInfo:nil];
    _failedBlock(error);

}

- (NSString *)getMacFromLocal {
    _macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)YTLocation_MacAddressKey];
    
    return _macAddress;
}
@end
