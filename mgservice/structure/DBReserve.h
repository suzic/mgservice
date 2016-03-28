//
//  DBReserve.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBMenuInOrder, DBUserLogin;

@interface DBReserve : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSString * menuOrderMoney;
@property (nonatomic, retain) NSString * orderMoney;
@property (nonatomic, retain) NSString * orderNumber;
@property (nonatomic, retain) NSString * otherCharge;
@property (nonatomic, retain) NSString * otherNote;
@property (nonatomic, retain) NSString * payStatue;
@property (nonatomic, retain) NSString * payType;
@property (nonatomic, retain) NSString * serviceCharge;
@property (nonatomic, retain) NSString * specialNote;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSSet *hasMenuInOrder;
@property (nonatomic, retain) DBUserLogin *belongUser;
@end

@interface DBReserve (CoreDataGeneratedAccessors)

- (void)addHasMenuInOrderObject:(DBMenuInOrder *)value;
- (void)removeHasMenuInOrderObject:(DBMenuInOrder *)value;
- (void)addHasMenuInOrder:(NSSet *)values;
- (void)removeHasMenuInOrder:(NSSet *)values;

@end
