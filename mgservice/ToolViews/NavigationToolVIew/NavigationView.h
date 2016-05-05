//
//  NavigationView.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/10/22.
//  Copyright © 2015年 palmaplus. All rights reserved.
//vfd

#import <UIKit/UIKit.h>



@interface NavigationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *navigationButton;


@property (weak, nonatomic) IBOutlet UILabel *currentaddressLabel;

@property (strong,nonatomic)NSMutableArray* dataArray;

-(void)viewReloadData;
@end
