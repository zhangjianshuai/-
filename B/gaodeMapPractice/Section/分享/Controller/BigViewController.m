//
//  BigViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//


#import "BigViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayMusicManager.h"


@interface BigViewController (){
    //BOOL isLightOn;
    
    IBOutlet UIImageView *lightImageView;
    
    IBOutlet UIImageView *hldImageView;
    
    IBOutlet UIImageView *huocheImageView;
    
    PlayMusicManager *playMusicManager;
    
}

//- (IBAction)startButton:(id)sender;
//- (IBAction)stopButton:(id)sender;

@end

@implementation BigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    playMusicManager = [PlayMusicManager sharePlayMusicManager];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLight)];
    lightImageView.userInteractionEnabled = YES;
    [lightImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tohld)];
    hldImageView.userInteractionEnabled = YES;
    [hldImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huocheSound)];
    huocheImageView.userInteractionEnabled = YES;
    [huocheImageView addGestureRecognizer:tap3];
    
    //[self creatPlayer];
}

- (void)toLight{
    [self performSegueWithIdentifier:@"toLight" sender:nil];
}

- (void)tohld{
    [self performSegueWithIdentifier:@"tohld" sender:nil];
}

- (void)huocheSound{
    [self createMusicButton];
}

- (void)createMusicButton {
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(44/320.0 * self.view.frame.size.width + 50*i / 320.0 * self.view.frame.size.width, self.view.frame.size.height - 95, 40, 40);
        button.tag = 100 + i;
        button.layer.cornerRadius = 20;
        button.clipsToBounds = YES;
        button.showsTouchWhenHighlighted = YES;
        button.layer.borderWidth = 1;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", 100 + i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)playMusic:(UIButton *)sender{
    NSLog(@"%ld", sender.tag);
    [playMusicManager createPlayerWithFile:sender.tag];
}


@end
