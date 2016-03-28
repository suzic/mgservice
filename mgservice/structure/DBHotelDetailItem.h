//
//  DBHotelDetailItem.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotelDetail, DBHotelDetailItemPic;

@interface DBHotelDetailItem : NSManagedObject

@property (nonatomic, retain) NSString * hotelcode;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) DBHotelDetail *belongHotelDetail;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBHotelDetailItem (CoreDataGeneratedAccessors)

- (void)addPicListObject:(DBHotelDetailItemPic *)value;
- (void)removePicListObject:(DBHotelDetailItemPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
