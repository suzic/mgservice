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
@property (nullable, nonatomic, retain) NSString *targetTelephone;

@property (nullable, nonatomic, retain) NSString *menuOrderMoney;   //菜单顺序价格,如果不加服务费，用这个参数
@property (nullable, nonatomic, retain) NSString *orderMoney;       //菜单总金额（加了服务费）后的金额
@property (nullable, nonatomic, retain) NSString *serviceCharge;    //服务费 如：（35.10）
@property (nullable, nonatomic, retain) NSString *deliverStartTime; //要求送达起始时间，格式为：（2016-05-10 10:00:00）
@property (nullable, nonatomic, retain) NSString *deliverEndTime;   //要求送达的结束时间，格式为：（2016-05-10 10:30:00）

@end

NS_ASSUME_NONNULL_END
