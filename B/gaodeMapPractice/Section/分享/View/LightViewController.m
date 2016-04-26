//
//  LightViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "LightViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LightViewController (){
    
    IBOutlet UIImageView *bgImageView;
    
    BOOL isLightOn;
}

@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isLightOn = NO;
    bgImageView.userInteractionEnabled = YES;
    
    bgImageView.image = [UIImage imageNamed:@"lightOff"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(put)];
    [bgImageView addGestureRecognizer:tap];
}

- (void)put{
    if (isLightOn == NO) {
        bgImageView.image = [UIImage imageNamed:@"lightOn"];
        [self start];
    } else if (isLightOn == YES) {
        bgImageView.image = [UIImage imageNamed:@"lightOff"];
        [self stop];
    }
}

- (void)start {
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
        isLightOn=YES;
    }
}

- (void)stop {
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
     isLightOn=NO;
}

@end
