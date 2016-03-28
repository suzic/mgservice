//
//  DBHotelDetailItemPic.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotelDetailItem, DBSubPic;

@interface DBHotelDetailItemPic : NSManagedObject

@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) DBHotelDetailItem *belongItem;
@property (nonatomic, retain) NSSet *subPicList;
@end

@interface DBHotelDetailItemPic (CoreDataGeneratedAccessors)

- (void)addSubPicListObject:(DBSubPic *)value;
- (void)removeSubPicListObject:(DBSubPic *)value;
- (void)addSubPicList:(NSSet *)values;
- (void)removeSubPicList:(NSSet *)values;

@end
