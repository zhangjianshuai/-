//
//  MyTableViewCell.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myImageView.layer.cornerRadius = self.myImageView.frame.size.width/2.0;
    self.myImageView.layer.borderColor = [UIColor colorWithRed:arc4random()%255/255. green:arc4random()%255/255. blue:arc4random()%255/255. alpha:1].CGColor;
    self.myImageView.layer.borderWidth = 1;
    self.myImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
