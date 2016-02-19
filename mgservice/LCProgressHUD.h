//
//  LCProgressHUD.h
//  mgmanager
//
//  Created by 刘超 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum WMProgressStyle
{
    defaultStyle,
    titleStyle
}WMProgressStyle;


@interface LCProgressHUD : UIView

/**
 * @abstract 初始化
 */

- (id)initWithFrame:(CGRect)frame andStyle:(WMProgressStyle)styleType andTitle:(NSString *)title;
/**
 * @abstract 开始网络加载
 */

- (void)stopWMProgress;
/**
 * @abstract 停止网络加载
 */

- (void)startWMProgress;


@end
