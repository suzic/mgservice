//
//  DBTaskStatisticalList+CoreDataProperties.m
//  mgservice
//
//  Created by sjlh on 2016/11/9.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBTaskStatisticalList+CoreDataProperties.h"

@implementation DBTaskStatisticalList (CoreDataProperties)

+ (NSFetchRequest<DBTaskStatisticalList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBTaskStatisticalList"];
}

@dynamic score;
@dynamic status;
@dynamic taskCode;
@dynamic locationDesc;
@dynamic locationArea;
@dynamic timeLimit;
@dynamic category;
@dynamic drOrderNo;
@dynamic messageInfo;
@dynamic acceptTime;
@dynamic finishTime;
@dynamic cancelTime;
@dynamic createTime;
@dynamic location;
@dynamic selectedState;

@end
