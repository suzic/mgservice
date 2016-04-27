//
//  PointView.m
//  Demo
//
//  Created by peng799505946 on 15/6/18.
//  Copyright (c) 2015年 palmap+. All rights reserved.
//

#import "PointView.h"
#include <CoreGraphics/CGBase.h>
#include <CoreFoundation/CFDictionary.h>


@implementation PointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithPoint:(CGPoint) locationPoint AndMinor: (NSString*)Minor{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 30, 10);
        UIView* backView = [[UIView alloc]init];
        
        
        backView.frame = CGRectMake(0, 0, 5, 5);
        backView.layer.masksToBounds=YES;
        backView.layer.cornerRadius=2.5;
        backView.backgroundColor = [UIColor redColor];
        [self addSubview:backView];
        backView.center = self.center;
       
        self.center = locationPoint;
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, -9, 30, 10)];
        label.font = [UIFont systemFontOfSize:9];
      
        label.textAlignment =  NSTextAlignmentCenter;
        [self addSubview: label];
        label.text = Minor;
       
    }
    return self;
}

@end
