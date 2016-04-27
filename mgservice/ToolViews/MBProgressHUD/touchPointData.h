//
//  touchPointData.h
//  bluetoothDemo
//
//  Created by peng on 15/9/20.
//  Copyright © 2015年 palmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface touchPointData : NSObject

@property (nonatomic, assign)NSUInteger floorID;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, copy)NSString* floorName;
@end
