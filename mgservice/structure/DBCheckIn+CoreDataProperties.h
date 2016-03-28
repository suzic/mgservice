//
//  DBCheckIn+CoreDataProperties.h
//  mgmanager
//
//  Created by Sun Peng on 15/12/2.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBCheckIn.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCheckIn (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bill_money;
@property (nullable, nonatomic, retain) NSString *chechin_date;
@property (nullable, nonatomic, retain) NSString *check_room;
@property (nullable, nonatomic, retain) NSString *checkout_date;
@property (nullable, nonatomic, retain) NSString *cid;
@property (nullable, nonatomic, retain) NSString *deviceToken;
@property (nullable, nonatomic, retain) NSString *diviceId;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *level;
@property (nullable, nonatomic, retain) NSString *person_id;
@property (nullable, nonatomic, retain) DBUserLogin *belongUser;
@property (nullable, nonatomic, retain) NSSet<DBCallTask *> *hasCallTask;

@end

@interface DBCheckIn (CoreDataGeneratedAccessors)

- (void)addHasCallTaskObject:(DBCallTask *)value;
- (void)removeHasCallTaskObject:(DBCallTask *)value;
- (void)addHasCallTask:(NSSet<DBCallTask *> *)values;
- (void)removeHasCallTask:(NSSet<DBCallTask *> *)values;

@end

NS_ASSUME_NONNULL_END
