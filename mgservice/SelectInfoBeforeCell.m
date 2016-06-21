//
//  SelectInfoBeforeCell.m
//  mgservice
//
//  Created by sjlh on 16/6/17.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "SelectInfoBeforeCell.h"

@implementation SelectInfoBeforeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.layer.borderWidth = 2.0f;
    self.textField.layer.cornerRadius = 8.0f;
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
