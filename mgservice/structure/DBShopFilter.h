//
//  DBShopFilter.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBShopFilter : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * nameValue;

@end