//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"

@implementation CycleScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        curImages = [[NSMutableArray alloc] init];
        scrollView = [[UIScrollView alloc] init];;
        scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
    }
    return self;
}

- (void)refreshScrollView
{
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0)
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if (curImages == nil||curImages.count <= 0)
            imageView.image = [UIImage imageNamed:@"PlacehOlderImage"];
        else
            [imageView sd_setImageWithURL:curImages[i] placeholderImage:[UIImage imageNamed:@"PlacehOlderImage"]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
        
        // 水平滚动
        if (self.scrollDriection == CycleDirectionLandscape)
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        // 垂直滚动
        if (self.scrollDriection == CycleDirectionPortait)
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        
        [scrollView addSubview:imageView];
    }
    if (self.scrollDriection == CycleDirectionLandscape)
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    else if (self.scrollDriection == CycleDirectionPortait)
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    scrollFrame = self.frame;
    if (scrollView != nil)
    {
        [scrollView setFrame:scrollFrame];
        [self setScrollDriection:self.scrollDriection];
    }
}

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    totalPage = (int)imagesArray.count;
    curPage = 1;
}

- (void)setScrollDriection:(CycleDirection)scrollDriection
{
    _scrollDriection = scrollDriection;
    // 在水平方向滚动
    if (_scrollDriection == CycleDirectionLandscape)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    // 在垂直方向滚动
    if (_scrollDriection == CycleDirectionPortait)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 3);
    //原地不动
    if (_scrollDriection == CycleDirectionNo)
       scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page
{
    if([curImages count] != 0) [curImages removeAllObjects];
    if (_imagesArray.count <= 0)
    {
        return curImages;
    }
    int pre = [self validPageValue:curPage - 1];
    int last = [self validPageValue:curPage + 1];
    [curImages addObject:[_imagesArray objectAtIndex:pre - 1]];
    [curImages addObject:[_imagesArray objectAtIndex:curPage - 1]];
    [curImages addObject:[_imagesArray objectAtIndex:last - 1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value
{
    if (value == 0) value = totalPage;  // value＝1为第一张，value = 0为前面一张
    if (value == totalPage + 1) value = 1;
    
    return (int)value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    // NSLog(@"did  x=%d  y=%d", x, y);
    // 水平滚动
    if(self.scrollDriection == CycleDirectionLandscape)
    {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width))
        {
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0)
        {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(self.scrollDriection == CycleDirectionPortait)
    {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height))
        {
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0)
        {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)])
        [_delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    // int x = aScrollView.contentOffset.x;
    // int y = aScrollView.contentOffset.y;
    
    // NSLog(@"--end  x=%d  y=%d", x, y);

    if (self.scrollDriection == CycleDirectionLandscape)
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    if (self.scrollDriection == CycleDirectionPortait)
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [_delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

@end
