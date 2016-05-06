//
//  TaskCell.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell ()

@end

@implementation TaskCell

- (void)awakeFromNib
{
}

- (void)setCellSelected:(BOOL)cellSelected
{
    if (_cellSelected != cellSelected)
        _cellSelected = cellSelected;
    self.taskName.font = [UIFont systemFontOfSize:cellSelected ? 24.0f : 16.0f];
    self.taskName.textColor = cellSelected ? [UIColor blackColor] : [UIColor grayColor];
    self.taskContent.hidden = !cellSelected;
    self.taskAddress.hidden = !cellSelected;
    self.taskTime.hidden = !cellSelected;

    self.allHeightSet.constant = (((kScreenHeight - 64- 60 - 160) / 2) - 50) / 4;
//    self.backgroudView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.backgroudView.layer.borderWidth = cellSelected ? 0.5f : 0.0f;
    self.backgroudView.backgroundColor = cellSelected ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
}

@end
