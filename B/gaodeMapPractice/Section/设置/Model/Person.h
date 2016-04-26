//
//  Person.h
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (strong, nonatomic)NSData *imageData;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *gender;
@property (strong, nonatomic)NSString *height;
@property (strong, nonatomic)NSString *weight;

+ (Person *)creatPersonWithImageData:(NSData *)imageData name:(NSString *)name gender:(NSString *)gender height:(NSString *)height weight:(NSString *)weight;

@end
