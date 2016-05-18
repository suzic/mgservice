//
//  MenuSectionCell.m
//  mgservice
//
//  Created by 苏智 on 16/1/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MenuSectionCell.h"

@implementation MenuSectionCell

- (void)awakeFromNib
{
    self.readyInfo.layer.cornerRadius = 4.0f;
    self.phoneNumber.userInteractionEnabled = YES;
    self.deleteLabel.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
