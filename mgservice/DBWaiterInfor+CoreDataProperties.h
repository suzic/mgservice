//
//  DBWaiterInfor+CoreDataProperties.h
//  mgservice
//
//  Created by Sun Peng on 16/2/23.
//  Copyright © 2016年 Suzic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBWaiterInfor.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBWaiterInfor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *attendanceState;
@property (nullable, nonatomic, retain) NSString *birth;
@property (nullable, nonatomic, retain) NSString *currentArea;
@property (nullable, nonatomic, retain) NSString *currentLocation;
@property (nullable, nonatomic, retain) NSString *deviceId;
@property (nullable, nonatomic, retain) NSString *deviceToken;
@property (nullable, nonatomic, retain) NSString *waiterId;
@property (nullable, nonatomic, retain) NSString *dutyin;
@property (nullable, nonatomic, retain) NSString *dutyout;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *hotelCode;
@property (nullable, nonatomic, retain) NSString *idNo;
@property (nullable, nonatomic, retain) NSString *incharge;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nay;
@property (nullable, nonatomic, retain) NSString *workNum;
@property (nullable, nonatomic, retain) NSString *workStatus;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *dutyLevel;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSSet<DBTaskList *> *hasCallList;

@end

@interface DBWaiterInfor (CoreDataGeneratedAccessors)

- (void)addHasCallListObject:(DBTaskList *)value;
- (void)removeHasCallListObject:(DBTaskList *)value;
- (void)addHasCallList:(NSSet<DBTaskList *> *)values;
- (void)removeHasCallList:(NSSet<DBTaskList *> *)values;

@end

NS_ASSUME_NONNULL_END
