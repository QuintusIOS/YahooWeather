//
//  SearchResultController.h
//  YahooWeather
//
//  Created by Robbie on 15/4/2.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PNColor.h"
#import "SearchViewController.h"

#import "WeatherInfoModel.h"

@protocol UnwindSegueDelegate

@required
-(void)unwindSegue;

@end

@interface SearchResultController : UITableViewController

@property (nonatomic, weak) id <UnwindSegueDelegate> delegate;

@end

