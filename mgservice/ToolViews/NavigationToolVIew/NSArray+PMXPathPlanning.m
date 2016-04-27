//
//  NSArray+PMXPathPlanning.m
//  WanDaMall
//
//  Created by Choi on 14-7-25.
//  Copyright (c) 2014年 WanDa. All rights reserved.
//

#import "NSArray+PMXPathPlanning.h"

@protocol PMXPathPlanningProtocol <NSObject>

@property (nonatomic, readonly) NSNumber *floorID;

@end

@implementation NSArray (PMXPathPlanning)

/*
 array里面存的PMXPathWithDifFloorData在里面是PMXPoint2D
 */
- (NSArray *)pathWithDifFloor
{
    NSMutableArray *array = [NSMutableArray array];
    
    __block NSNumber *floorID = nil;
    __block PMXPathWithDifFloorData *floordata = nil;
    __block NSMutableArray *paths;
    
    [self enumerateObjectsUsingBlock:^(id<PMXPathPlanningProtocol> obj, NSUInteger idx, BOOL *stop) {
        if (obj.floorID.intValue == floorID.intValue) {
            
            [paths addObject:obj];
        }else {
            floorID = obj.floorID;
            if (floordata) {
                floordata.paths = paths;
                [array addObject:floordata];
            }
            
            floordata           = [[PMXPathWithDifFloorData alloc] init];
            paths               = [NSMutableArray array];
            
            floordata.floorID   = obj.floorID;
            [paths addObject:obj];
        }
    }];
    if (floordata) {
        floordata.paths = paths;
        [array addObject:floordata];
    }
    
    
    return array;
}

@end

@implementation PMXPathWithDifFloorData
@end;