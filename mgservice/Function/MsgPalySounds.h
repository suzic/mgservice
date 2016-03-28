//
//  MsgPalySounds.h
//  FoodOrderDemo
//
//  Created by 刘超 on 15/9/6.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface MsgPalySounds : NSObject
{
    SystemSoundID sound;
    AVAudioPlayer *player;
    NSTimer *timer;
}
- (id)initSystemShake;

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音

/**
 *  @abstract 初始化本地声音
 */
- (id)initSystemLocationSound;

/**
 *  @abstract 播放本地声音
 */
- (void)palyLocation;

/**
 *  @abstract 停止本地声音
 */
- (void)stopLocation;


@end
