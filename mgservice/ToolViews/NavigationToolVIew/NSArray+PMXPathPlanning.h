//
//  NSArray+PMXPathPlanning.h
//  WanDaMall
//
//  Created by Choi on 14-7-25.
//  Copyright (c) 2014年 WanDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PMXPathPlanning)

/**
 *  array里面存的是PMXPathWithDifFloorData
 *
 *  @return PMXPathWithDifFloorData
 */
- (NSArray *)pathWithDifFloor;

@end

@interface PMXPathWithDifFloorData : NSObject
/*
 array里面存的是PMXPoint2D
 */
@property (nonatomic, strong)NSArray *paths;
@property (nonatomic, strong)NSNumber *floorID;//该路径所在的楼层

@end
