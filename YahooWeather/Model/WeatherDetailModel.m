//
//  WeatherDetailModel.m
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "WeatherDetailModel.h"
#import <objc/runtime.h>

static WeatherDetailModel *s_instance;


@implementation WeatherDetailModel

+ (WeatherDetailModel *)sharedInstance {
    if (!s_instance) {
        s_instance = [[WeatherDetailModel alloc] init];
    }
    
    return s_instance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p) {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //        NSLog(@"key  = %@",key);
        
        [arr addObject:key];
        
    }
    
    for(NSString *key in arr) {
        [ aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        Class cls = [self class];
        unsigned int ivarsCnt = 0;
        //　获取类成员变量列表，ivarsCnt为类成员数量
        Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
        for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
        {
            Ivar const ivar = *p;
            
            //　获取变量名
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
            // 比如 @property(retain) NSString *abc;则 key == _abc;
            //        NSLog(@"key  = %@",key);
            
            [arr addObject:key];
            
        }
        
        for(NSString *key in arr) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
        
    }
    return self;
}

- (NSString *)description {
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"here:"];
    
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p) {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //        NSLog(@"key  = %@",key);
        
        if([self valueForKey:key])
            [arr addObject:key];
    }
    
    for(NSString *key in arr) {
        [str appendString:[self valueForKey:key]];
        [str appendString:@", "];
    }
    return str;
}

@end
