//
//  StarView.h
//  Project-WXMovie26
//
//  Created by wangyadong on 15-8-20.
//  Copyright (c) 2014年 keyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StarView : UIView
{
    UIView *_yelloView;  //金色的星星
    UIView *_grayView;  //灰色的星星
    
//    IBOutlet UILabel *_starLabel;
}

@property (nonatomic, assign)CGFloat rating; //评分

@end
