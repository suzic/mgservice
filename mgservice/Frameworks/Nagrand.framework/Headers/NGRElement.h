//
//  NGRElement.h
//  Nagrand
//
//  Created by Sanae on 16/3/14.
//  Copyright © 2016年 Palmap+ Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGRElementType) {
    NGRElementNil,
    NGRElementInt32,
    NGRElementUInt32,
    NGRElementInt64,
    NGRElementUInt64,
    NGRElementFloat,
    NGRElementDouble,
    NGRElementBool,
    NGRElementString,
    NGRElementArray,
    NGRElementDictionary,
};

@interface NGRElement : NSObject

@property (nonatomic, assign)NGRElementType type;
@property (nonatomic, assign)NSUInteger size;

@property (nonatomic)id value;

@end



@interface NGRArrayElement : NGRElement

- (NGRElement *)elementAtIndex:(NSUInteger)index;

@end
