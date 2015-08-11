//
//  WeatherAssembleModel.h
//  YahooWeather
//
//  Created by Robbie on 15/3/30.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfoModel.h"

@interface WeatherAssembleModel : NSObject<NSCoding>

@property (nonatomic, strong) NSMutableArray *cityId;

@end
