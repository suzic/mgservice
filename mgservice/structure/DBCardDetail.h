//
//  DBCardDetail.h
//  mgmanager
//
//  Created by Sun Peng on 15/8/25.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBUserCard;

@interface DBCardDetail : NSManagedObject

@property (nonatomic, retain) NSString * accountPoints;
@property (nonatomic, retain) NSString * cardNature;
@property (nonatomic, retain) NSString * cardNo;
@property (nonatomic, retain) NSString * cardState;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * casinoMoney;
@property (nonatomic, retain) NSString * contractRoomNo;
@property (nonatomic, retain) NSString * hongshulinMoney;
@property (nonatomic, retain) NSString * idx;
@property (nonatomic, retain) NSString * outerIdx;
@property (nonatomic, retain) NSString * tixianPoints;
@property (nonatomic, retain) NSString * yufenhongPoints;
@property (nonatomic, retain) DBUserCard *belongCard;

@end
