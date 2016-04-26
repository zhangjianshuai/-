//
//  History.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/29.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchAPI.h>

@class DataManager;

@interface History : NSObject<NSCoding>

@property (strong, nonatomic) NSString *name;//运动人姓名

@property (strong, nonatomic) NSString *weight;//运动人体重

@property (strong, nonatomic) NSData *imageData;//运动人头像

//每一次运动的属性
@property (strong, nonatomic) NSString *startTime;//开始时间

@property (strong, nonatomic) NSString *time;//运动时长(单位:秒)

@property (strong, nonatomic)NSString *distance;//总的距离(单位:米)

@property (strong, nonatomic)NSString *str;//当前运动名字

//@property (nonatomic, strong) NSMutableArray *locationArray;//记录所有点,用来显示记录轨迹

//@property (nonatomic, strong) MAPolyline *line;//本次的轨迹

@property (nonatomic, strong) NSData *mapPhotoData;//本次记录的轨迹截图

+(History *)createHistory;

@end
