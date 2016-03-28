//
//  DBBindRoom.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBBindRoom : NSManagedObject

@property (nonatomic, retain) NSString * appid;
@property (nonatomic, retain) NSString * bindingTicket;
@property (nonatomic, retain) NSString * bindMethod;
@property (nonatomic, retain) NSString * buildingCode;
@property (nonatomic, retain) NSString * buildingName;
@property (nonatomic, retain) NSString * floorCode;
@property (nonatomic, retain) NSString * floorName;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSString * pagersCode;
@property (nonatomic, retain) NSString * roomCode;
@property (nonatomic, retain) NSString * roomInfo;
@property (nonatomic, retain) NSString * roomTypeCode;
@property (nonatomic, retain) NSString * roomTypeName;
@property (nonatomic, retain) NSString * status;

@end
