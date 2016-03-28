//
//  DBHotelDetailPic.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBHotelDetail;

@interface DBHotelDetailPic : NSManagedObject

@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) DBHotelDetail *belongHotelDetail;

@end
