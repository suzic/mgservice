//
//  DBStatisticalInfoList+CoreDataProperties.h
//  mgservice
//
//  Created by sjlh on 16/10/21.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBStatisticalInfoList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBStatisticalInfoList (CoreDataProperties)

+ (NSFetchRequest<DBStatisticalInfoList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *timeLimit;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *finishTime;
@property (nullable, nonatomic, copy) NSString *acceptTime;
@property (nullable, nonatomic, copy) NSString *messageInfo;
@property (nullable, nonatomic, copy) NSString *cancelTime;
@property (nullable, nonatomic, copy) NSString *taskCode;
@property (nullable, nonatomic, copy) NSString *taskStatus;
@property (nullable, nonatomic, copy) NSString *category;

@end

NS_ASSUME_NONNULL_END
