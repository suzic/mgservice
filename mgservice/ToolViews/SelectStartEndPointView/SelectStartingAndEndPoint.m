//
//  SelectStartingAndEndPoint.m
//  bluetoothDemo
//
//  Created by peng on 15/9/18.
//  Copyright © 2015年 palmap. All rights reserved.
//

#import "SelectStartingAndEndPoint.h"
#import "EnumAndDefine.h"
@interface SelectStartingAndEndPoint()

@property (nonatomic,strong)UILabel* startRoomNameLabel;
@property (nonatomic,strong)UILabel* endRoomNameLabel;
@property (nonatomic,strong)UIView* blackLineView;
@end

@implementation SelectStartingAndEndPoint

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearself)];
        [self addGestureRecognizer:tap];
        self.height = (ButtonHeight+1)*4+9;
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-20, self.height)];
        self.bgImageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        self.bgImageView.backgroundColor = [UIColor clearColor];
//        self.bgImageView.layer.cornerRadius = 4;
        self.bgImageView.userInteractionEnabled = YES;
        [self addSubview:self.bgImageView];
        
        self.blackLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-20, self.height-10-44)];
        [self.bgImageView addSubview:self.blackLineView];
//        self.blackLineView.backgroundColor = [UIColor orangeColor];
        self.blackLineView.layer.masksToBounds = YES;
        self.blackLineView.layer.cornerRadius = 4;
        
        self.comeInIndooorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.comeInIndooorButton.frame = CGRectMake(0, ButtonHeight, kScreenWidth-20, ButtonHeight);
//        self.comeInIndooorButton.layer.cornerRadius = 4;
        [self.comeInIndooorButton setBackgroundColor:[UIColor whiteColor]];
        [self.comeInIndooorButton setTitle:@"进去看看" forState:UIControlStateNormal];
        [self.comeInIndooorButton setTitleColor:rgba(80, 154, 248, 1) forState:UIControlStateNormal];
        [self.comeInIndooorButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [self.comeInIndooorButton addTarget:self action:@selector(comeinDoor) forControlEvents:UIControlEventTouchUpInside];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startButton.frame = CGRectMake(0, (ButtonHeight+1)*2, kScreenWidth-20,ButtonHeight );
        [self.startButton setTitle:@"设为出发点" forState:UIControlStateNormal];
        [self.startButton setTitleColor:rgba(80, 154, 248, 1) forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.startButton addTarget:self action:@selector(addStartData) forControlEvents:UIControlEventTouchUpInside];
//        self.startButton.layer.cornerRadius = 4;
        self.startButton.backgroundColor = [UIColor whiteColor];
        
        self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.endButton.frame = CGRectMake(0, (ButtonHeight+1)*3, kScreenWidth-20, ButtonHeight);
        [self.endButton addTarget:self action:@selector(addEndData) forControlEvents:UIControlEventTouchUpInside];
        [self.endButton setTitle:@"设为目的地" forState:UIControlStateNormal];
        [self.endButton setTitleColor:rgba(80, 154, 248, 1) forState:UIControlStateNormal];
        [self.endButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.endButton setBackgroundColor:[UIColor whiteColor]];
//        self.endButton.layer.cornerRadius = 4;

        
        UIButton* cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBt.frame = CGRectMake(0, (ButtonHeight+1)*3+9, kScreenWidth-20, ButtonHeight);
        [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [cancelBt setBackgroundColor:[UIColor whiteColor]];
        cancelBt.layer.cornerRadius = 4;
        [cancelBt addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        
        self.poiMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, ButtonHeight)];
        self.poiMessage.backgroundColor = [UIColor whiteColor];
        self.poiMessage.text =self.poinName;
        self.poiMessage.textAlignment = NSTextAlignmentCenter;
//        self.poiMessage.layer.cornerRadius = 4;
        self.poiMessage.layer.masksToBounds = YES;
        [self.poiMessage setTextColor:[UIColor lightGrayColor]];
        [self.poiMessage setFont:[UIFont systemFontOfSize:14]];
        [self.blackLineView addSubview:self.comeInIndooorButton];
        [self.blackLineView addSubview:self.startButton];
        [self.blackLineView addSubview:self.endButton];
        [self.bgImageView addSubview:cancelBt];
        [self.blackLineView addSubview:self.poiMessage];
    }
    return self;
}
-(void)dismissSelf{
    [self.delegate hiddenSelectStartOrEndView];
}
-(void)setPoinName:(NSString *)poinName{
    if (poinName) {
        self.poiMessage.text = poinName;
        _poinName = poinName;
    }else{
        _poinName = nil;
        self.poiMessage.text = @"";
    }
}
-(void)disappearself{
    [self.delegate hiddenSelectStartOrEndView];
    [self removeFromSuperview];
}
-(void)comeinDoor{
    [self.delegate comeInInDoorMapWithMapID:0 andFloorID:0 WithSearchPoi:nil  andSearchType: searchNone];
}
-(void)addStartData{

   [self.delegate removeSelectImageViewWith:YES AndStart:NO andEnd:NO];
    if (self.selectStartData ==nil || self.selectStartData.location.x != self.selectData.location.x) {
        self.selectStartData = nil;
        self.selectStartData = [[touchPointData alloc]init];
        self.selectStartData.floorID = self.selectData.floorID;
        self.selectStartData.location = self.selectData.location;
        self.selectStartData.floorName = self.selectData.floorName;
        self.selectStartData.isLocationTransform = NO;
        self.startButton.selected = YES;
        [self.delegate addAnnotation:self.selectStartData.location ImageName:@"luoyao起点.png" ChangtoFloor:self.selectStartData.floorID];
        
    }else {
        
        [self.delegate removeSelectImageViewWith:NO AndStart:YES andEnd:NO];
        self.startButton.selected = NO;
        self.selectData = nil;
        self.selectStartData = nil;
        
         [self.delegate addAnnotation:self.selectStartData.location ImageName:@"luoyao起点.png" ChangtoFloor:self.selectStartData.floorID];
    }
    
    
    if (self.selectEndData != nil && self.selectStartData != nil) {
        //中间层气泡
         [self.delegate appearPopViewType:startPoint WithCGPoint:self.selectStartData.location];
         [self.delegate appearPopViewType:endPoint WithCGPoint:self.selectEndData.location];
        
        [self.delegate shopPopoverViewnavigationWithStartData:self.selectStartData EndData:self.selectEndData];
        self.startButton.selected = NO;
        self.endButton.selected = NO;
        
    }
}

-(void)addEndData{
    
    if (self.selectEndData ==nil ||self.selectEndData.location.x != self.selectData.location.x) {
        self.selectEndData = nil;
        self.selectEndData = [[touchPointData alloc]init];
        self.selectEndData.floorID = self.selectData.floorID;
        self.selectEndData.location = self.selectData.location;
        self.selectEndData.floorName = self.selectData.floorName;
        self.endButton.selected = YES;
        [self.delegate addAnnotation:self.selectEndData.location ImageName:@"luoyao终点.png" ChangtoFloor:self.selectEndData.floorID];
       
        [self.delegate removeSelectImageViewWith:YES AndStart:NO andEnd:NO];
        
    }else {
        [self.delegate removeSelectImageViewWith:NO AndStart:NO andEnd:YES];
        self.endButton.selected = NO;
        self.selectEndData = nil;
        self.selectData = nil;
    }
    
    if (self.selectStartData == nil ) {
        
        touchPointData* touchData = [self.delegate UserCurrentLocation];
        if (touchData) {
            
            self.selectStartData = [[touchPointData alloc]init];
            self.selectStartData.location = touchData.location;
            self.selectStartData.floorID = touchData.floorID;
            self.selectStartData.floorName = touchData.floorName;
            self.selectStartData.isLocationTransform = YES;
            //x = 12188971, y = 2071006.125
        }
        if (self.selectStartData != nil) {
             [self.delegate addAnnotation:self.selectStartData.location ImageName:@"luoyao起点.png" ChangtoFloor:self.selectStartData.floorID];
        }
        
    }

    if (self.selectStartData != nil  && self.selectEndData != nil) {
        
        //中间层气泡
        [self.delegate appearPopViewType:startPoint WithCGPoint:self.selectStartData.location];
        [self.delegate appearPopViewType:endPoint WithCGPoint:self.selectEndData.location];
        
       
        [self.delegate shopPopoverViewnavigationWithStartData:self.selectStartData EndData:self.selectEndData];
        self.startButton.selected = NO;
        self.endButton.selected = NO;
         
    }
}
-(void)reSetFrame{
    self.poiMessage.frame = CGRectMake(0,0, kScreenWidth-20, ButtonHeight);
    self.comeInIndooorButton.frame = CGRectMake(0,ButtonHeight+1, kScreenWidth-20, ButtonHeight);
    self.startButton.frame = CGRectMake(0, (ButtonHeight+1)*2, kScreenWidth-20,ButtonHeight );
    self.endButton.frame = CGRectMake(0, (ButtonHeight+1)*3, kScreenWidth-20, ButtonHeight);
    double heightY=0.0;
    NSInteger itemNumber=0;
    if (self.poinName == nil) {
        self.poiMessage.hidden = YES;
    }else{
        heightY = ButtonHeight+1;
        self.poiMessage.hidden = NO;
        itemNumber = itemNumber+1;
    }
    if (self.comeInIndooorButton.hidden){
        
    }else{
        self.comeInIndooorButton.frame = CGRectMake(0,heightY, kScreenWidth-20, ButtonHeight);
        heightY+=ButtonHeight+1;
        itemNumber = itemNumber+1;
    }
    if (self.startButton.hidden) {
        
    }else{
        self.startButton.frame = CGRectMake(0, heightY, kScreenWidth-20,ButtonHeight );
        heightY+=ButtonHeight+1;
        self.endButton.frame = CGRectMake(0, heightY, kScreenWidth-20, ButtonHeight);
        itemNumber = itemNumber+2;
    }
    self.blackLineView.frame = CGRectMake(0,(self.height-9-44)-45*itemNumber, kScreenWidth-20, itemNumber*45-2);

}


@end
