//
//  FMIndoorMapVC.h
//  mgservice
//
//  Created by chao liu on 16/11/26.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMIndoorMapVC : UIViewController

@property (nonatomic, copy) NSString *mapID;//地图ID
@property (nonatomic, copy) NSString * groupID;//要显示的楼层ID
@property (nonatomic, copy) NSString * mapName;

@property (nonatomic, assign) BOOL isNeedLocate;

- (instancetype)initWithMapID:(NSString *)mapID ;

/**
 *  开始WIFI定位
 */
- (void)startWifiLocation;

@end
