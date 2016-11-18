//
//  MenuDetailsSectionCell.h
//  mgservice
//
//  Created by sjlh on 2016/11/17.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuDetailsSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationDec;
@property (weak, nonatomic) IBOutlet UILabel *limitTime;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *menuOrderMoney;
@property (weak, nonatomic) IBOutlet UILabel *deliverStartAndEndTime;

@end
