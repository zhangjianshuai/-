//
//  DataManager.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "DataManager.h"
#import "Person.h"


@interface DataManager ()

@end

@implementation DataManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (DataManager *)shareDataManager {
    static DataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DataManager alloc] init];
    });
    return dataManager;
}

//懒加载
- (Person *)person {
    if (!_person) {
        self.person = [[Person alloc] init];
    }
    return _person;
}

//- (NSMutableArray *)locationArray {
//    if (!_locationArray) {
//        self.locationArray = [@[] mutableCopy];
//    }
//    return _locationArray;
//}

//计算两点的距离,当前速度,总距离,总的速度(km/h),平均速度(m/s)
- (void)calculate {

    //如果计时器在跑
    if (_isRuning) {
        //进行相关计算
        //1.将两个经纬度点转成投影点
        
        MAMapPoint point1 = MAMapPointForCoordinate(_beforeLocation);
        MAMapPoint point2 = MAMapPointForCoordinate(_nowLocation);
        
        //2.计算距离
        
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        NSLog(@"distance:%.1f", distance);//(m)
        
        //总的距离
        self.distance += distance;
        //平均速度(m/s)
        if (_time != 0) {
        self.avgSpeed = self.distance / self.time;
        //总的速度
        self.speed = _avgSpeed * 3.6;
            }
        //当前速度
        if (self.interval == 0) {
            _interval = 1;
        }
        self.tempSpeed = distance/_interval;
        //跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
        self.kcal = [self.person.weight integerValue] * distance * 1.036 / 1000;
        
    }   
}

//复位操作
- (void)recover {
    self.time = 0;
    self.isRuning = NO;
    self.distance = 0;
    self.speed = 0;
    self.kcal = 0;
    self.avgSpeed = 0;
    self.tempSpeed = 0;
    self.interval = 0;
    //[self.locationArray removeAllObjects];
    self.startTimeStr = nil;
    self.mapPhotoData = nil;
}


@end
