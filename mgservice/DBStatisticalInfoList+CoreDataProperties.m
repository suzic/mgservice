//
//  DBStatisticalInfoList+CoreDataProperties.m
//  mgservice
//
//  Created by sjlh on 16/10/21.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBStatisticalInfoList+CoreDataProperties.h"

@implementation DBStatisticalInfoList (CoreDataProperties)

+ (NSFetchRequest<DBStatisticalInfoList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBStatisticalInfoList"];
}

@dynamic timeLimit;
@dynamic createTime;
@dynamic finishTime;
@dynamic acceptTime;
@dynamic messageInfo;
@dynamic cancelTime;
@dynamic taskCode;
@dynamic taskStatus;
@dynamic category;
@end
