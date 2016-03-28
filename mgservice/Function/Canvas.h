//
//  Canvas.h
//  mgmanager
//
//  Created by 刘超 on 15/5/21.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CanvasDelegate <NSObject>

- (void)selectRoomCode:(NSString *)roomCode;

@end

@interface Canvas : UIView
/**
 * @abstract 房型数据布局
 * @param frame 房型坐标
 * @param floor 房型数据
 */

@property (nonatomic, retain) DBBaseOrder *baseOrder;
@property (nonatomic,assign)id<CanvasDelegate>delegate;
-(id)initWithPoints :(CGRect)frame withFloorType:(DBFloor*)floor;
@end
