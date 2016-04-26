//
//  History.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/29.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "History.h"
#import "Person.h"
#import "DataManager.h"

@implementation History

+(History *)createHistory {
    
    DataManager *dataManager = [DataManager shareDataManager];
    
    //显示时间字符串
    NSInteger i, j, k;
    NSString *str1, *str2, *str3;
    i = dataManager.time/3600;
    j = dataManager.time%3600/60;
    k = dataManager.time%3600%60;
    
    if (i < 10) {
        str1 = [NSString stringWithFormat:@"0%ld", (long)i];
    } else {
        str1 = [NSString stringWithFormat:@"%ld", (long)i];
    }
    if (j < 10) {
        str2 = [NSString stringWithFormat:@"0%ld", (long)j];
    } else {
        str2 = [NSString stringWithFormat:@"%ld", (long)j];
    }
    if (k < 10) {
        str3 = [NSString stringWithFormat:@"0%ld", (long)k];
    } else {
        str3 = [NSString stringWithFormat:@"%ld", (long)k];
    }
    
    History *history = [[History alloc] init];
    history.startTime = dataManager.startTimeStr;
    history.time = [NSString stringWithFormat:@"%@ : %@ : %@", str1, str2, str3];
    history.distance = [NSString stringWithFormat:@"%.2f", dataManager.distance/1000.0];
    history.str = dataManager.str;

//    NSArray *locationArray = [NSArray arrayWithArray:dataManager.locationArray];
//    //通过所有点得到线
//    NSInteger count  = locationArray.count;
//    CLLocationCoordinate2D polylineCoords[count];
//    for (NSInteger i; i < count; i++) {
//        polylineCoords[i] = [locationArray[i] coordinate];
//    }
//    history.line = [MAPolyline polylineWithCoordinates:polylineCoords count:count];
    
    history.mapPhotoData = dataManager.mapPhotoData;
    
    //反归档
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        Person *per = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"archieve"]];
    history.name = per.name;
    history.weight = per.weight;
    history.imageData = per.imageData;
    
    return history;
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    //编码
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.str forKey:@"str"];
    //[aCoder encodeObject:self.line forKey:@"line"];
    [aCoder encodeObject:self.mapPhotoData forKey:@"mapPhotoData"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
    [aCoder encodeObject:self.imageData forKey:@"imageData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //解码(取值的过程)
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.str = [aDecoder decodeObjectForKey:@"str"];
        //self.line = [aDecoder decodeObjectForKey:@"line"];
        self.mapPhotoData = [aDecoder decodeObjectForKey:@"mapPhotoData"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.imageData = [aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}











@end
