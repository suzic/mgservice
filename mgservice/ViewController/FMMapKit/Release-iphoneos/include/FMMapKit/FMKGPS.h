//
//  FMKGPS.h
//  FMMapKit
//
//  Created by fengmap on 16/6/13.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"
#import <CoreLocation/CoreLocation.h>

@interface FMKGPS : NSObject

- (FMKMapPoint)transformBD09ToMapPointWithCLLocation:(CLLocationCoordinate2D)location;

@end
