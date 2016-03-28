//
//  DBTaskChat+CoreDataProperties.h
//  mgmanager
//
//  Created by 刘超 on 16/3/8.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBTaskChat.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBTaskChat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *answerDeviceToken;
@property (nullable, nonatomic, retain) NSString *answerDiviceId;
@property (nullable, nonatomic, retain) NSString *answerTime;
@property (nullable, nonatomic, retain) NSString *askTime;
@property (nullable, nonatomic, retain) NSString *chatId;
@property (nullable, nonatomic, retain) NSString *question;
@property (nullable, nonatomic, retain) NSNumber *questionRead;
@property (nullable, nonatomic, retain) NSString *questionTime;
@property (nullable, nonatomic, retain) NSString *sendDeviceToken;
@property (nullable, nonatomic, retain) NSString *sendDiviceId;
@property (nullable, nonatomic, retain) NSString *byUserOrWaiter;
@property (nullable, nonatomic, retain) DBCallTask *belongTask;

@end

NS_ASSUME_NONNULL_END
