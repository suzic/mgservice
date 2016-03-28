//
//  DBBuilding.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBFloor, DBHotel;

@interface DBBuilding : NSManagedObject

@property (nonatomic, retain) NSString * buildingCode;
@property (nonatomic, retain) NSString * buildingName;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) DBHotel *belongHotel;
@property (nonatomic, retain) NSSet *hasFloors;
@end

@interface DBBuilding (CoreDataGeneratedAccessors)

- (void)addHasFloorsObject:(DBFloor *)value;
- (void)removeHasFloorsObject:(DBFloor *)value;
- (void)addHasFloors:(NSSet *)values;
- (void)removeHasFloors:(NSSet *)values;

@end
