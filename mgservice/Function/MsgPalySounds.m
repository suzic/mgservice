//
//  MsgPalySounds.m
//  FoodOrderDemo
//
//  Created by 刘超 on 15/9/6.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "MsgPalySounds.h"

@implementation MsgPalySounds

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self)
    {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path)
        {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError)
            {
                sound = nil;
            }
        }
    }
    return self;
}

- (id)initSystemLocationSound
{
    self = [super init];
    if (self)
    {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"我们俩-郭顶" ofType:@"mp3"];
        NSURL *pathUrl = [[NSURL alloc] initFileURLWithPath:path];
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathUrl error:nil];
        player = audioPlayer;
        [player prepareToPlay];
        player.numberOfLoops = -1;
        sound = kSystemSoundID_Vibrate;//震动
    }
    
    return self;
}

- (void)palyLocation
{
    [player play];
    sound = kSystemSoundID_Vibrate;//震动
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)stopLocation
{
    [player stop];
    sound = nil;
    [timer invalidate];
    timer = nil;
}
- (void)timerFired
{
    AudioServicesPlaySystemSound(sound);
}

@end
