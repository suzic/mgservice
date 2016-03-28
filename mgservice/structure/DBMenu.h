//
//  DBMenu.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBMenuPic, DBRest;

@interface DBMenu : NSManagedObject

@property (nonatomic, retain) NSNumber * basicPrice;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * latestUpdate;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * menuCode;
@property (nonatomic, retain) NSString * menuName;
@property (nonatomic, retain) NSNumber * sales;
@property (nonatomic, retain) NSNumber * sellPrice;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) NSNumber * taste;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) DBRest *belongRest;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBMenu (CoreDataGeneratedAccessors)

- (void)addPicListObject:(DBMenuPic *)value;
- (void)removePicListObject:(DBMenuPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
