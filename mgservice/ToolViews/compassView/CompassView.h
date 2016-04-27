//
//  CompassView.h
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/15.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CompassView : UIImageView
//旋转指南针  angleFromNorth 与正北方向的夹角度数
-(void)compassViewRotateWithAngleFromNorth:(CGFloat )angleFromNorth;

@end
