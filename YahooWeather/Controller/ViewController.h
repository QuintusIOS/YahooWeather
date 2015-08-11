//
//  ViewController.h
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#define Yahoo_Search_CityId @"http://sugg.us.search.yahoo.net/gossip-gl-location/?appid=weather&output=xml&command=%@"
//#define Yahoo_Url @"http://weather.yahooapis.com/forecastrss?w%@&u=c"
#define ARC4RANDOM_MAX      0x100000000

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>

//Utility
#import "YahooDataProcessing.h"
#import "PNColor.h"
#import "ConditonCode.h"

//Model
#import "WeatherInfoModel.h"
#import "WeatherAssembleModel.h"
#import "WeatherDetailModel.h"

//Library
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"

//Controller
#import "SearchViewController.h"
#import "SidebarController.h"

//View
#import "GlassScrollView.h"
#import "customBoxView.h"
#import "UnderLineLabel.h"
#import "AddDotView.h"
#import "scrollTableViewCell.h"
#import "WindTurbineLayer.h"
#import "WindGroundLayer.h"
#import "SunRiseLayer.h"

@interface ViewController : UIViewController <ASIHTTPRequestDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,GlassScrollViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) WeatherInfoModel *infoModel;
@property (nonatomic, strong) WeatherDetailModel *detailModel;
@property (nonatomic, strong) WeatherAssembleModel *assembleModel;
@property (nonatomic, strong) NSMutableDictionary *modelDictionary;
@property (nonatomic, strong) WindGroundLayer *windGroundLayerLeft;
@property (nonatomic, strong) WindGroundLayer *windGroundLayerRight;
@property (nonatomic, strong) CLLocationManager *locationManger;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

