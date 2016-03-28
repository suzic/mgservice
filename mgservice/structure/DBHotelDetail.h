//
//  DBHotelDetail.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotel, DBHotelDetailItem, DBHotelDetailPic;

@interface DBHotelDetail : NSManagedObject

@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) NSString * thumbUrl;
@property (nonatomic, retain) DBHotel *belongHotel;
@property (nonatomic, retain) NSSet *hasItem;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBHotelDetail (CoreDataGeneratedAccessors)

- (void)addHasItemObject:(DBHotelDetailItem *)value;
- (void)removeHasItemObject:(DBHotelDetailItem *)value;
- (void)addHasItem:(NSSet *)values;
- (void)removeHasItem:(NSSet *)values;

- (void)addPicListObject:(DBHotelDetailPic *)value;
- (void)removePicListObject:(DBHotelDetailPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
