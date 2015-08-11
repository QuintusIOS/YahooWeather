//
//  SidebarController.m
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "SidebarController.h"

static const CGFloat kAnimateDuration = 0.3f;
static const CGFloat kVisableWidth = 280.0f;

@interface SidebarController ()

@property (nonatomic, strong) UIViewController *contentContainerViewController;
@property (nonatomic, strong) UIViewController *cityBarContainerViewController;

- (void)showSidebarViewController;
- (void)hideSidebarViewController;

@end

@implementation SidebarController

#pragma mark UIViewController Lifecycle
- (instancetype)initWithContentController:(UIViewController *)contentViewContoller cityBarViewController:(UIViewController *)cityBarViewController {
    self = [super init];
    if (self) {
        _contentContainerViewController = [[UIViewController alloc] init];
        _cityBarContainerViewController = [[UIViewController alloc] init];
        
        _contentViewController = contentViewContoller;
        _cityBarViewController = cityBarViewController;
        
        _animateDuration = kAnimateDuration;
        _visibleWidth = kVisableWidth;
        _sidebarIsPresenting = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    NSAssert(self.contentViewController != nil, @"contentViewController is not set");
    
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //Parent Sidebar View Controller
    [self addChildViewController:self.cityBarContainerViewController];
    [self.view addSubview:self.cityBarContainerViewController.view];
    [self.cityBarContainerViewController didMoveToParentViewController:self];
    self.cityBarContainerViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.cityBarContainerViewController.view.hidden = YES;
    
    //Child Sidebar View Controller
    [self.cityBarContainerViewController addChildViewController:self.cityBarViewController];
    [self.cityBarContainerViewController.view addSubview:self.cityBarViewController.view];
    [self.cityBarViewController didMoveToParentViewController:self.cityBarContainerViewController];
    
    //Parent Content View Controller
    [self addChildViewController:self.contentContainerViewController];
    [self.view addSubview:self.contentContainerViewController.view];
    [self.contentContainerViewController didMoveToParentViewController:self];
    
    //Child Content View Controller
    [self.contentContainerViewController addChildViewController:self.contentViewController];
    [self.contentContainerViewController.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self.contentContainerViewController];
}

#pragma mark UIViewController Setters
- (void)setContentViewController:(UIViewController *)contentViewController {
    
    //Old View Controller
    UIViewController *oldViewController = self.contentViewController;
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    //New View Controller
    UIViewController *newViewController = contentViewController;
    [self.contentContainerViewController addChildViewController:newViewController];
    [self.contentContainerViewController.view addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self.contentContainerViewController];
    
    _contentViewController = newViewController;
}

- (void)setCityBarViewController:(UIViewController *)cityBarViewController {
    
    //Old View Controller
    UIViewController *oldViewController = self.cityBarViewController;
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    //New View Controller
    UIViewController *newViewController = cityBarViewController;
    [self.cityBarContainerViewController addChildViewController:newViewController];
    [self.cityBarContainerViewController.view addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self.cityBarContainerViewController];
    
    _cityBarViewController = newViewController;
}

#pragma mark Public Method
- (void)dismissSidebarViewContoller {
    [self hideSidebarViewController];
}

- (void)presentSidebarViewController {
    NSAssert(self.cityBarViewController != nil, @"cityBarViewController is not set");
    [self showSidebarViewController];
}

#pragma mark Private Method
- (void)showSidebarViewController {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //Due to time difference ,excute KVO first.
    self.sidebarIsPresenting = YES;
    
    self.cityBarContainerViewController.view.hidden = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSString *isSideBarPresenting = @"YES";
    [[NSUserDefaults standardUserDefaults] setObject:isSideBarPresenting forKey:@"isSideBarPresenting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SidebarAnimation animateContentView:self.contentContainerViewController.view
                             sidebarView:self.cityBarContainerViewController.view
                            visableWidth:self.visibleWidth
                                duration:self.animateDuration
                              completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)hideSidebarViewController {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //Due to time difference ,excute KVO first.
    self.sidebarIsPresenting = NO;
    
    NSString *isSideBarPresenting = @"NO";
    [[NSUserDefaults standardUserDefaults] setObject:isSideBarPresenting forKey:@"isSideBarPresenting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SidebarAnimation reverseAnimateContentView:self.contentContainerViewController.view
                                    sidebarView:self.cityBarContainerViewController.view
                                   visableWidth:self.visibleWidth
                                       duration:self.animateDuration
                                     completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end

#pragma mark UIViewController Category

@implementation UIViewController(SidebarViewController)

- (SidebarController *)sidebarViewController {
    if ([self.parentViewController.parentViewController isKindOfClass:[SidebarController class]]) {
        return (SidebarController *)self.parentViewController.parentViewController;
    }else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
             [self.parentViewController.parentViewController.parentViewController isKindOfClass:[SidebarController class]]) {
        return (SidebarController *)self.parentViewController.parentViewController.parentViewController;
    }
    return nil;
}

@end
