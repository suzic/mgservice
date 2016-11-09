//
//  DBTaskStatisticalList+CoreDataProperties.h
//  mgservice
//
//  Created by sjlh on 2016/11/9.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBTaskStatisticalList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBTaskStatisticalList (CoreDataProperties)

+ (NSFetchRequest<DBTaskStatisticalList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *score;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *taskCode;
@property (nullable, nonatomic, copy) NSString *locationDesc;
@property (nullable, nonatomic, copy) NSString *locationArea;
@property (nullable, nonatomic, copy) NSString *timeLimit;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *drOrderNo;
@property (nullable, nonatomic, copy) NSString *messageInfo;
@property (nullable, nonatomic, copy) NSString *acceptTime;
@property (nullable, nonatomic, copy) NSString *finishTime;
@property (nullable, nonatomic, copy) NSString *cancelTime;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *selectedState;

@end

NS_ASSUME_NONNULL_END
