//
//  DBRoomTypeDailyPrice.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoomTypeOrder;

@interface DBRoomTypeDailyPrice : NSManagedObject

@property (nonatomic, retain) NSString * dayName;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * unitPrice;
@property (nonatomic, retain) DBRoomTypeOrder *belongRoomTypeOrder;

@end
