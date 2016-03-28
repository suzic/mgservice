//
//  Canvas.m
//  mgmanager
//
//  Created by 刘超 on 15/5/21.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "Canvas.h"
#import "UIView+ZXQuartz.h"
@implementation Canvas
{
    NSMutableArray* Points;//所有房型的坐标数据
    DBFloor* cur_floor;//户型图数据
    NSMutableArray* paths;

}
//初始化视图
-(id)initWithPoints :(CGRect)frame withFloorType:(DBFloor*)floor{
    self = [super initWithFrame:frame];
    if (self) {
        paths = [[NSMutableArray alloc]init];
        cur_floor = floor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 绘制色块标示

-(void)drawRect:(CGRect)rect{
    UIColor *blue = [UIColor colorWithRed:0.0f/255.f
                                    green:0.0f/255.f
                                     blue:0.0f/255.f
                                    alpha:100/255.0f];
    UIColor *green = [UIColor colorWithRed:41.f/255.f
                                     green:199.f/255.f
                                      blue:165.f/255.f
                                     alpha:100/255.0f];
    UIColor *red = [UIColor colorWithRed:255.f/255.f
                                   green:0/255.f
                                    blue:0/255.f
                                   alpha:100/255.0f];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (DBRoom *room in cur_floor.hasRooms) {
        NSString* roomCode = room.hasRoomLocation.roomCode;
         DBRoomLocation *roomLocation = room.hasRoomLocation;
        Points = roomLocation.points;
        if (Points)
        {
            if ([roomLocation.state isEqualToString:@"0"])
            {
                if ([roomLocation.state isEqualToString:@"1"])
                    [red setFill];
                else
                {
                   BOOL isExist = [[DataManager defaultInstance] findOrderListByRoomInfor:room withBaseOrder:self.baseOrder];
                    if (isExist == YES)
                       [red setFill];
                    else
                       [green setFill];
                }
            }else{
                [blue setFill];
            }
    
            NSValue* pv1 = [Points objectAtIndex:0];
            CGPoint cp1 = [pv1 CGPointValue];
            UIBezierPath*  aPath = [UIBezierPath bezierPath];
            [aPath moveToPoint:cp1];
            for (int j=0; j<Points.count; j++) {
                NSValue* pv = [Points objectAtIndex:j];
                CGPoint cp = [pv CGPointValue];
                [aPath addLineToPoint:cp];
            }
            [aPath closePath];
            [paths addObject:aPath];
            [self drawPolygon:Points];
            CGContextSetRGBFillColor(context,255.0,255.0,255.0,1.0);
            for (int a=0; a<roomCode.length; a++) {
                char cd = [roomCode characterAtIndex:a];
                NSString* code=[NSString stringWithFormat:@"%c", cd];
                CGPoint point = CGPointMake([roomLocation.left floatValue], [roomLocation.top floatValue]-40+a*15);
                [code drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            }
        }
    }
}

#pragma mark - 可点击色块事件

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    @try {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        int index=-1;
        for (int i=0; i<paths.count; i++) {
            UIBezierPath*  aPath = [paths objectAtIndex:i];
            //        NSLog(@"xxx:%f",aPath.currentPoint.x);
            if([aPath containsPoint:point]){
                //            NSLog(@"############");
                index = i;
                break;
            }
        }

        NSMutableArray *array = [NSMutableArray array];
        for (DBRoom *room in cur_floor.hasRooms)
        {
            [array addObject:room];
        }
        
        DBRoom *room = [array objectAtIndex:index];
        DBRoomLocation *roomLocation = room.hasRoomLocation;
        if (![roomLocation.state isEqualToString:@"0"]) {
            return;
        }
        
        BOOL isExist = [[DataManager defaultInstance] findOrderListByRoomInfor:room withBaseOrder:self.baseOrder];
        
        if (isExist == YES)
            return;
        else
            [self.delegate selectRoomCode:roomLocation.roomCode];
    }
    @catch (NSException *exception) {
        NSLog(@"就是这里报错%@",exception);
    }
    @finally {
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
