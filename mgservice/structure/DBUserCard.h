//
//  DBUserCard.h
//  mgmanager
//
//  Created by Sun Peng on 15/8/26.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBCardConsumption, DBCardDetail, DBUserLogin;

@interface DBUserCard : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * cardBin;
@property (nonatomic, retain) NSString * cardKind;
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSString * cardNo;
@property (nonatomic, retain) NSString * cardPwd;
@property (nonatomic, retain) NSString * effectiveDate;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * idx;
@property (nonatomic, retain) NSString * idxVal;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * outerIdx;
@property (nonatomic, retain) NSString * subType;
@property (nonatomic, retain) NSString * subTypeName;
@property (nonatomic, retain) DBUserLogin *belongUser;
@property (nonatomic, retain) NSSet *hasCardConsumption;
@property (nonatomic, retain) DBCardDetail *hasCardDetail;
@end

@interface DBUserCard (CoreDataGeneratedAccessors)

- (void)addHasCardConsumptionObject:(DBCardConsumption *)value;
- (void)removeHasCardConsumptionObject:(DBCardConsumption *)value;
- (void)addHasCardConsumption:(NSSet *)values;
- (void)removeHasCardConsumption:(NSSet *)values;

@end
