//
//  AMHuaDongXuanZeView.h
//  lvmall
//
//  Created by Aimi on 14-9-3.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMHuaDongXuanZeView;
@protocol AMHuaDongXuanZeViewDelegate <NSObject>

-(void)huaDongXuanZeView:(AMHuaDongXuanZeView*)huaDongXuanZeView DidSelectedIndex:(NSUInteger)index;



@end

@interface AMHuaDongXuanZeView : UIScrollView<UIScrollViewDelegate>
//选择器中所包含的所有元素
@property(nonatomic,strong)NSArray* contentArray;


@property(nonatomic,weak)id<AMHuaDongXuanZeViewDelegate> huadongdelegate;

- (void)setNavigationIndex:(int)index withAnimated:(BOOL)animated;

- (void)nextStep;
- (void)upStep;
- (void)setStepWithIndex:(NSUInteger)index;


@end
