//
//  WeatherInfoModel.m
//  YahooWeather
//
//  Created by Robbie on 15/3/30.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "WeatherInfoModel.h"

@implementation WeatherInfoModel



-(id)initWithCoder:(NSCoder *)aDecoder {
    
    [self setValue:[aDecoder decodeObjectForKey:@"cityName"] forKey:@"cityName"];
    [self setValue:[aDecoder decodeObjectForKey:@"woeid"] forKey:@"woeid"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[self valueForKey:@"cityName"] forKey:@"cityName"];
    [aCoder encodeObject:[self valueForKey:@"woeid"] forKey:@"woeid"];
}

-(NSString *)decription {
    
    return [NSString stringWithFormat:@"_cityName:%@,_woeid:%@",_cityName,_woeid];
}


@end
