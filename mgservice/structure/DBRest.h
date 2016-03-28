//
//  DBRest.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotel, DBMenu, DBRestPic;

@interface DBRest : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * cuiSineName;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * houseNumber;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * introPreference;
@property (nonatomic, retain) NSString * latestUpdate;
@property (nonatomic, retain) NSString * mapSign;
@property (nonatomic, retain) NSString * payDescribe;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * restCode;
@property (nonatomic, retain) NSString * restName;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * telePhone;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) DBHotel *belongHotel;
@property (nonatomic, retain) NSSet *hasSpecialMenus;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBRest (CoreDataGeneratedAccessors)

- (void)addHasSpecialMenusObject:(DBMenu *)value;
- (void)removeHasSpecialMenusObject:(DBMenu *)value;
- (void)addHasSpecialMenus:(NSSet *)values;
- (void)removeHasSpecialMenus:(NSSet *)values;

- (void)addPicListObject:(DBRestPic *)value;
- (void)removePicListObject:(DBRestPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
