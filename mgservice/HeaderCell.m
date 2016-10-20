//
//  HeaderCell.m
//  mgservice
//
//  Created by wangyadong on 16/9/20.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _starView = [[StarView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 110, 10, 110, 20)];
//    _starView.rating = 3.0f;
    [self.contentView addSubview:_starView];
    [self.taskNameLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
