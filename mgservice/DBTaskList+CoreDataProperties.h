//
//  DBTaskList+CoreDataProperties.h
//  mgservice
//
//  Created by 罗禹 on 16/4/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBTaskList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBTaskList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *accepTime;
@property (nullable, nonatomic, retain) NSString *cancelTime;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *drOrderNo;
@property (nullable, nonatomic, retain) NSString *finishTime;
@property (nullable, nonatomic, retain) NSString *patternInfo;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *priority;
@property (nullable, nonatomic, retain) NSString *rush;
@property (nullable, nonatomic, retain) NSString *taskCode;
@property (nullable, nonatomic, retain) NSString *taskStatus;
@property (nullable, nonatomic, retain) NSString *timeLimit;
@property (nullable, nonatomic, retain) NSString *userDeviceToken;
@property (nullable, nonatomic, retain) NSString *userDiviceld;
@property (nullable, nonatomic, retain) NSString *userLocation;
@property (nullable, nonatomic, retain) NSString *userLocationArea;
@property (nullable, nonatomic, retain) NSString *userLocationDesc;
@property (nullable, nonatomic, retain) NSString *userMessageInfo;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *waiterStatus;
@property (nullable, nonatomic, retain) NSString *createTime;
@property (nullable, nonatomic, retain) NSString *messageInfo;
@property (nullable, nonatomic, retain) DBWaiterInfor *belongWaiter;
@property (nullable, nonatomic, retain) DBMessage *hasMessage;

@end

NS_ASSUME_NONNULL_END
