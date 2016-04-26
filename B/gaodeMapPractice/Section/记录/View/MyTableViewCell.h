//
//  MyTableViewCell.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class History;

@interface MyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detialLabel;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;

@property (strong, nonatomic) History *history;

@end
