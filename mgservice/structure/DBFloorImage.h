//
//  DBFloorImage.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBFloor;

@interface DBFloorImage : NSManagedObject

@property (nonatomic, retain) NSString * fPic;
@property (nonatomic, retain) DBFloor *belongFloor;

@end
