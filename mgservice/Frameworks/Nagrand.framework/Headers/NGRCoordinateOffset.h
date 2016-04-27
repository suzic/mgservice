//
//  NGRCoordinateOffset.h
//  Nagrand
//
//  Created by Sanae on 15/4/1.
//  Copyright (c) 2015年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class NGRFeatureCollection;

/*! 
 * @brief 用来描述每个层的偏移量
 * @discussion 以frame层为基准，所有层的偏移量都是相对于frame层，这个偏移量相当于空间中的z坐标
 */
@interface NGRCoordinateOffset : NSObject

/*!
 * @brief 偏移量
 */
@property (nonatomic)CGFloat heightOffset;

/*!
 * @brief 基于一个featureCollection构造一个偏移量
 * @param featurecollection - 一个feature的合集
 * @return 实例
 */
- (instancetype)initWithFeatureCollection:(NGRFeatureCollection *)featureCollection;

@end
