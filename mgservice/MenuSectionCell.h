//
//  MenuSectionCell.h
//  mgservice
//
//  Created by 苏智 on 16/1/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *readyInfo;
@property (weak, nonatomic) IBOutlet UILabel *locationDec;
@property (weak, nonatomic) IBOutlet UILabel *limitTime;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliverStartAndEndTime;//要求送达的起始时间和结束时间
@property (weak, nonatomic) IBOutlet UILabel *menuOrderMoney;//总金额
@end
