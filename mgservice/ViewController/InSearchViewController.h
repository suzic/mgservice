//
//  SearchViewController.h
//  sdk2.0zhengquandasha
//
//  Created by peng on 15/11/30.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "touchPointData.h"
#import <Nagrand/NGROverlayer.h>
#import <Nagrand/Nagrand.h>
#import "EnumAndDefine.h"




@protocol searchPoiDelegate <NSObject>
/**
 *  搜索poiid
 *
 *  @param destination 字符串，ag.上海证券大厦
 */
-(void)searchPoiWithDestinationString:(NSString*)destination andNeewShowAlert:(BOOL)need;
/**
 *  搜索poiid在地图中的位置
 *
 *  @param poiid poiid号
 */
-(void)searchPoiFeature:(NGRLocationModel*)locationModel andSearchType:(searchType)searchType ;

-(touchPointData*)searchVCgetCurrentUserLocation;
@end

@interface InSearchViewController : UIViewController

@property(weak,nonatomic)id<searchPoiDelegate>delegate;
@property (nonatomic,strong)NSMutableArray* searchResultArray;
@property(nonatomic,assign)searchType searchType;

-(void)reloadTableview;

-(void)stopAnimating;

-(void)showAlertNoSearchResult;

@end
