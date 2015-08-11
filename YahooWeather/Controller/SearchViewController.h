//
//  SearchViewController.h
//  YahooWeather
//
//  Created by Robbie on 15/4/2.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//


#define Yahoo_Search_CityId @"http://sugg.us.search.yahoo.net/gossip-gl-location/?appid=weather&output=xml&command=%@"


#import "SearchResultController.h"

#import "WeatherAssembleModel.h"
#import "WeatherInfoModel.h"

#import "GDataXMLNode.h"

#import "ASIHTTPRequest.h"

@protocol UnwindSegueDelegate

@required
-(void)unwindSegue;

@end

@interface SearchViewController : UIViewController <UISearchBarDelegate,UISearchControllerDelegate,UnwindSegueDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, strong) UISearchController *searchController;


@end

