//
//  YahooDataProcessing.m
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "YahooDataProcessing.h"

@implementation YahooDataProcessing

+ (WeatherDetailModel *)ProcessData:(NSData *)data {
    
        WeatherDetailModel *wdm=[[WeatherDetailModel alloc]init];
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement *rootElement=[document rootElement];
        GDataXMLElement *elements=[[rootElement elementsForName:@"channel"]lastObject];

        GDataXMLElement *element1=[[elements elementsForName:@"lastBuildDate"]lastObject];
        
        GDataXMLElement *element2=[[elements elementsForName:@"yweather:location"]lastObject];
        GDataXMLElement *element3=[[elements elementsForName:@"yweather:units"]lastObject];
        GDataXMLElement *element4=[[elements elementsForName:@"yweather:wind"]lastObject];
        GDataXMLElement *element5=[[elements elementsForName:@"yweather:atmosphere"]lastObject];
        GDataXMLElement *element6=[[elements elementsForName:@"yweather:astronomy"]lastObject];
        
        wdm.lastBuildDate=element1.stringValue;
        
        wdm.city=[element2 attributeForName:@"city"].stringValue;
        wdm.region=[element2 attributeForName:@"region"].stringValue;
        wdm.country=[element2 attributeForName:@"country"].stringValue;
        
        wdm.temperatureUnit=[element3 attributeForName:@"temperature"].stringValue;
        wdm.distanceUnit=[element3 attributeForName:@"distance"].stringValue;
        wdm.pressureUnit=[element3 attributeForName:@"pressure"].stringValue;
        wdm.speedUnit=[element3 attributeForName:@"speed"].stringValue;
        
        wdm.chil=[element4 attributeForName:@"chill"].stringValue;
        NSString *direction=[element4 attributeForName:@"direction"].stringValue;
        wdm.speed=[element4 attributeForName:@"speed"].stringValue;

        NSInteger directionI=direction.intValue;
       
        if (directionI==0) {
            wdm.direction=@"N/A";
            wdm.directionCode=@"97";
        }
        if ((directionI > 0 && directionI < 45) || directionI >= 315 ) {
            wdm.direction=@"north";
            wdm.directionCode=@"98";
        }

        if (directionI >= 45 && directionI < 135) {
            wdm.direction=@"east";
            wdm.directionCode=@"99";
        }

        if (directionI >= 135 && directionI < 225) {
            wdm.direction=@"south";
            wdm.directionCode=@"100";
        }

        if (directionI >= 225 && directionI < 315) {
            wdm.direction=@"west";
            wdm.directionCode=@"101";
        }
        
        wdm.humidity=[element5 attributeForName:@"humidity"].stringValue;
        NSInteger humidityI=wdm.humidity.intValue;
       
        if (humidityI <= 25) {
            wdm.humidityCode=@"90";
        }
        if (humidityI > 25 && humidityI <= 50) {
            wdm.humidityCode=@"91";
        }
        if (humidityI > 50 && humidityI <= 75) {
            wdm.humidityCode=@"92";
        }
        if (humidityI > 75 && humidityI <= 100) {
            wdm.humidityCode=@"93";
        }
    
        wdm.visibility=[element5 attributeForName:@"visibility"].stringValue;
        wdm.pressure=[element5 attributeForName:@"pressure"].stringValue;
        wdm.rising=[element5 attributeForName:@"rising"].stringValue;
        
        wdm.sunrise=[element6 attributeForName:@"sunrise"].stringValue;
        wdm.sunset=[element6 attributeForName:@"sunset"].stringValue;
    
        NSArray *date = [wdm.lastBuildDate componentsSeparatedByString:@" "];
        NSString *zoneStr = date[date.count-1];
    
        NSString *isDayNight = [DayJudge judgeDayOrNight:wdm.sunrise :wdm.sunset :zoneStr];
    
        wdm.isDayNight = isDayNight;

        GDataXMLElement *subElements=[[elements elementsForName:@"item"]lastObject];
    
        GDataXMLElement *element7=[[subElements elementsForName:@"geo:lat"]lastObject];
        GDataXMLElement *element8=[[subElements elementsForName:@"geo:long"]lastObject];
    
        GDataXMLElement *element9=[[subElements elementsForName:@"yweather:condition"]lastObject];
            
        NSArray *foreast=[subElements elementsForName:@"yweather:forecast"];
            
        NSMutableArray *arr1=[[NSMutableArray alloc]init];
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        NSMutableArray *arr3=[[NSMutableArray alloc]init];
        NSMutableArray *arr4=[[NSMutableArray alloc]init];
        NSMutableArray *arr5=[[NSMutableArray alloc]init];
        NSMutableArray *arr6=[[NSMutableArray alloc]init];
            
        for (GDataXMLElement *subElement in foreast) {
            
        [arr1 addObject:[subElement attributeForName:@"day"].stringValue];
        [arr2 addObject:[subElement attributeForName:@"low"].stringValue];
        [arr3 addObject:[subElement attributeForName:@"high"].stringValue];
        [arr4 addObject:[subElement attributeForName:@"text"].stringValue];
        [arr5 addObject:[subElement attributeForName:@"code"].stringValue];
        [arr6 addObject:[subElement attributeForName:@"date"].stringValue];
        }
    
        wdm.latitude=element7.stringValue;
        wdm.longitude=element8.stringValue;
            
        wdm.day=[arr1 componentsJoinedByString:@","];
        wdm.low=[arr2 componentsJoinedByString:@","];
        wdm.high=[arr3 componentsJoinedByString:@","];
        wdm.weatherCondition=[arr4 componentsJoinedByString:@","];
        wdm.weatherConditionCode=[arr5 componentsJoinedByString:@","];
        wdm.date=[arr6 componentsJoinedByString:@","];
            
        wdm.curWeatherCondition=[element9 attributeForName:@"text"].stringValue;
        wdm.curWeatherConditionCode=[element9 attributeForName:@"code"].stringValue;
        wdm.curWeatherTemp=[element9 attributeForName:@"temp"].stringValue;
            
        GDataXMLElement *element10=[[elements elementsForName:@"guid"]lastObject];
        wdm.guid=[element10 attributeForName:@"guid"].stringValue;

        return wdm;
}

@end
