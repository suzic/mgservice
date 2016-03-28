//
//  DBServiceItem.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBService, DBServiceItemPic;

@interface DBServiceItem : NSManagedObject

@property (nonatomic, retain) NSNumber * basicPrice;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * svItemCode;
@property (nonatomic, retain) NSString * svItemName;
@property (nonatomic, retain) DBService *belongService;
@property (nonatomic, retain) NSSet *picList;
@end

@interface DBServiceItem (CoreDataGeneratedAccessors)

- (void)addPicListObject:(DBServiceItemPic *)value;
- (void)removePicListObject:(DBServiceItemPic *)value;
- (void)addPicList:(NSSet *)values;
- (void)removePicList:(NSSet *)values;

@end
