//
//  MenuDetailsItemCell.h
//  mgservice
//
//  Created by sjlh on 2016/11/17.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuDetailsItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuName;
@property (weak, nonatomic) IBOutlet UILabel *menuPrice;
@property (nonatomic,strong) DBWaiterPresentList * oneMenuName;

@end
