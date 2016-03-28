//
//  DBFloor.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBuilding, DBFloorImage, DBRoom;

@interface DBFloor : NSManagedObject

@property (nonatomic, retain) NSString * floorCode;
@property (nonatomic, retain) NSString * floorName;
@property (nonatomic, retain) NSNumber * isReserve;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * reserveCount;
@property (nonatomic, retain) DBBuilding *belongBuiding;
@property (nonatomic, retain) DBFloorImage *floorImage;
@property (nonatomic, retain) NSSet *hasRooms;
@end

@interface DBFloor (CoreDataGeneratedAccessors)

- (void)addHasRoomsObject:(DBRoom *)value;
- (void)removeHasRoomsObject:(DBRoom *)value;
- (void)addHasRooms:(NSSet *)values;
- (void)removeHasRooms:(NSSet *)values;

@end
