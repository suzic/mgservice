//
//  DBCancel.h
//  mgmanager
//
//  Created by 苏智 on 15/5/28.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoomOrder;

@interface DBCancel : NSManagedObject

@property (nonatomic, retain) NSSet *hasRoomOrders;
@end

@interface DBCancel (CoreDataGeneratedAccessors)

- (void)addHasRoomOrdersObject:(DBRoomOrder *)value;
- (void)removeHasRoomOrdersObject:(DBRoomOrder *)value;
- (void)addHasRoomOrders:(NSSet *)values;
- (void)removeHasRoomOrders:(NSSet *)values;

@end
