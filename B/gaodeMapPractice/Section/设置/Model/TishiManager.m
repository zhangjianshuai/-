//
//  TishiManager.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/31.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "TishiManager.h"

@interface TishiManager ()

@end

@implementation TishiManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (TishiManager *)shareTishiManager {
    static TishiManager *tishiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tishiManager = [[TishiManager alloc] init];
    });
    return tishiManager;   
}

@end
