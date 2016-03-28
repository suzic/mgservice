//
//  DBCalendarItem.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBCalendarItem : NSManagedObject

@property (nonatomic, retain) NSString * holidayName;
@property (nonatomic, retain) NSString * idxTimeVal;
@property (nonatomic, retain) NSString * idxVal;
@property (nonatomic, retain) NSNumber * isReturn;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSNumber * isShow;

@end
