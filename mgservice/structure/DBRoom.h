//
//  DBRoom.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBFloor, DBRoomLocation, DBRoomPic;

@interface DBRoom : NSManagedObject

@property (nonatomic, retain) NSString * addBedContent;
@property (nonatomic, retain) NSString * basicPrice;
@property (nonatomic, retain) NSString * bedTypeContent;
@property (nonatomic, retain) NSString * breakfastContent;
@property (nonatomic, retain) NSString * floorName;
@property (nonatomic, retain) NSString * guests;
@property (nonatomic, retain) NSString * idx;
@property (nonatomic, retain) NSString * infarIntro;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * netPrice;
@property (nonatomic, retain) NSString * networkContent;
@property (nonatomic, retain) NSString * pic1Uri;
@property (nonatomic, retain) NSString * pic2Uri;
@property (nonatomic, retain) NSString * pic3Uri;
@property (nonatomic, retain) NSString * pic4Uri;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * pricePrepay;
@property (nonatomic, retain) NSString * rateCode;
@property (nonatomic, retain) NSString * rateName;
@property (nonatomic, retain) NSString * reserveIdx;
@property (nonatomic, retain) NSString * roomCode;
@property (nonatomic, retain) NSString * roomIdx;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSString * roomTypeCode;
@property (nonatomic, retain) NSString * roomTypeDesc;
@property (nonatomic, retain) NSString * roomTypeName;
@property (nonatomic, retain) NSString * smokeContent;
@property (nonatomic, retain) NSString * viewIntro;
@property (nonatomic, retain) DBFloor *belongFloor;
@property (nonatomic, retain) DBRoomLocation *hasRoomLocation;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBRoom (CoreDataGeneratedAccessors)

- (void)addPicListObject:(DBRoomPic *)value;
- (void)removePicListObject:(DBRoomPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
