//
//  DBRoomTypePic.h
//  mgmanager
//
//  Created by 刘超 on 15/7/1.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBRoomType;

@interface DBRoomTypePic : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isLayout;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) NSString * smallPicUrl;
@property (nonatomic, retain) DBRoomType *belongRoomType;

@end