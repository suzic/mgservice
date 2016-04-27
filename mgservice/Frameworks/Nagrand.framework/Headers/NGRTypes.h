//
//  NGRCore.h
//  Nagrand
//
//  Created by Yongxian Wu on 11/12/14.
//  Copyright (c) 2014 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nagrand/NGRBase.h>

typedef uint64_t NGRID;
typedef NSInteger NGRInteger;
typedef double NGRFloat;

//typedef struct
//{
//    NGRFloat x;
//    NGRFloat y;
//} NGRPoint;

///经纬度
struct NGRCoordinate {
    NGRFloat longitude;
    NGRFloat latitude;
};
typedef struct NGRCoordinate NGRCoordinate;



struct NGRPoint3D{
    NGRFloat x;
    NGRFloat y;
    NGRFloat z;
};
typedef struct NGRPoint3D NGRPoint3D;


//inline method
NGR_INLINE NGRCoordinate
NGRCoordinateMake(NGRFloat longitude, NGRFloat latitude) {
    NGRCoordinate coordinate; coordinate.longitude = longitude; coordinate.latitude = latitude; return coordinate;
}

NGR_INLINE NGRPoint3D
NGRPoint3DMake(NGRFloat x, NGRFloat y, NGRFloat z) {
    NGRPoint3D point3D; point3D.x = x; point3D.y = y; point3D.z = z; return point3D;
}
