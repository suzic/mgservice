//
//  DBBaseOrder.h
//  mgmanager
//
//  Created by 刘超 on 15/7/9.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBOrder, DBOrderPay, DBRoomOrder, DBRoomTypeOrder, DBUserLogin;

@interface DBBaseOrder : NSManagedObject

@property (nonatomic, retain) NSString * buildingCode;
@property (nonatomic, retain) NSString * buildingName;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * errMsg;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSString * isSelected;
@property (nonatomic, retain) NSDate * orderDate;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * orderNo;
@property (nonatomic, retain) NSString * orderType;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roomTypeCode;
@property (nonatomic, retain) NSString * roomTypeName;
@property (nonatomic, retain) NSString * seq;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * totalDays;
@property (nonatomic, retain) NSString * confirmNo;
@property (nonatomic, retain) DBOrder *belongOrder;
@property (nonatomic, retain) DBUserLogin *belongUser;
@property (nonatomic, retain) DBOrderPay *hasOrderPay;
@property (nonatomic, retain) DBRoomOrder *roomOrderDetail;
@property (nonatomic, retain) DBRoomTypeOrder *roomTypeOrderDetail;

@end
