//
//  HeaderCell.h
//  mgservice
//
//  Created by wangyadong on 16/9/20.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
@interface HeaderCell : UITableViewCell
@property (strong,nonatomic)StarView *  starView;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;

@end
