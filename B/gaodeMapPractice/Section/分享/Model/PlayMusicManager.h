//
//  PlayMusicManager.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/31.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayMusicManager : UIViewController

@property (strong, nonatomic)AVAudioPlayer *player;

+ (PlayMusicManager *)sharePlayMusicManager;

- (void)createPlayerWithFile:(NSInteger)number;

@end
