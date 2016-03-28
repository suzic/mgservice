//
//  DBUserLogin+CoreDataProperties.h
//  mgmanager
//
//  Created by 刘超 on 15/12/1.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBUserLogin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBUserLogin (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *account;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *idNo;
@property (nullable, nonatomic, retain) NSString *idType;
@property (nullable, nonatomic, retain) NSString *isLogIn;
@property (nullable, nonatomic, retain) NSString *isShowUnPay;
@property (nullable, nonatomic, retain) NSString *membername;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *msgs;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSString *openBalabce;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *realName;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) NSString *stste;
@property (nullable, nonatomic, retain) NSString *ticker;
@property (nullable, nonatomic, retain) NSSet<DBBaseOrder *> *hasBaseOrder;
@property (nullable, nonatomic, retain) NSSet<DBUserCard *> *hasCard;
@property (nullable, nonatomic, retain) NSSet<DBReserve *> *hasReserve;
@property (nullable, nonatomic, retain) NSSet<DBCheckIn *> *hasCheckIn;

@end

@interface DBUserLogin (CoreDataGeneratedAccessors)

- (void)addHasBaseOrderObject:(DBBaseOrder *)value;
- (void)removeHasBaseOrderObject:(DBBaseOrder *)value;
- (void)addHasBaseOrder:(NSSet<DBBaseOrder *> *)values;
- (void)removeHasBaseOrder:(NSSet<DBBaseOrder *> *)values;

- (void)addHasCardObject:(DBUserCard *)value;
- (void)removeHasCardObject:(DBUserCard *)value;
- (void)addHasCard:(NSSet<DBUserCard *> *)values;
- (void)removeHasCard:(NSSet<DBUserCard *> *)values;

- (void)addHasReserveObject:(DBReserve *)value;
- (void)removeHasReserveObject:(DBReserve *)value;
- (void)addHasReserve:(NSSet<DBReserve *> *)values;
- (void)removeHasReserve:(NSSet<DBReserve *> *)values;

- (void)addHasCheckInObject:(DBCheckIn *)value;
- (void)removeHasCheckInObject:(DBCheckIn *)value;
- (void)addHasCheckIn:(NSSet<DBCheckIn *> *)values;
- (void)removeHasCheckIn:(NSSet<DBCheckIn *> *)values;

@end

NS_ASSUME_NONNULL_END
