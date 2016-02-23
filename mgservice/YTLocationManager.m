//
//  YTLocationManager.m
//  WanDaMall
//
//  Created by Choi on 14-8-8.
//  Copyright (c) 2014年 WanDa. All rights reserved.
//

/*
 {"error": "RESOURCE_NOT_FOUND"}
 
 {"query_location_response": {"location":{"x":1233,"y":5566,"planar_graph_id":"floorID"}}}
 */

#import "YTLocationManager.h"

#define Kdistance 1.0

@implementation YTLocation
@end


static const float kYTLocationManager_Timeout = 4.0f;

@interface YTLocationManager()
{
    NSTimer *_timer;
    YTLocation *_location;
    
    NSBlockOperation *_operation;
    GCDAsyncUdpSocket *_udpSocket;
    long _udpTag;
    
    BOOL _isLocation;
    
    NSMutableArray *_locations;
}

@end
@implementation YTLocationManager

- (id)initWithUrlString:(NSString *)urlString MacAddress:(NSString *)macAddress
{
    self = [super init];
    
    if (self) {
        _updateTime = 1.0f;

        _urlString = urlString;
        _macAddress = macAddress;
        _isLocation = NO;
        
        _locations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

#pragma mark---------------对外接口

- (void)startUpdateLocation
{
    if (_timer.isValid) {
        return;
    }
    
    if (!_macAddress) {
        NSString *mac = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)YTLocation_MacAddressKey];
        if (!mac) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.1.210/mac.dll"]];
//            mac = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            mac = @"74:e5:0b:9b:45:18";
            [[NSUserDefaults standardUserDefaults] setObject:mac forKey:(NSString *)YTLocation_MacAddressKey];
        }
        NSLog(@"---------mac = %@", mac);
        _macAddress = mac;
        
    }
    //建立udp
//    [self setupUdpSocket];
    
    [self initTime];
    [_timer fire];
    _isLocation = YES;
}
- (void)stopUpdateLocation
{
    [_timer invalidate];
    _timer = nil;
    [_operation cancel];
    _operation = nil;
    
    _isLocation = NO;
}

- (BOOL)isLocation {
    return _isLocation;
}

- (YTLocation *)lastLocation
{
    return _location;
}

- (void)setUpdateTime:(float)updateTime
{
    _updateTime = MIN(updateTime, 1.0);
    
    [_timer invalidate];
    _timer = nil;
    [self initTime];
}

#pragma mark---------------内部调用

- (void)setupUdpSocket {
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    
    if (![_udpSocket bindToPort:0 error:&error]) {
        NSLog(@"Error binding: %@", error);
        
    }
    if (![_udpSocket beginReceiving:&error]) {
        
    }

}
- (void)initTime
{
    if (!_timer) {
        NSLog(@"cui------updateTime = %f", _updateTime);
        _timer = [NSTimer scheduledTimerWithTimeInterval:_updateTime target:self selector:@selector(UpdateLocation) userInfo:nil repeats:YES];
    }
}
- (void)UpdateLocation
{
//    if (!_operation) {
//        _operation = [NSBlockOperation blockOperationWithBlock:^{
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *stringUrl = [NSString stringWithFormat:@"%@?mac=%@", _urlString, _macAddress];
//                NSLog(@"------url = %@", stringUrl);
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_urlString stringByAppendingFormat:@"?mac=%@",_macAddress]]];
//                NSLog(@"cui-------data = %@", data);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self upDateWithData:data];
//                });
//
//            });
//        }];
    
//        [_operation start];
//        [self performSelector:@selector(CancelOperation:) withObject:_operation afterDelay:kYTLocationManager_Timeout];
//    }
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@?mac=%@", _urlString, _macAddress];
//    NSURL *url = [NSURL URLWithString:stringUrl];
    SHRequest *pushCount = [SHRequest requestWithURL:_urlString Paramer:@[@{@"mac": _macAddress}]];
    pushCount.delegate = self;
    [pushCount start];
    
    [self.delegate logURL:stringUrl];
    
    //udp
//    NSString *appendString = @"palmap+/";
//    NSMutableString *string = [NSMutableString stringWithCapacity:128];
//    for (int i = 0; i<16; i ++) {
//        [string appendString:appendString];
//    }
//    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
//    [_udpSocket sendData:stringData toHost:@"192.168.0.107" port:61112 withTimeout:-1 tag:_udpTag];
//    _udpTag ++;

}

#pragma mark - UdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"cui------didSend!!");
    if ([self.delegate respondsToSelector:@selector(didUdpSocketConnectSuccess:)]) {
        [self.delegate didUdpSocketConnectSuccess:nil];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"cui-------sendUdpSocketFailed!!");
    if ([self.delegate respondsToSelector:@selector(didUdpSocketConnectFailed)]) {
        [self.delegate didUdpSocketConnectFailed];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                                fromAddress:(NSData *)address
                                            withFilterContext:(id)filterContext
{
    NSLog(@"cui----------ReceiveData!!");
    if ([self.delegate respondsToSelector:@selector(didUdpSocketConnectSuccess:)]) {
        [self.delegate didUdpSocketConnectSuccess:data];
    }
    
}

#pragma mark - RequestDelegate

- (void)request:(SHRequest *)request DidFinish:(NSData *)data {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self upDateWithData:data];
    });

}

- (void)requestFail:(SHRequest *)request {
    
//    if (_locations.count < 2) {
//        return;
//    }
//    
//    YTLocation *startLocation = [_locations objectAtIndex:0];
//    YTLocation *endLocation = [_locations lastObject];
//    CGPoint startP = CGPointMake(startLocation.x, startLocation.y);
//    CGPoint endP = CGPointMake(endLocation.x, endLocation.y);
//    
//    CGPoint p = [self createCounterfeitPointWithStartPoint:startP endPoint:endP distance:Kdistance];
//    NSLog(@"cui==============p = %@", NSStringFromCGPoint(p));
//    
//    YTLocation *location = [[YTLocation alloc] init];
//    location.x = p.x;
//    location.y = p.y;
//    location.floorID = _location.floorID;
//    
//    if ([_delegate respondsToSelector:@selector(ytLocationManager:didUpdateToLocation:fromLocation:)]) {
//        [_delegate ytLocationManager:self didUpdateToLocation:location fromLocation:_location];
//    }
//    _location = location;
//
//    if (_locations.count > 2) {
//        [_locations removeObjectAtIndex:0];
//    }
//    [_locations addObject:location];

    
    NSLog(@"filed!!!!!!!!!!");
}

- (void)upDateWithData:(NSData *)data
{
    [_operation cancel];
    _operation = nil;
    
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"string:%@",string);
    if (!data) {
        return;
    }
//    if ([NSJSONSerialization isValidJSONObject:string]) {
    NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (jsonObject[@"error"]) {//不在室内区域
            NSLog(@"RESOURCE_NOT_FOUND"); 
            if ([_delegate respondsToSelector:@selector(isOutSideYtLocationManager:)]) {
                [_delegate isOutSideYtLocationManager:self];
            }
            
        }else if(jsonObject[@"query_location_response"]){
            NSDictionary *locationDict = jsonObject[@"query_location_response"][@"location"];
            
            YTLocation *location = [[YTLocation alloc] init];
            location.x = [locationDict[@"x"] floatValue];
            location.y = [locationDict[@"y"] floatValue];
            location.floorID = [NSNumber numberWithInt:[locationDict[@"planar_graph_id"] intValue]];
            
            //位置不同时通知
            if ([_delegate respondsToSelector:@selector(ytLocationManager:didUpdateToLocation:fromLocation:)]) {
//                //红树林旋转修改
//                PMXPoint new = CGPointApplyAffineTransform(CGPointMake(location.x, location.y), CGAffineTransformMakeRotation(53. * M_PI/180.));
//                PMXPoint old = CGPointApplyAffineTransform(CGPointMake(_location.x, location.y), CGAffineTransformMakeRotation(53. * M_PI/180.));
//                location.x = new.x;
//                location.y = new.y;
//                _location.x = old.x;
//                _location.y = old.y;
                [_delegate ytLocationManager:self didUpdateToLocation:location fromLocation:_location];
            }
            _location = location;
            
            if (_locations.count > 2) {
                [_locations removeObjectAtIndex:0];
            }
            [_locations addObject:location];
            
        }
//    }
}

- (void)CancelOperation:(NSBlockOperation *)operation
{
    [operation cancel];
    _operation = nil;
}

- (void)dealloc
{
    [_operation cancel];
    _operation = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark --------mathMethed

- (CGPoint)createCounterfeitPointWithStartPoint:(CGPoint)p1 endPoint:(CGPoint)p2 distance:(double)distance {
    
    double px, py;
    
    CGPoint p1p2 = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    double p1p2M = sqrt((p1p2.x * p1p2.x) + (p1p2.y * p1p2.y));
    
    if (p1p2M) {
        CGPoint p1p2O = CGPointMake(p1p2.x / p1p2M, p1p2.y / p1p2M);
        
        CGPoint p2p = CGPointMake(distance * p1p2O.x, distance * p1p2O.y);
        
        px = p2p.x + p2.x;
        py = p2p.y + p2.y;
        
        return CGPointMake(px, py);

    }
    
    px = p2.x;
    py = p2.y;
    
    return CGPointMake(px, py);

}

@end







