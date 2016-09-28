//
//  GradingView.h
//  mgservice
//
//  Created by sjlh on 16/9/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TaskType)
{
    TASK_FINISH,            //服务员点击了完成任务
    TASK_CANCEL,            //客人取消了任务
    TASK_TENMETRES,         //距客人10米
};
@interface GradingView : UIView

/**
 * @abstract         创建评分界面
 * @param taskType   任务是取消还是完成
 */
- (id)initWithTaskType:(NSString *)taskType contentText:(NSString *)contentText color:(UIColor *)color;

- (void)showGradingView:(BOOL)show;

@end
