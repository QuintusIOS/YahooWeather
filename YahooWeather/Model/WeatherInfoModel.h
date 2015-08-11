//
//  WeatherInfoModel.h
//  YahooWeather
//
//  Created by Robbie on 15/3/30.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfoModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *woeid;

@end
