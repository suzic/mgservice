//
//  FloorRegionModel.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 16/4/12.
//  Copyright © 2016年 palmaplus. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyBlockType)(int);
@interface FloorRegionModel : NSObject

@property(nonatomic,strong)NSNumber* mapID;
@property(nonatomic,strong)NSNumber* floorid;
@property(nonatomic,copy)NSString* mapName;
@property(nonatomic,copy)NSString* floorName;
@property (copy) MyBlockType myBlock;

@end


