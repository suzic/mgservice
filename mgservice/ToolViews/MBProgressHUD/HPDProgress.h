//
//  HPDProgress.h
//  HePanDai2_0
//
//  Created by HePanDai on 14-8-6.
//  Copyright (c) 2014年 HePanDai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void(^HideComplateBlock)();

@interface HPDProgress : NSObject
{
    
}
@property(nonatomic,strong)MBProgressHUD *progressHud;
+ (HPDProgress *)defaultProgressHUD;

// 显示带有加载指示的 hud
- (void)showHUDOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;
- (void)showHUDOnView:(UIView *)view message:(NSString *)message;

// 只显示文字
- (void)showCoustomOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)block;
- (void)showCoustomOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;
- (void)showCoustomOnView:(UIView *)view message:(NSString *)message;

// 带有加载指示的 hud 转为只显示文字
- (void)holdMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)complete;
- (void)holdMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;
- (void)holdMessage:(NSString *)message;

- (void)hide;
- (void)hideAfterDelay:(NSTimeInterval)delay;

- (void)hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)complete;

@end
