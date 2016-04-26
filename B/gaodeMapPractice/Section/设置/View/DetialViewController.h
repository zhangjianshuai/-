//
//  DetialViewController.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface DetialViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *genderLabel;
@property (strong, nonatomic) IBOutlet UITextField *heightLabel;
@property (strong, nonatomic) IBOutlet UITextField *weightLabel;

@end
