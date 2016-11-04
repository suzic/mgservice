//
//  FMZoneManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMManager.h"

@class FMZone;

@interface FMZoneManager : FMManager

- (void)showZoneOnMap:(FMZone *)zone;

- (void)hiddenZoneOnMap:(FMZone *)zone;

@end
