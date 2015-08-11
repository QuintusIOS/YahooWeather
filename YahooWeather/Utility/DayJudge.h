//
//  DayJudge.h
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayJudge : NSObject
+ (NSString *)judgeDayOrNight:(NSString *)str1 :(NSString *) str2 :(NSString *) timeZone;
@end
