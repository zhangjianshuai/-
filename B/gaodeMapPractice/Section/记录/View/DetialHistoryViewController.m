//
//  DetialHistoryViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "DetialHistoryViewController.h"
#import "History.h"

@interface DetialHistoryViewController (){
    BOOL flag;
    NSInteger width;
}

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic) IBOutlet UIView *bigView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longLabel;
@property (strong, nonatomic) IBOutlet UILabel *suduLabel;


@end

@implementation DetialHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情记录";
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    flag = YES;
    self.myImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.myImageView addGestureRecognizer:tap];
    
    NSLog(@"%@", _cell);
    [self createView];
    
    width = self.view.frame.size.width;
    CGRect rect = self.bigView.frame;
    rect = CGRectMake(-width, 140, width, 310);
    self.bigView.frame = rect;
    
    self.bigView.hidden = YES;
    
}

- (void)tap{
    if (self.bigView.hidden == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bigView.hidden = NO;
        }];
    }
    
    if (flag == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bigView.frame = CGRectMake(0, 140, width, 310);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.bigView.frame = CGRectMake(-width, 140, width, 310);
        }];
    }
    flag = !flag;
}

- (void)createView{
    History *history = _cell.history;
    self.myImageView.image = [UIImage imageWithData:_cell.history.mapPhotoData];
    self.nameLabel.text = _cell.nameLabel.text;
    self.weightLabel.text = [NSString stringWithFormat:@"%@ kg", history.weight];
    self.typeImageView.image = _cell.typeImageView.image;
    self.dataLabel.text = _cell.timeLabel.text;
    self.timeLabel.text = history.time;
    float a = [history.distance floatValue];
    self.longLabel.text = [NSString stringWithFormat:@"%.2f km", a/1000.0];
    float aa = [history.distance floatValue];
    float bb = [history.time floatValue];
    self.suduLabel.text = [NSString stringWithFormat:@"%.1f km/h", aa/bb * 3.6];
    //self.suduLabel.text = [NSString stringWithFormat:@"%.1f km/h", [history.distance integerValue]/[history.time integerValue] * 3.6];
}

@end
