//
//  PlaySoundsView.m
//  FoodOrderDemo
//
//  Created by 刘超 on 15/9/9.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "PlaySoundsView.h"
#import "AppDelegate.h"
#import "MsgPalySounds.h"

@interface PlaySoundsView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, retain) NSTimer *time;
@property (nonatomic, retain) MsgPalySounds *palySounds;

@end

@implementation PlaySoundsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {

        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (MsgPalySounds *)palySounds
{
    if (_palySounds == nil)
    {
        _palySounds = [[MsgPalySounds alloc] initSystemLocationSound];
    }
    return _palySounds;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithTitle:(NSString *) title delegate:(id<PalySoundsDelegate>) palySoundsDelegate
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PalySoundsView" owner:nil options:nil];
    self =[nibView objectAtIndex:0];
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.alpha = 0.0f;
        self.delegate = palySoundsDelegate;
        self.backgroundColor = [UIColor blackColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.alpha = 0.0f;
        self.titleName.text = title;
    }
    
    return self;
}

- (void)showSoundView
{
    self.time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.8f;
        [self.palySounds palyLocation];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)disMissSoundsView
{
    [self.time invalidate];
    self.time = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
        [self.palySounds stopLocation];
    } completion:^(BOOL finished) {
    }];
}

- (void)timerFired
{
    [self shakeView:self.iconImage];
//    [UIView animateWithDuration:1 animations:^{
//        self.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        self.alpha = 0.8;
//    }];
}
-(void)shakeView:(UIImageView*)viewToShake
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.25];
    shake.toValue = [NSNumber numberWithFloat:+0.25];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    
    [self.iconImage.layer addAnimation:shake forKey:@"imageView"];
    
    self.iconImage.alpha = 1.0;
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}

- (IBAction)tapAvtion:(id)sender
{
    [self disMissSoundsView];
    [self.delegate palySoundsType:PALYMEGSOUNDS WithSelectedType:CANCELTYPE];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self disMissSoundsView];
    [self.delegate palySoundsType:PALYMEGSOUNDS WithSelectedType:CANCELTYPE];
}
- (IBAction)sureButtonAction:(id)sender
{
    [self disMissSoundsView];
    [self.delegate palySoundsType:PALYMEGSOUNDS WithSelectedType:SURETYPE];
}
- (IBAction)readButtonAction:(id)sender
{
    [self disMissSoundsView];
    [self.delegate palySoundsType:PALYMEGSOUNDS WithSelectedType:CONFIRMTYPE];
}

- (void)showButtonHidden:(BOOL)show
{
    self.cancelButton.hidden = !show;
    self.confirmButton.hidden = !show;
    self.sureButton.hidden = !show;

}

@end
