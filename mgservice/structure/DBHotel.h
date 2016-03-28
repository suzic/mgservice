//
//  DBHotel.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBuilding, DBHotelDetail, DBHotelPic, DBRest, DBService, DBShop;

@interface DBHotel : NSManagedObject

@property (nonatomic, retain) NSNumber * buildingCount;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * hotelIndxVal;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSSet *hasBuildings;
@property (nonatomic, retain) DBHotelDetail *hasDetail;
@property (nonatomic, retain) NSSet *hasRest;
@property (nonatomic, retain) NSSet *hasService;
@property (nonatomic, retain) NSSet *hasShop;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBHotel (CoreDataGeneratedAccessors)

- (void)addHasBuildingsObject:(DBBuilding *)value;
- (void)removeHasBuildingsObject:(DBBuilding *)value;
- (void)addHasBuildings:(NSSet *)values;
- (void)removeHasBuildings:(NSSet *)values;

- (void)addHasRestObject:(DBRest *)value;
- (void)removeHasRestObject:(DBRest *)value;
- (void)addHasRest:(NSSet *)values;
- (void)removeHasRest:(NSSet *)values;

- (void)addHasServiceObject:(DBService *)value;
- (void)removeHasServiceObject:(DBService *)value;
- (void)addHasService:(NSSet *)values;
- (void)removeHasService:(NSSet *)values;

- (void)addHasShopObject:(DBShop *)value;
- (void)removeHasShopObject:(DBShop *)value;
- (void)addHasShop:(NSSet *)values;
- (void)removeHasShop:(NSSet *)values;

- (void)addPicListObject:(DBHotelPic *)value;
- (void)removePicListObject:(DBHotelPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
