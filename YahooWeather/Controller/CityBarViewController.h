//
//  CityBarViewController.h
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"

#import "SidebarController.h"
#import "EditCityViewController.h"

#import "WeatherAssembleModel.h"
#import "WeatherInfoModel.h"

@interface CityBarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
