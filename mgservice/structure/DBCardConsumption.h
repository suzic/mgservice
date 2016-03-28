//
//  DBCardConsumption.h
//  mgmanager
//
//  Created by Sun Peng on 15/8/26.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBUserCard;

@interface DBCardConsumption : NSManagedObject

@property (nonatomic, retain) NSString * costDate;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * pageNo;
@property (nonatomic, retain) NSString * recordType;
@property (nonatomic, retain) NSString * recordTypeName;
@property (nonatomic, retain) NSString * unitCost;
@property (nonatomic, retain) NSString * unitName;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) DBUserCard *belongUserCard;

@end
