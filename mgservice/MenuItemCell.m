//
//  MenuItemCell.m
//  mgservice
//
//  Created by 苏智 on 16/1/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)readyChanged:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(readyStatusChanged:)])
        [self.delegate readyStatusChanged:self];
}

@end
