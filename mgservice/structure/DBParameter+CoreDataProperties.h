//
//  DBParameter+CoreDataProperties.h
//  mgmanager
//
//  Created by 刘超 on 15/12/2.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBParameter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *diviceId;
@property (nullable, nonatomic, retain) NSString *deviceToken;
@property (nullable, nonatomic, retain) NSString *retOk;
@property (nullable, nonatomic, retain) NSString *blueKey;

@end

NS_ASSUME_NONNULL_END
