//
//  HldViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "HldViewController.h"

@interface HldViewController (){
    
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    
    NSArray *array;
}

@end

@implementation HldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    label1.layer.cornerRadius = label1.frame.size.height/2;
    label1.clipsToBounds = YES;
    label2.layer.cornerRadius = label1.frame.size.height/2;
    label2.clipsToBounds = YES;
    label3.layer.cornerRadius = label1.frame.size.height/2;
    label3.clipsToBounds = YES;
    
    array = @[label1, label2, label3];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(cycle) userInfo:nil repeats:YES];
    
}

- (void)cycle{
    NSInteger i = arc4random()%3;
    UILabel *label = (UILabel *)array[i];
//    [UIView animateWithDuration:0.25 animations:^{
//        label.alpha = 0;
//    }];
    [UIView animateWithDuration:0.2 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        label.alpha = 1;
    }];
}







@end
