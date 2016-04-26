//
//  Person.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (Person *)creatPersonWithImageData:(NSData *)imageData name:(NSString *)name gender:(NSString *)gender height:(NSString *)height weight:(NSString *)weight {
    Person *person = [[Person alloc] init];
    person.imageData = imageData;
    person.name  = name;
    person.gender = gender;
    person.height = height;
    person.weight = weight;
    
    return person;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //编码
    [aCoder encodeObject:self.imageData forKey:@"IMAGEDATA"];
    [aCoder encodeObject:self.name forKey:@"NAME"];
    [aCoder encodeObject:self.gender forKey:@"GENDER"];
    [aCoder encodeObject:self.height forKey:@"HEIGHT"];
    [aCoder encodeObject:self.weight forKey:@"WEIGHT"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //解码(取值的过程)
        self.imageData = [aDecoder decodeObjectForKey:@"IMAGEDATA"];
        self.name = [aDecoder decodeObjectForKey:@"NAME"];
        self.gender = [aDecoder decodeObjectForKey:@"GENDER"];
        self.height = [aDecoder decodeObjectForKey:@"HEIGHT"];
        self.weight = [aDecoder decodeObjectForKey:@"WEIGHT"];
    }
    return self;
}

@end
