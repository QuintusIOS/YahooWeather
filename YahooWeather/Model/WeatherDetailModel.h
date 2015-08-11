//
//  WeatherDetailModel.h
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDetailModel : NSObject

@property (nonatomic, strong) NSString *lastBuildDate;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *temperatureUnit;
@property (nonatomic, strong) NSString *distanceUnit;
@property (nonatomic, strong) NSString *pressureUnit;
@property (nonatomic, strong) NSString *speedUnit;

@property (nonatomic, strong) NSString *chil;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *directionCode;
@property (nonatomic, strong) NSString *speed;

@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *humidityCode;
@property (nonatomic, strong) NSString *visibility;
@property (nonatomic, strong) NSString *pressure;
@property (nonatomic, strong) NSString *rising;

@property (nonatomic, strong) NSString *sunset;
@property (nonatomic, strong) NSString *sunrise;
@property (nonatomic, strong) NSString *isDayNight;

@property (nonatomic, strong) NSString *curWeatherCondition;
@property (nonatomic, strong) NSString *curWeatherConditionCode;
@property (nonatomic, strong) NSString *curWeatherTemp;

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *low;
@property (nonatomic, strong) NSString *high;
@property (nonatomic, strong) NSString *weatherCondition;
@property (nonatomic, strong) NSString *weatherConditionCode;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *guid;

@end
