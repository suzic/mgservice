//
//  NGRGeometry.h
//  Nagrand
//
//  Created by Sanae on 16/3/17.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NGRPoint;

typedef NS_ENUM(NSUInteger, NGRGeometryTypeId) {
    /// a point
    GEOS_POINT,
    /// a linestring
    GEOS_LINESTRING,
    /// a linear ring (linestring with 1st point == last point)
    GEOS_LINEARRING,
    /// a polygon
    GEOS_POLYGON,
    /// a collection of points
    GEOS_MULTIPOINT,
    /// a collection of linestrings
    GEOS_MULTILINESTRING,
    /// a collection of polygons
    GEOS_MULTIPOLYGON,
    /// a collection of heterogeneus geometries
    GEOS_GEOMETRYCOLLECTION

};

@interface NGRGeometry : NSObject

@property (nonatomic, assign)NSUInteger numPoints;
@property (nonatomic, assign)BOOL isSimple;
@property (nonatomic, copy)NSString *geometryType;
@property (nonatomic, assign)NGRGeometryTypeId geometryTypeId;
@property (nonatomic, assign)NSUInteger numGeometries;

@property (nonatomic, assign)BOOL isValid;
@property (nonatomic, assign)BOOL isEmpty;

@property (nonatomic, assign, readonly)NGRPoint *centroid;

@property (nonatomic, assign, readonly)NGRGeometry *envelope;


- (BOOL)equals:(NGRGeometry *)geometry;

@end
