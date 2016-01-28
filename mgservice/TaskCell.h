//
//  TaskCell.h
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (assign, nonatomic) BOOL cellSelected;

@property (strong, nonatomic) IBOutlet UIView *backgroudView;
@property (strong, nonatomic) IBOutlet UILabel *taskName;

@end
