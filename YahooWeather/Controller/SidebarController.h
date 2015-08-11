//
//  SidebarController.h
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarAnimation.h"
#import "WeatherAssembleModel.h"
#import "CityBarViewController.h"

@interface SidebarController : UIViewController

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIViewController *cityBarViewController;

@property (nonatomic, strong) WeatherAssembleModel *model;

@property (nonatomic, assign) NSTimeInterval animateDuration;
@property (nonatomic, assign) BOOL sidebarIsPresenting;
@property (nonatomic, assign) CGFloat visibleWidth;

- (instancetype)initWithContentController:(UIViewController *)contentViewContoller
             cityBarViewController:(UIViewController *)cityBarViewController;

- (void)dismissSidebarViewContoller;
- (void)presentSidebarViewController;

@end

@interface UIViewController(SidebarViewController)

@property (nonatomic, strong, readonly)SidebarController *sidebarViewController;

@end