//
//  DBRoomType.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoomTypePackage, DBRoomTypePic;

@interface DBRoomType : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * availableRooms;
@property (nonatomic, retain) NSString * bargainFlg;
@property (nonatomic, retain) NSString * bedTypeContent;
@property (nonatomic, retain) NSString * breakfastContent;
@property (nonatomic, retain) NSString * buildingName;
@property (nonatomic, retain) NSString * canExtraBed;
@property (nonatomic, retain) NSString * dailyPrice;
@property (nonatomic, retain) NSString * guests;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * networkContent;
@property (nonatomic, retain) NSString * prepayFlg;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * rateCode;
@property (nonatomic, retain) NSString * rateName;
@property (nonatomic, retain) NSString * roomTypeCode;
@property (nonatomic, retain) NSString * roomTypeDesc;
@property (nonatomic, retain) NSString * roomTypeName;
@property (nonatomic, retain) NSString * viewIntro;
@property (nonatomic, retain) NSSet *hasPackage;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBRoomType (CoreDataGeneratedAccessors)

- (void)addHasPackageObject:(DBRoomTypePackage *)value;
- (void)removeHasPackageObject:(DBRoomTypePackage *)value;
- (void)addHasPackage:(NSSet *)values;
- (void)removeHasPackage:(NSSet *)values;

- (void)addPicListObject:(DBRoomTypePic *)value;
- (void)removePicListObject:(DBRoomTypePic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
