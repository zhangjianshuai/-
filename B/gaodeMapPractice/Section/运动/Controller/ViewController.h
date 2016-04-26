//
//  ViewController.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/23.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//


#import <UIKit/UIKit.h>
@class MapViewController;
@interface ViewController : UIViewController

//数据View
@property (strong, nonatomic) IBOutlet UIView *MyDataView;

@property (strong, nonatomic) UIView *MyMapView;

@property (strong, nonatomic) MapViewController *mapVC;




@end

