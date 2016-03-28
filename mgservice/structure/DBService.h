//
//  DBService.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotel, DBServiceItem, DBServicePic;

@interface DBService : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * houseNumber;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * latestUpdate;
@property (nonatomic, retain) NSString * mapSign;
@property (nonatomic, retain) NSString * openEndTime;
@property (nonatomic, retain) NSString * openStartTime;
@property (nonatomic, retain) NSString * pageNo;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * preferenceIntro;
@property (nonatomic, retain) NSString * svCode;
@property (nonatomic, retain) NSString * svName;
@property (nonatomic, retain) NSString * svTypeName;
@property (nonatomic, retain) NSString * telephones;
@property (nonatomic, retain) DBHotel *belonghotelCode;
@property (nonatomic, retain) NSSet *hasItem;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBService (CoreDataGeneratedAccessors)

- (void)addHasItemObject:(DBServiceItem *)value;
- (void)removeHasItemObject:(DBServiceItem *)value;
- (void)addHasItem:(NSSet *)values;
- (void)removeHasItem:(NSSet *)values;

- (void)addPicListObject:(DBServicePic *)value;
- (void)removePicListObject:(DBServicePic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
