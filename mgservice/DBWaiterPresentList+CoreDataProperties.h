//
//  DBWaiterPresentList+CoreDataProperties.h
//  mgservice
//
//  Created by 罗禹 on 16/3/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBWaiterPresentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBWaiterPresentList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *orderNo;
@property (nullable, nonatomic, retain) NSString *sellPrice;
@property (nullable, nonatomic, retain) NSString *count;
@property (nullable, nonatomic, retain) NSString *menuName;
@property (nullable, nonatomic, retain) NSString *drName;
@property (nullable, nonatomic, retain) NSString *ready;
@end

NS_ASSUME_NONNULL_END
