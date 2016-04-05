//
//  DBMessage+CoreDataProperties.h
//  mgservice
//
//  Created by 罗禹 on 16/4/5.
//  Copyright © 2016年 Suzic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *answerTime;
@property (nullable, nonatomic, retain) NSString *askTime;
@property (nullable, nonatomic, retain) NSString *chatCode;
@property (nullable, nonatomic, retain) NSString *question;
@property (nullable, nonatomic, retain) DBTaskList *belongCallList;

@end

NS_ASSUME_NONNULL_END
