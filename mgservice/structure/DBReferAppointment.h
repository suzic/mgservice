//
//  DBReferAppointment.h
//  mgmanager
//
//  Created by Sun Peng on 15/8/3.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBReferAppointment : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * idNo;
@property (nonatomic, retain) NSString * reserveTime;
@property (nonatomic, retain) NSString * confirmNo;
@property (nonatomic, retain) NSString * referralCode;

@end
