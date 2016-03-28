//
//  CycleScrollView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CycleScrollView;

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape,        // 水平滚动
    CycleDirectionNo                //原地不动
}CycleDirection;

@protocol CycleScrollViewDelegate <NSObject>

@optional

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index;

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index;

@end

@interface CycleScrollView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIImageView *curImageView;
    
    int totalPage;
    int curPage;
    CGRect scrollFrame;
    
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
}

@property (nonatomic, weak) id<CycleScrollViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imagesArray;;
@property (nonatomic, assign) CycleDirection scrollDriection;

- (int)validPageValue:(NSInteger)value;
- (NSArray *)getDisplayImagesWithCurpage:(int)page;
- (void)refreshScrollView;

@end
