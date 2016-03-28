//
//  DBMessageList.h
//  mgmanager
//
//  Created by Sun Peng on 15/8/4.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBMessageList : NSManagedObject

@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * msgCntUrl;
@property (nonatomic, retain) NSString * msgCode;
@property (nonatomic, retain) NSString * msgTime;
@property (nonatomic, retain) NSString * msgTitle;
@property (nonatomic, retain) NSString * pageNo;
@property (nonatomic, retain) NSString * logoUrl;

@end
