//
//  changeFloorToolView.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 16/3/17.
//  Copyright © 2016年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nagrand/Nagrand.h>

@protocol floorChangeDelegate <NSObject>
/**
 *  点击了切换楼层的tableview
 *
 *  @param 需要实现 requestPlanarGraph 设置_currentFloorId = floorid
 */
-(void)tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID:(NSInteger)floorid andFloorName:(NSString*)floorName WithSearchPoi:(NGRLocationModel*)searchPoiModel;

@end

@interface changeFloorToolView : UIView

/**
 *  当前楼层的名字比如F1
 */
@property(nonatomic,strong)NSString* currentFloorName;
@property(nonatomic,strong)UITableView* tableViewOfFloors;
@property(nonatomic,strong)NSMutableArray* floorNameDataArray;
@property(nonatomic,strong)NSMutableArray* floorNumberDataArray;
@property(nonatomic,strong)UIButton* floorChangeButton;

@property(nonatomic,weak)id<floorChangeDelegate> delegate;

-(void)tableviewScrollToIndexofPathOfRow:(NSInteger)rowNum;
-(void)restart;

-(void)reLoadDataWithSelectRow:(NSInteger)rowNum;
@end
