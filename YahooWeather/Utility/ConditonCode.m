//
//  ConditonCode.m
//  YahooWeather
//
//  Created by Robbie on 15/4/15.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "ConditonCode.h"

@implementation ConditonCode

+ (NSInteger)convertCode:(NSInteger)code {
    
    //大风
    if (code >= 0 && code <=2 ) {
        return 88;
    }
    //雷雨+
    else if ((code >= 3 && code <=4 ) ||(code >= 37 && code <= 39) || code == 47 || code == 45) {
        return 70;
    }
    //雪雨+
    else if ((code >= 5 && code <=8)|| code == 18 || code == 10 ) {
        return 48;
    }
    //小雨+
    else if ((code >= 11 && code <=12) || code == 9 || code == 40) {
        return 36;
    }
    //雪+
    else if ((code >= 13 && code <=16) || code == 42 || code == 46) {
        return 54;
    }
    //冰雹+
    else if (code == 17 || code == 35) {
        return 51;
    }
    //雾+
    else if (code == 20) {
        return 60;
    }
    //阴霾+
    else if (code == 21 || code == 22 || code == 19) {
        return 63;
    }
    //风+
    else if (code == 23 || code == 24) {
        return 67;
    }
    //晴天
    else if (code == 32 || code == 34) {
        return 73;
    }
    //夜间晴
    else if (code == 33 || code == 31 ) {
        return 78;
    }
    //多云＋
    else if (code == 44 || code == 30 || code == 28 || code == 26 || code == 27 || code == 29) {
        return 33;
    }
    
    //大雪＋
    else if (code == 41 || code == 43) {
        return 57;
    }
    return 106;
}

@end
