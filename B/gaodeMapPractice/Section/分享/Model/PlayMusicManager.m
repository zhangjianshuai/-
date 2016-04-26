//
//  PlayMusicManager.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/31.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "PlayMusicManager.h"

@interface PlayMusicManager () {
    NSString *path;
}

@end

@implementation PlayMusicManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (PlayMusicManager *)sharePlayMusicManager {
    static PlayMusicManager *playMusicManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playMusicManager = [[PlayMusicManager alloc] init];
    });
    return playMusicManager;
}

- (void)createPlayerWithFile:(NSInteger)number;{
    //创建播放器
    if (number == 100) {
        path = [[NSBundle mainBundle] pathForResource:@"汽车喇叭" ofType:@"mp3"];
    }
    if (number == 101) {
        path = [[NSBundle mainBundle] pathForResource:@"火车" ofType:@"mp3"];
    }
    if (number == 102) {
        path = [[NSBundle mainBundle] pathForResource:@"摩托车" ofType:@"mp3"];
    }
    if (number == 103) {
        path = [[NSBundle mainBundle] pathForResource:@"飞机" ofType:@"mp3"];
    }
    if (number == 104) {
        path = [[NSBundle mainBundle] pathForResource:@"导弹" ofType:@"mp3"];
    }
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path] ;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player prepareToPlay];
    self.player.volume = 1;
    //self.player.numberOfLoops = 1;
    [self.player play];
}

@end
