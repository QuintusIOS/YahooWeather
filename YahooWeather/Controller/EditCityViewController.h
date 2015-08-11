//
//  EditCityViewController.h
//  YahooWeather
//
//  Created by Robbie on 15/4/27.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"

#import "WeatherAssembleModel.h"
#import "WeatherInfoModel.h"

#import "SearchViewController.h"

@interface EditCityViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
