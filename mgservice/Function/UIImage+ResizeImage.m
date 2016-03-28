//
//  UIImage+ResizeImage.m
//  ZhangShangJiuZhen
//
//  Created by Cat on 14/12/4.
//  Copyright (c) 2014年 LiuChao. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
}

@end
