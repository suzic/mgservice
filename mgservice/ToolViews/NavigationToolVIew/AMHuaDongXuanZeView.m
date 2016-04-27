//
//  AMHuaDongXuanZeView.m
//  lvmall
//
//  Created by Aimi on 14-9-3.
//  Copyright (c) 2014年 lianyou. All rights reserved.
///Users/peng/Documents/iosProject/sdk2.0zhengquandasha/sdk2.0zhengquandasha/ToolViews/AMHuaDongXuanZeView.m:10:9: 'NSArray+PMXPathPlanning.h' file not found

#import "AMHuaDongXuanZeView.h"

#import "NSArray+PMXPathPlanning.h"
@interface AMHuaDongXuanZeView ()
{
    int _contentIndex;
}

@end
@implementation AMHuaDongXuanZeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setContentArray:(NSArray *)contentArray{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.delegate = self;
    _contentArray = contentArray;
    self.clipsToBounds = YES;
    self.showsHorizontalScrollIndicator = NO;
    for (int i = 0 ;i<contentArray.count;i++) {
//        PMXPoint2D* p = (PMXPoint2D*)contentArray[i];  ios 地图2.0.1   由于公司公测平台统一为fir平台，所以下载链接需要更改一下：
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        UIImageView* iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"人"]];
        CGRect frame = iv.frame;
        frame.origin = CGPointMake(0,11);
        iv.frame = frame;
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, self.bounds.size.width -iv.bounds.size.width, iv.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
//        NSMutableString* str1 =[p.reminder mutableCopy];
        
//        label.text = str1;
        label.font = [UIFont systemFontOfSize:16];
        //加入视图
        [v addSubview:iv];
        [v addSubview:label];
        
        [self addSubview:v];
        
    }
    
    self.contentSize = CGSizeMake([contentArray count]* self.bounds.size.width, self.bounds.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / self.bounds.size.width + 0.5;
    
    if (index != _contentIndex) {
        _contentIndex = index;
        [self.huadongdelegate huaDongXuanZeView:self DidSelectedIndex:index];
    }
}

- (void)setNavigationIndex:(int)index withAnimated:(BOOL)animated
{
    if (_contentIndex != index) {
        _contentIndex = index;
        [self setContentOffset:CGPointMake(index * CGRectGetWidth(self.bounds), 0) animated:animated];
    }
}


- (void)nextStep
{
    if (_contentIndex > [_contentArray count] - 2) {
        return;
    }
    
    _contentIndex ++;
    [self setContentOffset:CGPointMake(_contentIndex * CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)upStep
{
    if (_contentIndex <= 0) {
        return;
    }
    
    _contentIndex --;
    [self setContentOffset:CGPointMake(_contentIndex * CGRectGetWidth(self.bounds), 0) animated:YES];
}

- (void)setStepWithIndex:(NSUInteger)index {
    _contentIndex = index;
    [self setContentOffset:CGPointMake(_contentIndex * CGRectGetWidth(self.bounds), 0) animated:YES];
}
@end
