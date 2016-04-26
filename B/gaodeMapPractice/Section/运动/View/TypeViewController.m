//
//  TypeViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "TypeViewController.h"
#import "DataManager.h"

@interface TypeViewController () {
    NSArray *array;
    NSArray *strArray;
    DataManager *dataManager;
}

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataManager = [DataManager shareDataManager];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = self.view1.bounds;
    [button1 addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:button1];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = self.view2.bounds;
    [button2 addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:button2];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = self.view3.bounds;
    [button3 addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view3 addSubview:button3];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = self.view4.bounds;
    [button4 addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view4 addSubview:button4];
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = self.view5.bounds;
    [button5 addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view5 addSubview:button5];
    
    array = @[_image1, _image2, _image3, _image4, _image5];
    strArray = @[@"跑步ing",@"骑行ing",@"跑马ing",@"滑雪ing",@"游泳ing"];
    
    int i = 0;
    for (UIImageView *a in array) {
        if ([dataManager.str isEqualToString:strArray[i]]) {
            a.hidden = NO;
        } else {
        a.hidden = YES;
        }
        i++;
    }
}

- (void)tapView:(UIButton *)sender {
    NSInteger i = sender.superview.tag - 101;
    for (UIImageView *a in array) {
        a.hidden = YES;
        if (a == array[i]) {
            a.hidden = NO;
            dataManager.type = [NSString stringWithFormat:@"sporticon%ld", (long)i];
            dataManager.str = strArray[i];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
