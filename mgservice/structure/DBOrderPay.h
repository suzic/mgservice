//
//  DBOrderPay.h
//  mgmanager
//
//  Created by 刘超 on 15/7/13.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBaseOrder;

@interface DBOrderPay : NSManagedObject

@property (nonatomic, retain) NSString * backDays;
@property (nonatomic, retain) NSString * backEndDate;
@property (nonatomic, retain) NSString * backIdx;
@property (nonatomic, retain) NSString * backMoney;
@property (nonatomic, retain) NSString * backOrderNumber;
@property (nonatomic, retain) NSString * backStartDate;
@property (nonatomic, retain) NSString * cardId;
@property (nonatomic, retain) NSString * cardKind;
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSString * cardNo;
@property (nonatomic, retain) NSString * cardPwd;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * confirmNo;
@property (nonatomic, retain) NSString * idx;
@property (nonatomic, retain) NSString * money;
@property (nonatomic, retain) NSString * userCard;
@property (nonatomic, retain) NSString * cardIdx;
@property (nonatomic, retain) DBBaseOrder *belongBaseOrder;

@end
