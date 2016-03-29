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

@end
