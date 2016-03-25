//
//  MenuItemCell.h
//  mgservice
//
//  Created by 苏智 on 16/1/29.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItemCell;

@protocol MenuItemCellDelegate<NSObject>

@optional

- (void)readyStatusChanged:(MenuItemCell *)cell;

@end

@interface MenuItemCell : UITableViewCell

@property (retain, nonatomic) NSMutableDictionary *menuData;

@property (strong, nonatomic) IBOutlet UILabel *menuName;
@property (strong, nonatomic) IBOutlet UILabel *menuPrice;
@property (strong, nonatomic) IBOutlet UISwitch *menuReady;

@property(nonatomic, assign) id<MenuItemCellDelegate> delegate;

@end


