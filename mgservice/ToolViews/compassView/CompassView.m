//
//  CompassView.m
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/15.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "CompassView.h"


@interface CompassView()
@end


@implementation CompassView

-(instancetype)init{
//    CGSize size = [UIScreen mainScreen].bounds.size;
    CGSize viewSize = CGSizeMake(40, 40);
    if (self = [super init]) {
        self.frame = CGRectMake(10 , 10+ 64, viewSize.width, viewSize.height);
        self.image = [UIImage imageNamed:@"north_arrow@2x"];
    }
    return self;
}

-(void)compassViewRotateWithAngleFromNorth:(CGFloat )angleFromNorth{
    self.transform = CGAffineTransformIdentity;
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1 * M_PI / 180 * angleFromNorth);
    self.transform = transform;
}

@end
