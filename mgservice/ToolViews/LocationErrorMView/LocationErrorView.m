//
//  LocationErrorView.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 16/4/24.
//  Copyright © 2016年 palmaplus. All rights reserved.
//

#import "LocationErrorView.h"

@implementation LocationErrorView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.label];
        [self.label setTextColor:[UIColor redColor]];
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(void)setAlertMessageStr:(NSString *)alertMessageStr{
    _alertMessageStr = alertMessageStr;
    self.label.text = alertMessageStr;
    
}
@end
