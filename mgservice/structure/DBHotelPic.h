//
//  DBHotelPic.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotel;

@interface DBHotelPic : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) DBHotel *belongHotel;

@end
