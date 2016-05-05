//
//  changeFloorToolView.m
//  sdk2.0zhengquandasha
//
//  Created by peng on 16/3/17.
//  Copyright © 2016年 palmaplus. All rights reserved.
//

#import "changeFloorToolView.h"

@interface changeFloorToolView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger accumNum;
@end

@implementation changeFloorToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:CGRectMake(kScreenWidth - 40, frame.origin.y, 40, 44*5)]) {
        
        _tableViewOfFloors = [[UITableView alloc]initWithFrame:CGRectMake(0 , 44, 40, 44*3)];
        _tableViewOfFloors.backgroundColor =[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        _tableViewOfFloors.delegate = self;
        _tableViewOfFloors.dataSource = self;
        _tableViewOfFloors.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableViewOfFloors.showsVerticalScrollIndicator = NO;
        _tableViewOfFloors.showsHorizontalScrollIndicator = NO;
        _tableViewOfFloors.userInteractionEnabled = YES;
        self.floorNumberDataArray = [NSMutableArray array];
        self.floorNameDataArray = [NSMutableArray array];
        self.accumNum = 0;
        [self addSubview:_tableViewOfFloors];
        [self getchangeButton];
    }
    return self;
}

-(void)getchangeButton{
    
    UIButton* upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:upButton];
    self.alpha = 0.8;
    upButton.frame = CGRectMake(0, 0, 40, 44);
    [upButton addTarget:self action:@selector(upChangeFloorTableview:) forControlEvents:UIControlEventTouchUpInside];
    upButton.tag = 0;
    [upButton setBackgroundImage:[UIImage imageNamed:@"ico_pgup"] forState:UIControlStateNormal];
    
    
    UIButton* downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:downButton];
    downButton.frame = CGRectMake(0, 44*4, 40, 44);
    [downButton addTarget:self action:@selector(upChangeFloorTableview:) forControlEvents:UIControlEventTouchUpInside];
    downButton.tag = 1;
    [downButton setBackgroundImage:[UIImage imageNamed:@"ico_pgdn"] forState:UIControlStateNormal];
}
/**
 *  滚动tableview
 *
 *  @param sender 是向上滚还是向下滚
 */
-(void)upChangeFloorTableview:(UIButton*)sender{
    NSIndexPath* indexPath =  _tableViewOfFloors.indexPathForSelectedRow;
    
    if (sender.tag == 1) {
        
        if (indexPath.row+self.accumNum+1 >=0&&indexPath.row+self.accumNum+1 <=_floorNumberDataArray.count-1) {
            self.accumNum++;
            [_tableViewOfFloors scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+self.accumNum inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }else{
           
        }
        
    }
    else{
        
        if (indexPath.row+self.accumNum-1 >=0&&indexPath.row+self.accumNum-1 <=_floorNumberDataArray.count-1) {
            self.accumNum--;
            [_tableViewOfFloors scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row+self.accumNum inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }else{
            
        }
        
        
    }
}

#pragma mark-uitableview的回调方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _floorNameDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"floors"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellName"];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel* labelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.numberOfLines = 1;
    labelView.textAlignment = NSTextAlignmentCenter;
    
    labelView.text  =[NSString stringWithFormat:@"%@",_floorNameDataArray[indexPath.row]] ;
    [cell addSubview:labelView];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableViewOfFloors ) {
        self.accumNum = 0;
        [self.delegate tableviewDidselectForChangeFloorRequestPlanarGraphWithFloorID: ((NSNumber*)_floorNumberDataArray[indexPath.row]).integerValue andFloorName:_floorNameDataArray[indexPath.row] WithSearchPoi:nil andSearchType:searchNone];
        
    }
}
-(void)tableviewScrollToIndexofPathOfRow:(NSInteger)rowNum{
    
     [_tableViewOfFloors scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNum inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_tableViewOfFloors selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowNum inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
-(void)restart{
    [self.floorNameDataArray removeAllObjects];
    [self.floorNumberDataArray removeAllObjects];
    self.accumNum = 0;
    
    self.hidden = NO;
}
-(void)reLoadDataWithSelectRow:(NSInteger)rowNum{

    [self.tableViewOfFloors reloadData];
    [self.tableViewOfFloors selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowNum inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}
@end
