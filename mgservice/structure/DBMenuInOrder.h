//
//  DBMenuInOrder.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBReserve;

@interface DBMenuInOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * drCode;
@property (nonatomic, retain) NSString * menuCode;
@property (nonatomic, retain) NSString * menuName;
@property (nonatomic, retain) NSString * restName;
@property (nonatomic, retain) NSNumber * sellPrice;
@property (nonatomic, retain) DBReserve *belongReserve;

@end
