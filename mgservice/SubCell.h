//
//  SubCell.h
//  mgservice
//
//  Created by wangyadong on 16/9/20.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *issuedTimeLabel;  //下单时间
@property (weak, nonatomic) IBOutlet UILabel *acceptTimeLabel;  //接受时间
@property (weak, nonatomic) IBOutlet UILabel *completeTimeLabel;//完成时间
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;    //呼叫类型
@property (weak, nonatomic) IBOutlet UIButton *taskTypeButton;  //进入任务页面按钮
@end
