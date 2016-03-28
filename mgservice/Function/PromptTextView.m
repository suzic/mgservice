//
//  PromptTextView.m
//  mgmanager
//
//  Created by 刘超 on 15/11/25.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "PromptTextView.h"

@implementation PromptTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createPromptView];
    }
    return self;
 
}

// 创建提示视图
- (void)createPromptView
{
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               (IsIphone4 ? 0 : 0),
                                                               self.frame.size.width - (IsIphone4 ? 10 : 10),
                                                               IsIphone4 ? 60 : 70)];
    self.backgroundColor = [UIColor colorWithRed:44/255.0 green:113/255.0 blue:162/255.0 alpha:.7];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self.textLabel setNumberOfLines:0];
    self.textLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
