//
//  DBRoomOrder.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBaseOrder;

@interface DBRoomOrder : NSManagedObject

@property (nonatomic, retain) NSString * floorCode;
@property (nonatomic, retain) NSString * floorName;

@property (nonatomic, retain) NSString * guestName;
@property (nonatomic, retain) NSString * isFloor;
@property (nonatomic, retain) NSString * roomCode;

@property (nonatomic, retain) NSString * roomIdx;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSString * viewIntor;
@property (nonatomic, retain) DBBaseOrder *orderSummary;

@end
