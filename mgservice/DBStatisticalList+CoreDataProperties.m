//
//  DBStatisticalList+CoreDataProperties.m
//  mgservice
//
//  Created by wangyadong on 16/10/19.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DBStatisticalList+CoreDataProperties.h"

@implementation DBStatisticalList (CoreDataProperties)

+ (NSFetchRequest<DBStatisticalList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBStatisticalList"];
}

@dynamic timeLimit;
@dynamic messageInfo;
@dynamic taskCode;
@dynamic confirmState;
@dynamic phone;
@dynamic locationArea;
@dynamic category;
@dynamic selectedState;
@dynamic score;
@end
