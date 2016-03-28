//
//  DBRoomLocation.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoom;

@interface DBRoomLocation : NSManagedObject

@property (nonatomic, retain) NSString * left;
@property (nonatomic, retain) NSString * normalsize;
@property (nonatomic, retain) id points;
@property (nonatomic, retain) NSString * roomCode;
@property (nonatomic, retain) NSString * rotatin;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * top;
@property (nonatomic, retain) DBRoom *belongRoom;

@end
