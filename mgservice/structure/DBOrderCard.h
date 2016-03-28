//
//  DBOrderCard.h
//  mgmanager
//
//  Created by 刘超 on 15/6/29.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoomOrder;

@interface DBOrderCard : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * cardKind;
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSString * cardNo;
@property (nonatomic, retain) NSString * effect;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * idx;
@property (nonatomic, retain) NSString * idxVal;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * outerIdx;
@property (nonatomic, retain) DBRoomOrder *belongRoomOrder;

@end
