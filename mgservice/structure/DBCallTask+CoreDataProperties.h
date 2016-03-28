//
//  DBCallTask+CoreDataProperties.h
//  mgmanager
//
//  Created by 刘超 on 16/3/15.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBCallTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCallTask (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cancelTime;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *deviceToken;
@property (nullable, nonatomic, retain) NSString *diviceId;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *locationArea;
@property (nullable, nonatomic, retain) NSString *locationDesc;
@property (nullable, nonatomic, retain) NSString *messageInfo;
@property (nullable, nonatomic, retain) NSString *patternInfo;
@property (nullable, nonatomic, retain) NSString *priority;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSString *sendTime;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *taskCode;
@property (nullable, nonatomic, retain) NSString *timelimit;
@property (nullable, nonatomic, retain) NSString *workAcceptTime;
@property (nullable, nonatomic, retain) NSString *workDeviceId;
@property (nullable, nonatomic, retain) NSString *workDeviceToken;
@property (nullable, nonatomic, retain) NSString *workFinishTime;
@property (nullable, nonatomic, retain) NSString *workLocation;
@property (nullable, nonatomic, retain) NSString *workNum;
@property (nullable, nonatomic, retain) NSString *orderTime;
@property (nullable, nonatomic, retain) DBCheckIn *belongCheckIn;
@property (nullable, nonatomic, retain) NSSet<DBTaskChat *> *hasChats;

@end

@interface DBCallTask (CoreDataGeneratedAccessors)

- (void)addHasChatsObject:(DBTaskChat *)value;
- (void)removeHasChatsObject:(DBTaskChat *)value;
- (void)addHasChats:(NSSet<DBTaskChat *> *)values;
- (void)removeHasChats:(NSSet<DBTaskChat *> *)values;

@end

NS_ASSUME_NONNULL_END
