//
//  DBRoomTypeOrder.h
//  mgmanager
//
//  Created by 刘超 on 15/7/9.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBaseOrder, DBRoomTypeDailyPrice, DBRoomTypeGuest;

@interface DBRoomTypeOrder : NSManagedObject

@property (nonatomic, retain) NSString * guestCount;
@property (nonatomic, retain) NSString * rateCode;
@property (nonatomic, retain) NSString * rateName;
@property (nonatomic, retain) NSString * roomCount;
@property (nonatomic, retain) NSString * totalPrice;
@property (nonatomic, retain) NSSet *hasDaily;
@property (nonatomic, retain) NSSet *hasGuests;
@property (nonatomic, retain) DBBaseOrder *orderSummary;
@end

@interface DBRoomTypeOrder (CoreDataGeneratedAccessors)

- (void)addHasDailyObject:(DBRoomTypeDailyPrice *)value;
- (void)removeHasDailyObject:(DBRoomTypeDailyPrice *)value;
- (void)addHasDaily:(NSSet *)values;
- (void)removeHasDaily:(NSSet *)values;

- (void)addHasGuestsObject:(DBRoomTypeGuest *)value;
- (void)removeHasGuestsObject:(DBRoomTypeGuest *)value;
- (void)addHasGuests:(NSSet *)values;
- (void)removeHasGuests:(NSSet *)values;

@end
