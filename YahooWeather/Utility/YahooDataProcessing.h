//
//  YahooDataProcessing.h
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDetailModel.h"
#import "GDataXMLNode.h"
#import "DayJudge.h"

@interface YahooDataProcessing : NSObject

+ (WeatherDetailModel *)ProcessData:(NSData *)data;

@end
