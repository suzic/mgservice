//
//  NavigationView.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/10/22.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "NavigationView.h"
#import "CollectionMessage.h"
#import "EnumAndDefine.h"
#define kWidth kScreenWidth-20


@interface NavigationView ()

@property(assign,nonatomic)float heightY;

@end
@implementation NavigationView

-(void)viewReloadData{
    UIScrollView* bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 54, kWidth, 80)];
    bgView.backgroundColor = rgba(242, 242, 242, 1);
    [self addSubview:bgView];
    self.heightY=0.0;
    
    for (int i = 0;i<self.dataArray.count;i++) {
        CollectionMessage* messageModel = self.dataArray[i];
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.heightY+10, 20, 20)];
        imageview.image = [UIImage imageNamed:@"ico_now"];
        [bgView addSubview:imageview];
        UILabel* startlabel = [self newLabel];
        [bgView addSubview:startlabel];
        startlabel.text = messageModel.floorName;
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _heightY,kWidth, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:line];
        
        if (i==0) {
            UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 80, 40)];
            label.text = @"起点";
            [bgView addSubview:label];
        }
        if (i==self.dataArray.count-1) {
            UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, _heightY-40, 80, 40)];
            label.text = @"终点";
            [bgView addSubview:label];
        }
    }
    
    [bgView setContentSize:CGSizeMake(kWidth, _heightY)];
}

-(UILabel*)newLabel{
   UILabel* startlabel =  [[UILabel alloc]initWithFrame:CGRectMake(40, self.heightY, kWidth-100, 40)];
    self.heightY = _heightY+40;
    startlabel.adjustsFontSizeToFitWidth = YES;
    [startlabel setTextColor:[UIColor darkGrayColor]];
    
    return startlabel;
}
@end
