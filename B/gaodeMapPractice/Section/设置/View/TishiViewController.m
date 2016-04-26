//
//  TishiViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/31.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "TishiViewController.h"
#import "TishiManager.h"

@interface TishiViewController () {
    TishiManager *tishiManager;
}
@property (strong, nonatomic) IBOutlet UITextField *distanceTextField;
@property (strong, nonatomic) IBOutlet UITextField *wordsTextField;

@property (strong, nonatomic) IBOutlet UIButton *button;


@end

@implementation TishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提示助手";
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
//    self.distanceTextField.layer.cornerRadius = 10;
//    self.distanceTextField.clipsToBounds = YES;
    self.distanceTextField.clearButtonMode = UITextFieldViewModeAlways;
//    self.wordsTextField.layer.cornerRadius = 10;
//    self.wordsTextField.clipsToBounds = YES;
    self.wordsTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    self.button.layer.cornerRadius = 10;
    self.button.clipsToBounds = YES;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button.showsTouchWhenHighlighted = YES;
    
    tishiManager = [TishiManager shareTishiManager];
}

- (void)tap{
    [self.view endEditing:YES];
}

- (IBAction)button:(id)sender {
    tishiManager.distance = self.distanceTextField.text;
    tishiManager.words = self.wordsTextField.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
