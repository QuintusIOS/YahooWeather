//
//  DayJudge.m
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "DayJudge.h"

@implementation DayJudge
+ (NSString *)judgeDayOrNight:(NSString *)str1 :(NSString *) str2 :(NSString *)timeZone {
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:timeZone];
//    NSLog(@"timeZone: %@",timeZone);
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    [f1 setDateFormat:@"yyyy-MM-dd"];
    NSString *tmpStr = [f1 stringFromDate:[NSDate date]];
//    NSLog(@"%@",tmpStr);
    
    NSDateFormatter *f3 = [[NSDateFormatter alloc] init];
    [f3 setDateFormat:@"yyyy-MM-dd K:mm aa"];
    
    NSString *dateCur = [f3 stringFromDate:[NSDate date]];
    NSDate *dateCC = [f3 dateFromString:dateCur];
    NSInteger gap3 = [zone secondsFromGMTForDate:dateCC];
    NSDate *locDateCC = [dateCC dateByAddingTimeInterval:gap3];
 //   NSLog(@"locDateCC = %@",locDateCC);
    
    NSString *dateR = [NSString stringWithFormat:@"%@ %@",tmpStr,str1];
    NSDate *dateRR = [f3 dateFromString:dateR];
    NSInteger gap = [zone secondsFromGMTForDate:dateRR];
    NSDate *locDateRR = [dateRR dateByAddingTimeInterval:gap];
  //  NSLog(@"locDateRR = %@",locDateRR);
    
    
    NSString *dateS = [NSString stringWithFormat:@"%@ %@",tmpStr,str2];
    NSDate *dateSS = [f3 dateFromString:dateS];
    NSInteger gap2 = [zone secondsFromGMTForDate:dateRR];
    NSDate *locDateSS = [dateSS dateByAddingTimeInterval:gap2];
  //  NSLog(@"locDateSS = %@",locDateSS);
    
    if(([locDateCC compare:locDateRR] == NSOrderedDescending) && ([locDateCC compare:locDateSS] == NSOrderedAscending))
    {
//        NSLog(@"day");
        return @"yes";
    }
    else
    {
//        NSLog(@"night");
        return @"no";
    }
}

@end
