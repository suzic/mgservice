//
//  DBStatisticalList+CoreDataProperties.h
//  mgservice
//
//  Created by wangyadong on 16/10/19.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBStatisticalList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBStatisticalList (CoreDataProperties)

+ (NSFetchRequest<DBStatisticalList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *timeLimit;  //要求完成时间
@property (nullable, nonatomic, copy) NSString *messageInfo;//任务内容
@property (nullable, nonatomic, copy) NSString *taskCode;   //任务编号
@property (nullable, nonatomic, copy) NSString *confirmState;//确认状态
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *locationArea;//具体位置描述
@property (nullable, nonatomic, copy) NSString *category;   //任务主题
@property (nullable, nonatomic, copy) NSString *selectedState;

@end

NS_ASSUME_NONNULL_END
