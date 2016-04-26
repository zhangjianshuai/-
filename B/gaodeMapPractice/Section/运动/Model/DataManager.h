//
//  DataManager.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchAPI.h>

@class Person;

@interface DataManager : UIViewController

//记录个人信息
@property (strong, nonatomic)Person *person;

//当前运时间,即计时器的时间
@property (assign, nonatomic)NSInteger time;

//判断计时器状态
@property (assign, nonatomic)BOOL isRuning;

//总的距离(m)
@property (assign, nonatomic)NSInteger distance;

//总的速度: km/h
@property (assign, nonatomic)float speed;

//卡路里消耗:跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
@property (assign, nonatomic)float kcal;

//平均速度: m/s
@property (assign, nonatomic)float avgSpeed;

//当前时速
@property (assign, nonatomic)float tempSpeed;

//时间间隔
@property (assign, nonatomic)NSInteger  interval;

//当前位置
@property (assign, nonatomic)CLLocationCoordinate2D beforeLocation;//上次定位的坐标,相对的起点
@property (assign, nonatomic)CLLocationCoordinate2D nowLocation;//当前坐标,相对的终点//

@property (strong, nonatomic)NSString *type;//当前运动类型

@property (strong, nonatomic)NSString *str;//当前运动名字

//@property (nonatomic, strong) NSMutableArray *locationArray;//记录所有点,用来显示记录轨迹

@property (nonatomic, strong) NSString *startTimeStr;//记录运动开始的时间

@property (nonatomic, strong) NSData *mapPhotoData;//本次记录截图

+ (DataManager *)shareDataManager;

//计算两点的距离,当前速度,总距离,总的速度(km/h),平均速度(m/s), 卡路里
- (void)calculate;

//复位
- (void)recover;








@end