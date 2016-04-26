//
//  TishiManager.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/31.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TishiManager : UIViewController

@property(nonatomic, strong)NSString *distance;
@property(nonatomic, strong)NSString *words;

+ (TishiManager *)shareTishiManager;

@end
