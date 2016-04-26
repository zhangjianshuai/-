//
//  SettingViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "SettingViewController.h"
#import "Person.h"
#import "DataManager.h"

@interface SettingViewController () {
    
    IBOutlet UIImageView *pic;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *detialLabel;
    //Person *person;
    DataManager *dataManager;
    
}

- (IBAction)detialButton:(id)sender;

- (IBAction)clearButton:(id)sender;
- (IBAction)helpButton:(id)sender;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    pic.layer.cornerRadius = 10;
    pic.clipsToBounds = YES;
}

//读本地 用户信息 单例储存
- (void)viewDidAppear:(BOOL)animated {
    dataManager = [DataManager shareDataManager];
    [self unarchieveObject];
}

//反归档
- (void)unarchieveObject {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    Person *per = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"archieve"]];
    dataManager.person = per;
    //NSLog(@"person.name = %@", per.name);
    [self showUser];
}

- (void)showUser{
    Person *person = dataManager.person;
    pic.image = [UIImage imageWithData:person.imageData];
    nameLabel.text = person.name;
    detialLabel.text = [NSString stringWithFormat:@"性别:%@ %@kg %@cm", person.gender, person.weight, person.height];
}

- (IBAction)detialButton:(id)sender {
    [self performSegueWithIdentifier:@"toDetial" sender:nil];
}

- (IBAction)clearButton:(id)sender {
    [self performSegueWithIdentifier:@"totishi" sender:nil];
}

- (IBAction)helpButton:(id)sender {
    [self performSegueWithIdentifier:@"toHelp" sender:nil];
}

@end
