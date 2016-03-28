//
//  DBShop.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotel, DBShopPic;

@interface DBShop : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * businessIntro;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * houseNumber;
@property (nonatomic, retain) NSString * latestUpdate;
@property (nonatomic, retain) NSString * localIntro;
@property (nonatomic, retain) NSString * mapSign;
@property (nonatomic, retain) NSString * openEndTime;
@property (nonatomic, retain) NSString * openStartTime;
@property (nonatomic, retain) NSNumber * pageNo;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * preferenceIntro;
@property (nonatomic, retain) NSString * spCode;
@property (nonatomic, retain) NSString * spName;
@property (nonatomic, retain) NSString * spTypeName;
@property (nonatomic, retain) NSString * telephones;
@property (nonatomic, retain) DBHotel *hasHotelCode;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBShop (CoreDataGeneratedAccessors)

- (void)addPicListObject:(DBShopPic *)value;
- (void)removePicListObject:(DBShopPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
