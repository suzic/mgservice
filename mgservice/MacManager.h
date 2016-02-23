//
//  MacManager.h
//  WanDaMall
//
//  Created by Sanae on 15-1-10.
//  Copyright (c) 2015年 WanDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRequest.h"

static NSString *kWrongMac = @"错误的mac";

typedef void (^MacResponseBlock)(NSString* mac);
typedef void (^MacFailedBlock)(NSError* error);

@interface MacManager : NSObject<SHRequestDelegate>

+ (instancetype)sharedInstance;

- (BOOL)hasMac;

- (void)getMacFromService:(MacResponseBlock)responseBlock failed:(MacFailedBlock)failedBlock;

- (NSString *)getMacFromLocal;

@end
