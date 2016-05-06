//
//  SelectStartingAndEndPoint.h
//  bluetoothDemo
//
//  Created by peng on 饿15/9/18.
//  Copyright © 2015年 palmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nagrand/Nagrand.h>
#import "EnumAndDefine.h"

typedef NS_ENUM(NSInteger, pointType) {
    startPoint,
    endPoint,
};
typedef NS_ENUM(NSInteger,comeInDoorMapWay) {
    AutoGetPoiid = 0,
    MapPoiid,
};
#import "touchPointData.h"

@protocol selectStartAndEndPointDelegate <NSObject>

- (void)shopPopoverViewnavigationWithStartData:(touchPointData *)startPoi EndData:(touchPointData *)endPoi;
- (touchPointData*)UserCurrentLocation;
- (void)addAnnotation:(CGPoint)point ImageName:(NSString *)name ChangtoFloor:(NSUInteger)floorID;
-(void)removeSelectImageViewWith:(BOOL)select AndStart:(BOOL)start andEnd:(BOOL)end;
-(NSString*)appearPopViewType:(pointType)pointtype WithCGPoint:(CGPoint)point;

-(void)comeInInDoorMapWithMapID:(NGRID)mapid andFloorID:(NGRID)floorID WithSearchPoi:(NGRLocationModel*)searchPoiModel andSearchType:(searchType)searchType ;
-(void)showSelectStartOrEndView;
-(void)hiddenSelectStartOrEndView;


@end

@interface SelectStartingAndEndPoint : UIView

@property (nonatomic,weak)id<selectStartAndEndPointDelegate>delegate;
@property (nonatomic,strong)touchPointData* selectData;
@property (nonatomic,strong)touchPointData* selectStartData;
@property (nonatomic,strong)touchPointData* selectEndData;
@property (strong, nonatomic)  UIButton *startButton;
@property (strong, nonatomic)  UIButton *endButton;
@property (nonatomic,strong)UIButton* comeInIndooorButton;
@property (nonatomic,strong)UIImageView* bgImageView;
@property (nonatomic,assign)BOOL isGetingNavigationData;
@property (nonatomic,strong)UILabel* poiMessage;
@property (nonatomic,strong)NSString* poinName;
@property (nonatomic,assign)NSInteger height;
-(void)addStartData;
-(void)addEndData;

/**
 *  刷新frame
 */
-(void)reSetFrame;
@end
