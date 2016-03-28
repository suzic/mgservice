//
//  PlaySoundsView.h
//  FoodOrderDemo
//
//  Created by 刘超 on 15/9/9.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PalySoundsType)
{
    PALYMENUSOUNDS = 0,
    PALYMEGSOUNDS  = 1,
};
typedef NS_ENUM(NSInteger, SelectedType)
{
    CANCELTYPE  = 0,
    SURETYPE    = 1,
    CONFIRMTYPE = 2,
};

@protocol PalySoundsDelegate <NSObject>

- (void) palySoundsType:(PalySoundsType)palyType WithSelectedType:(SelectedType)selectedType;

@end

@interface PlaySoundsView : UIView

@property (nonatomic, weak) id<PalySoundsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

/**
 * @abstract 初始化提醒视图
 */
- (id) initWithTitle:(NSString *) title delegate:(id<PalySoundsDelegate>) palySoundsDelegate;

/**
 * @abstract 显示提醒视图
 */
- (void)showSoundView;
- (void)disMissSoundsView;
/**
 * @abstract 处理按钮的隐显状态
 */
- (void)showButtonHidden:(BOOL)show;

@end
