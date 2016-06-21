//
//  ScanningInfoCell.h
//  mgservice
//
//  Created by sjlh on 16/6/17.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomText;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@end
