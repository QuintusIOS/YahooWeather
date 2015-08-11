//
//  WeatherAssembleModel.m
//  YahooWeather
//
//  Created by Robbie on 15/3/30.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "WeatherAssembleModel.h"

@implementation WeatherAssembleModel

-(instancetype)init {
    
    self=[super init];
    if (self) {
        _cityId=[[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    [self setValue:[aDecoder decodeObjectForKey:@"cityId"] forKey:@"cityId"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[self valueForKey:@"cityId"] forKey:@"cityId"];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"cityId:%@",_cityId];
}

@end
