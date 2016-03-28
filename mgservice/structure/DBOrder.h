//
//  DBOrder.h
//  mgmanager
//
//  Created by 刘超 on 15/7/30.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBaseOrder;

@interface DBOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * orderStatus;
@property (nonatomic, retain) NSString * totalIdx;
@property (nonatomic, retain) NSString * totalMoney;
@property (nonatomic, retain) NSSet *hasBaseOrder;
@end

@interface DBOrder (CoreDataGeneratedAccessors)

- (void)addHasBaseOrderObject:(DBBaseOrder *)value;
- (void)removeHasBaseOrderObject:(DBBaseOrder *)value;
- (void)addHasBaseOrder:(NSSet *)values;
- (void)removeHasBaseOrder:(NSSet *)values;

@end
