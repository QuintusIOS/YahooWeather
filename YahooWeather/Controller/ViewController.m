//
//  ViewController.m
//  YahooWeather
//
//  Created by Robbie on 15/3/29.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    
    UIScrollView *_viewScroller;
    
    NSMutableArray *_tabarr;
    NSMutableArray *_glassScrollViewArr;
    NSMutableArray *_customBoxViewArr;
    NSMutableDictionary *_modelDictionary;
    
    NSInteger _ratio;
    NSInteger _curPage;
    
    NSMutableArray *_windTurbineAnimating;
    NSMutableArray *_sunAnimating;
    NSMutableArray *_sunLabelArr;
    NSMutableArray *_windTurbineLeftArr;
    NSMutableArray *_windTurbineRightArr;
    NSMutableArray *_sunArr;
    
    BOOL _cancel;
    NSInteger _addCityNumber;
    NSInteger _deleteCityNumber;
}

#pragma mark Initialization

- (void)myInit {
    
    _assembleModel = [[WeatherAssembleModel alloc]init];
    _tabarr = [[NSMutableArray alloc]init];
    _glassScrollViewArr = [[NSMutableArray alloc]init];
    _customBoxViewArr = [[NSMutableArray alloc]init];

    _modelDictionary = [[NSMutableDictionary alloc]init];
    
    _windTurbineAnimating = [[NSMutableArray alloc] init];
    _sunAnimating = [[NSMutableArray alloc] init];
    _sunLabelArr = [[NSMutableArray alloc] init];
    _windTurbineLeftArr = [[NSMutableArray alloc] init];
    _windTurbineRightArr = [[NSMutableArray alloc] init];
    _sunArr = [[NSMutableArray alloc] init];
    
    _curPage = 0;
    _ratio = 0;
    _cancel = NO;
    _addCityNumber = 0;
    _deleteCityNumber = 0;
}

- (void)setStatusBarAndNavigationBar {
    NSString *isSideBarPresenting = @"NO";
    [[NSUserDefaults standardUserDefaults] setObject:isSideBarPresenting forKey:@"isSideBarPresenting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(segueToSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(0, 0, 28, 28)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(sergueToCityBarVieController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
                                 
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * location = [locations lastObject];
    
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    /*
     //一次以上发出gecoder请求还出现网络错误
     if([self.geocoder isGeocoding]) {
     [self.geocoder cancelGeocode];
     }
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
            if (error) {
                NSLog(@"%@",error);
            }
            if (error.domain == kCLErrorDomain) {
                switch (error.code) {
                    case kCLErrorDenied:
                        NSLog (@"Location Services Denied by User");
                        break;
                    case kCLErrorNetwork:
                        NSLog(@"No Network");
                        break;
                    case kCLErrorGeocodeFoundNoResult:
                        NSLog(@"No Result Found");
                        break;
                    default:
                        NSLog(@"%@", error.localizedDescription);
                        break;
                }
            }
            
            CLPlacemark * place = [placemarks lastObject];
            
            NSDictionary *dict = place.addressDictionary;
            
            NSString *city = [[NSString alloc] init];
            if([dict objectForKey:@"City"] != nil) {
                city = [dict objectForKey:@"City"];
            }
            else {
                city = [dict objectForKey:@"State"];
            }
            
            NSString *name = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",name);
            
            NSURL *searchUrl = [NSURL URLWithString:[NSString stringWithFormat:Yahoo_Search_CityId,name]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:searchUrl];
            request.delegate = self;
            request.tag = 20;
            
            [request startAsynchronous];
        }];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location fail with error!");
}

#pragma mark UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManger = [[CLLocationManager alloc] init];
    self.locationManger.delegate = self;
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManger.distanceFilter = 1000;
    [self.locationManger requestAlwaysAuthorization];
    [self.locationManger startUpdatingLocation];
    
    [self myInit];
    [self setStatusBarAndNavigationBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromSearchResultController:) name:@"SearchResultControllerPassingDataToViewControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFromSearchResultController) name:@"CancelFromSearchResultControllerToViewControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadNumberFromCityBarViewController:) name:@"CityBarViewControllerPassingNumberToViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityNumberFromEditCityViewController:) name:@"AddCityNumberToViewControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCityNumberFromEditCityViewContoller:) name:@"DeleteCityNumberToViewControllerNotification" object:nil];
    
    self.view.backgroundColor = PNMauve;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToCityBarViewController)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    CGFloat blackSideBarWidth = 1.5;
    
    _viewScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    
    [_viewScroller setPagingEnabled:YES];
    [_viewScroller setDelegate:self];
    [_viewScroller setAlwaysBounceHorizontal:NO];
    [_viewScroller setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:_viewScroller];
    
    UIImageView *dog = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CloudWallPaper.png"]];
    dog.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height);
    [_viewScroller addSubview:dog];
}

- (void)viewWillAppear:(BOOL)animated {
    //将assembleModel传递给CityBarViewController
    
    self.sidebarViewController.model = _assembleModel;
    
    if (_cancel) {
        //exchange model from EditCityViewController or cancel from SearchResultController
        int i = 0;
        for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
            NSString *woeid = tempinfoModel.woeid;
            NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",woeid]];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
            request.delegate = self;
            request.tag = 200+i;
            
            [request startAsynchronous];
            
            i++;
        }
        
        NSInteger j = _viewScroller.contentOffset.x / _viewScroller.frame.size.width;
        WeatherInfoModel *model = _assembleModel.cityId[j];
        self.title = model.cityName;
    }
}

- (void)refreshContentView {
    for(UIView *v in _viewScroller.subviews)
    {
        [v removeFromSuperview];
    }
    //从_glassScrollViewArr中找到新创建的glassScrollView
    //_glassScrollViewArr will accumulate,1-3-6,somthing like that
    //it will prevent ,recreate evey glassScrollView after you chose to add city
    for (int i = 0; i < _assembleModel.cityId.count; i++) {
        int sum = 0;
        for (int j = 1; j <= i+1; j++) {
            sum = sum + j;
        }
       GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
        [glassScorllView setFrame:CGRectOffset(self.view.bounds, i*_viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
        
        [glassScorllView.foregroundScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        glassScorllView.delegate = self;
        
        glassScorllView.tag = 500+i;
        
        [_viewScroller addSubview:glassScorllView];
       
        glassScorllView=nil;
    }
    
    CGFloat blackSideBarWidth = 1.5;
    
    [_viewScroller setFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    [_viewScroller setContentSize:CGSizeMake(_assembleModel.cityId.count * _viewScroller.frame.size.width, self.view.frame.size.height-64)];
    [_viewScroller setContentOffset:CGPointMake((_assembleModel.cityId.count - 1)*_viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    
    //再选择过后，_viewScroller跳转到你选择的城市
    WeatherInfoModel *tempInfoModel = [_assembleModel.cityId lastObject];
    self.title = tempInfoModel.cityName;
    
    _curPage = [_assembleModel.cityId count] - 1;
    _ratio = [_assembleModel.cityId count] - 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            int sum = 0;
            for (int j = 1; j <= i + 1; j++) {
                sum = sum + j;
            }
            GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
            if (glassScorllView.foregroundScrollView.contentOffset.y >= 700) {
                WeatherDetailModel *model = [_modelDictionary valueForKey:[NSString stringWithFormat:@"%ld",glassScorllView.tag - 500]];
                
                if (model.speed.integerValue > 0) {
                    //_aniamting array to hold bool to recored if glassScrollView is animating
                    if ([_windTurbineAnimating[sum - 1] isEqualToString:@"NO"]) {
                        _windTurbineAnimating[sum - 1] = @"YES";
                        CABasicAnimation *leftRotation = [CABasicAnimation animation];
                        leftRotation.keyPath = @"transform.rotation";
                        leftRotation.fromValue = 0;
                        leftRotation.toValue = @(2 * M_PI);
                        leftRotation.duration = 54 / model.speed.integerValue;
                        leftRotation.repeatCount = INFINITY;
                        WindTurbineLayer *windTurbineLayerLeft = [_windTurbineLeftArr objectAtIndex:sum - 1];
                        [windTurbineLayerLeft addAnimation:leftRotation forKey:@"leftRotation"];
                        
                        CABasicAnimation *rightRotation = [CABasicAnimation animation];
                        rightRotation.keyPath = @"transform.rotation";
                        rightRotation.fromValue = 0;
                        rightRotation.toValue = @(2 * M_PI);
                        rightRotation.duration = 54 / model.speed.integerValue;
                        rightRotation.repeatCount = INFINITY;
                        WindTurbineLayer *windTurbineLayerRight = [_windTurbineRightArr objectAtIndex:sum - 1];
                        [windTurbineLayerRight addAnimation:rightRotation forKey:@"rightRotation"];
                    }
                }
            } else {
                if ([_windTurbineAnimating[sum - 1] isEqualToString:@"YES"]) {
                    _windTurbineAnimating[sum - 1] = @"NO";
                    WindTurbineLayer *windTurbineLayerLeft = [_windTurbineLeftArr objectAtIndex:sum - 1];
                    WindTurbineLayer *windTurbineLayerRight = [_windTurbineRightArr objectAtIndex:sum - 1];
                    [windTurbineLayerLeft removeAnimationForKey:@"leftRotation"];
                    [windTurbineLayerRight removeAnimationForKey:@"rightRotation"];
                }
            }
            if (glassScorllView.foregroundScrollView.contentOffset.y >= 900) {
                   WeatherDetailModel *model = [_modelDictionary valueForKey:[NSString stringWithFormat:@"%ld",glassScorllView.tag - 500]];
                if (model.isDayNight) {
                    if ([_sunAnimating[sum - 1] isEqualToString:@"NO"]) {
                        _sunAnimating[sum - 1] = @"YES";

                    UILabel *sunLabel = (UILabel *)[_sunLabelArr objectAtIndex:sum - 1];
                    sunLabel.hidden = NO;
                    CGFloat time = ((CGFloat)arc4random() / ARC4RANDOM_MAX);
                    CGFloat xPosiotn = 0;
                    CGFloat yPostion = 0;
                    CGPoint center = CGPointMake(self.view.frame.size.width / 2, 165);
                    if (0 == time) {
                        xPosiotn = 0;
                    }
                    if (time < 1 / 2 && time != 0) {
                        xPosiotn = 94 - cos(time * M_PI) * 94;
                    }
                    if (1 / 2 == time) {
                        xPosiotn = 94;
                    }
                    if (time > 1 / 2 && time != 1) {
                        xPosiotn = 94 + cos(M_PI - time * M_PI) * 94;
                    }
                    if (1 == time) {
                        xPosiotn = 188;
                    }
                    
                    if (0 == time) {
                        yPostion = 0;
                    }
                    if (time < 1 / 2 && time != 0) {
                        yPostion = sin(time * M_PI) * 94;
                    }
                    if (1 / 2 == time) {
                        yPostion = 94;
                    }
                    if (time > 1 / 2 && time != 1) {
                        yPostion = sin(M_PI - time * M_PI) * 94;
                    }
                    if (1 == time) {
                        yPostion = 0;
                    }
                    
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathAddArc(path, nil, center.x, center.y, 94, M_PI,  M_PI + time * M_PI, NO);
                    
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                    animation.keyPath = @"position";
                    animation.path = path;
                    animation.duration = 2.0;
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    animation.calculationMode = kCAAnimationPaced;
                    [sunLabel.layer addAnimation:animation forKey:@"sunRise"];
                    sunLabel.layer.position = CGPointMake(xPosiotn + center.x - 94, center.y - yPostion);
                    SunRiseLayer *sunRiseLayer = [_sunArr objectAtIndex:sum - 1];
                    sunRiseLayer.time = time;
                 }
                }
            }else {
                if ([_sunAnimating[sum - 1] isEqualToString:@"YES"]) {
                    _sunAnimating[sum - 1] = @"NO";
                    UILabel *sunLabel = (UILabel *)[_sunLabelArr objectAtIndex:sum - 1];
                    [sunLabel.layer removeAnimationForKey:@"sunRise"];
                    sunLabel.hidden = YES;
                    SunRiseLayer *sunRiseLayer = [_sunArr objectAtIndex:sum - 1];
                    sunRiseLayer.time = 0;
                }
            }
        }
}

- (void)viewWillLayoutSubviews {
    //载入和旋转时调用subviewLayoutGuide
    for (int i = 0; i < _assembleModel.cityId.count; i++) {
        GlassScrollView *glassScrollView=(GlassScrollView *)[_viewScroller viewWithTag:500+i];
        [glassScrollView subviewLayoutGuide];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.sidebarViewController dismissSidebarViewContoller];
    [self viewWillAppear:YES];
}

#pragma mark Change View Controller
- (void)segueToSearchViewController {
    
   // UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   // SearchViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    SearchViewController *svc = [[SearchViewController alloc] init];
    
    svc.view.backgroundColor = PNBlack;
    
    UINavigationController *snav = [[UINavigationController alloc]initWithRootViewController:svc];
    
    snav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.navigationController presentViewController:snav animated:YES completion:nil];
}

- (void)sergueToCityBarVieController {
    if(self.sidebarViewController.sidebarIsPresenting)
    {
        [self.sidebarViewController dismissSidebarViewContoller];
        _viewScroller.scrollEnabled = YES;
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            int sum = 0;
            for (int j = 1; j <= i+1; j++) {
                sum = sum + j;
            }
            
            GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
            glassScorllView.foregroundScrollView.scrollEnabled = YES;
        }
    }
    else {
        [self.sidebarViewController presentSidebarViewController];
        _viewScroller.scrollEnabled = NO;
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            int sum = 0;
            for (int j = 1; j <= i+1; j++) {
                sum = sum + j;
            }
            
            GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
            glassScorllView.foregroundScrollView.scrollEnabled = NO;
        }
    }
}

- (void)swipeToCityBarViewController {
    if(self.sidebarViewController.sidebarIsPresenting) {
        [self.sidebarViewController dismissSidebarViewContoller];
        _viewScroller.scrollEnabled = YES;
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            int sum = 0;
            for (int j = 1; j <= i+1; j++) {
                sum = sum + j;
            }
            
            GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
            glassScorllView.foregroundScrollView.scrollEnabled = YES;
        }
    }
}


#pragma mark Create and Update Views

- (customBoxView *)customBoxViewWithTagId:(NSInteger)tagId {
    customBoxView *boxView = [[customBoxView alloc]initWithFrame:CGRectMake(0, 0, 375, 1330)];
    
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 350, 110)];
    [boxView.box1 addSubview:tableView1];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.backgroundColor = [UIColor clearColor];
    tableView1.scrollEnabled = NO;
    tableView1.showsVerticalScrollIndicator = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.tag = 2000 + tagId;
    
    UnderLineLabel *label1 = [[UnderLineLabel alloc]initWithFrame:CGRectMake(10, 10, 350, 20)];
    [boxView.box1 addSubview:label1];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"基本信息";
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentLeft;
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 350, 255)];
    [boxView.box2 addSubview:tableView2];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.backgroundColor = [UIColor clearColor];
    tableView2.scrollEnabled = NO;
    tableView2.showsVerticalScrollIndicator = NO;
    tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView2.tag = 3000 + tagId;
    
    UnderLineLabel *label2 = [[UnderLineLabel alloc]initWithFrame:CGRectMake(10, 10, 350, 20)];
    [boxView.box2 addSubview:label2];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"预报";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentLeft;
    
    UITableView *tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(175, 30, 175, 240)];
    [boxView.box3 addSubview:tableView3];
    tableView3.dataSource = self;
    tableView3.delegate = self;
    tableView3.backgroundColor = [UIColor clearColor];
    tableView3.scrollEnabled = NO;
    tableView3.showsVerticalScrollIndicator = NO;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView3.tag = 4000 + tagId;
    
    UnderLineLabel *label3 = [[UnderLineLabel alloc]initWithFrame:CGRectMake(10, 10, 350, 20)];
    [boxView.box3 addSubview:label3];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"详细信息";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentLeft;
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 175, 100)];
    [boxView.box3 addSubview:codeLabel];
    codeLabel.font = [UIFont fontWithName:@"Climacons-Font" size:120];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.textColor = [UIColor whiteColor];
    codeLabel.shadowColor = [UIColor blackColor];
    codeLabel.shadowOffset = CGSizeMake(1, 1);
    //可以从customBoxView中找到他
    codeLabel.tag = 999;
    
    UnderLineLabel *label4 = [[UnderLineLabel alloc] initWithFrame:CGRectMake(10, 10, 350, 20)];
    [boxView.box4 addSubview:label4];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = @"风速和气压";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentLeft;
    
    //windTurbine Animation Layer
    WindTurbineLayer *windTurbineLayerLeft = [[WindTurbineLayer alloc] init];
    windTurbineLayerLeft.position = CGPointMake(50, 100);
    windTurbineLayerLeft.scale = 40;
    self.windGroundLayerLeft = [[WindGroundLayer alloc] init];
    self.windGroundLayerLeft.position = CGPointMake(50, 100);
    self.windGroundLayerLeft.scale = 8.0;
    [_windTurbineLeftArr addObject:windTurbineLayerLeft];
    
    WindTurbineLayer *windTurbineLayerRight = [[WindTurbineLayer alloc] init];
    windTurbineLayerRight.position = CGPointMake(90, 117);
    windTurbineLayerRight.scale = 30;
    self.windGroundLayerRight = [[WindGroundLayer alloc] init];
    self.windGroundLayerRight.position = CGPointMake(90, 117);
    self.windGroundLayerRight.scale = 6.0;
    [_windTurbineRightArr addObject:windTurbineLayerRight];
    
    [boxView.box4.layer addSublayer:windTurbineLayerLeft];
    [boxView.box4.layer addSublayer:self.windGroundLayerLeft];
    [boxView.box4.layer addSublayer:windTurbineLayerRight];
    [boxView.box4.layer addSublayer:self.windGroundLayerRight];
    
    UnderLineLabel *label5 = [[UnderLineLabel alloc] initWithFrame:CGRectMake(10, 10, 350, 20)];
    [boxView.box5 addSubview:label5];
    label5.backgroundColor = [UIColor clearColor];
    label5.text = @"太阳和月亮";
    label5.textColor = [UIColor whiteColor];
    label5.textAlignment = NSTextAlignmentLeft;
    
    //SunRise Animation Layer
    SunRiseLayer *sunRiseLayer = [[SunRiseLayer alloc] init];
    sunRiseLayer.position = CGPointMake(self.view.frame.size.width / 2, 160);
    [_sunArr addObject:sunRiseLayer];
    [boxView.box5.layer addSublayer:sunRiseLayer];
    
    UILabel *sunLabel = [[UILabel alloc] init];
    [_sunLabelArr addObject:sunLabel];
    sunLabel.frame = CGRectMake(self.view.frame.size.width / 2 - 90, 165, 25, 25);
    sunLabel.font = [UIFont fontWithName:@"Climacons-Font" size:30];
    sunLabel.textAlignment = NSTextAlignmentCenter;
    sunLabel.textColor = [UIColor orangeColor];
    sunLabel.text = [NSString stringWithFormat:@"%c",73];
    sunLabel.backgroundColor = [UIColor clearColor];
    sunLabel.layer.position = CGPointMake(self.view.frame.size.width / 2 - 90, 160);
    sunLabel.hidden = YES;
    [boxView.box5 addSubview:sunLabel];
    
    [_customBoxViewArr addObject:boxView];
    
    return boxView;
}

- (void)updateUIWithModel:(WeatherDetailModel *)model withTag:(NSInteger)tag {
    GlassScrollView *glassScrollView = (GlassScrollView *)[_viewScroller viewWithTag:300 + tag];
    customBoxView *boxView = (customBoxView *)glassScrollView.foregroundView;
        
    NSInteger temp = model.curWeatherConditionCode.intValue;
    NSInteger textColorCode = [ConditonCode convertCode:temp];
    if( 73 == textColorCode || 78 == textColorCode)
    {
        boxView.conditionCodeLabel.textColor = [UIColor yellowColor];
    }
    if( 60 == textColorCode || 63 == textColorCode || 88 == textColorCode)
    {
        boxView.conditionCodeLabel.textColor = [UIColor grayColor];
    }
    if( 55 == textColorCode || 51 == textColorCode || 57 == textColorCode)
    {
        boxView.conditionCodeLabel.textColor = PNBlue;
    }
 
    boxView.conditionCodeLabel.text = [NSString stringWithFormat:@"%c",textColorCode];
    boxView.temperatureLabel.text = [NSString stringWithFormat:@"%@°",model.curWeatherTemp];
    boxView.conditionLabel.text = model.curWeatherCondition;
    
    UILabel *codeLabel = (UILabel *)[boxView viewWithTag:999];
    codeLabel.text = [NSString stringWithFormat:@"%c",textColorCode];
    
    NSArray *high = [model.high componentsSeparatedByString:@","];
    NSArray *low = [model.low componentsSeparatedByString:@","];
    boxView.highLabel.text = [NSString stringWithFormat:@"%@°",high[0]];
    boxView.lowLabel.text = [NSString stringWithFormat:@"%@°",low[0]];
    
    UITableView *tableView1 = (UITableView *)[boxView viewWithTag:tag - 200 + 2000];
    UITableView *tableView2 = (UITableView *)[boxView viewWithTag:tag - 200 + 3000];
    UITableView *tableView3 = (UITableView *)[boxView viewWithTag:tag - 200 + 4000];
    [tableView1 reloadData];
    [tableView2 reloadData];
    [tableView3 reloadData];
    
    boxView.box4.windLabelDown.text = [NSString stringWithFormat:@"%@ %@",model.speed,model.speedUnit];
    boxView.box4.pressureLabelDown.text = [NSString stringWithFormat:@"%@ %@",model.pressure,model.pressureUnit];
    
    boxView.box5.sunriseLabel.text = [NSString stringWithFormat:@"%@",model.sunrise];
    boxView.box5.sunsetLabel.text = [NSString stringWithFormat:@"%@",model.sunset];
}

#pragma mark Network

- (void)loadDataFromSearchResultController:(NSNotification *)notification {
    NSDictionary *tempDic = [[NSDictionary alloc]init];
    tempDic = [notification userInfo];
    WeatherInfoModel *tempInfo = [[WeatherInfoModel alloc]init];
    tempInfo = [tempDic valueForKey:@"CityId"];
    [_assembleModel.cityId addObject:tempInfo];
    //将不同WeatherAssembleModel对应给不同request
    
    NSString *isSideBarPresenting = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSideBarPresenting"];
    if ([isSideBarPresenting isEqualToString:@"NO"]) {
        
        //Beacause observeValueForPath is called before viewWillAppear is called
        //Create GlassScrollView do here
        [_customBoxViewArr removeAllObjects];
        
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            GlassScrollView *glassScrollView = [[GlassScrollView alloc] initWithFrame:self.view.frame ViewDistanceFromBottom:200 ForegroundView:[self customBoxViewWithTagId:i]];
            
            [_glassScrollViewArr addObject:glassScrollView];
            
            NSString *animatingW = @"NO";
            [_windTurbineAnimating addObject:animatingW];
            NSString *animatingS = @"NO";
            [_sunAnimating addObject:animatingS];
        }
        
        [self refreshContentView];
        
    int i = 0;
    for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
        NSString *woeid = tempinfoModel.woeid;
        NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",woeid]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
        request.delegate = self;
        request.tag = 200+i;
        
        [request startAsynchronous];
        
        i++;
    }
    }
}

- (void)cancelFromSearchResultController {
    _cancel = YES;
}

- (void)addCityNumberFromEditCityViewController:(NSNotification *)notification {
    NSDictionary *dictionary = [notification userInfo];
    NSString *addCityNumber = [dictionary objectForKey:@"AddCityNumber"];
    _addCityNumber = addCityNumber.integerValue;
    
    //Beacause observeValueForPath is called before viewWillAppear is called
    //Create GlassScrollView do here
    [_customBoxViewArr removeAllObjects];
    for (NSInteger j = _addCityNumber; j >= 1; j--) {
        for (int i = 0; i <= _assembleModel.cityId.count - j; i++) {
            GlassScrollView *glassScrollView = [[GlassScrollView alloc] initWithFrame:self.view.frame ViewDistanceFromBottom:200 ForegroundView:[self customBoxViewWithTagId:i]];
            
            [_glassScrollViewArr addObject:glassScrollView];
            
            NSString *animatingW = @"NO";
            [_windTurbineAnimating addObject:animatingW];
            NSString *animatingS = @"NO";
            [_sunAnimating addObject:animatingS];
        }
    }
    [self refreshContentView];
    
    int i = 0;
    for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
        NSString *woeid = tempinfoModel.woeid;
        NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",woeid]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
        request.delegate = self;
        request.tag = 200+i;
        
        [request startAsynchronous];
        
        i++;
    }
}

- (void)deleteCityNumberFromEditCityViewContoller:(NSNotification *)notification {
    NSDictionary *dictionary = [notification userInfo];
    NSString *deleteCityNumber = [dictionary objectForKey:@"DeleteCityNumber"];
    _deleteCityNumber = deleteCityNumber.integerValue;
    
    //Beacause observeValueForPath is called before viewWillAppear is called
    //Delete GlassScrollView do here
    [_customBoxViewArr removeAllObjects];
    for (NSInteger j = 1; j <= _deleteCityNumber; j++) {
        for (int i = 0; i <= _assembleModel.cityId.count + _deleteCityNumber - j; i++) {
            
            [_glassScrollViewArr removeLastObject];
            
            [_windTurbineAnimating removeLastObject];
            [_sunAnimating removeLastObject];
        }
    }
    [self refreshContentView];
    
    int i = 0;
    for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
        NSString *woeid = tempinfoModel.woeid;
        NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",woeid]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
        request.delegate = self;
        request.tag = 200+i;
        
        [request startAsynchronous];
        
        i++;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    //执行从cllocationmanager得到城市名request后的操作
    if (20 == request.tag) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:[request responseData] error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        NSArray *elements = [rootElement elementsForName:@"s"];
        GDataXMLElement *element = [elements firstObject];
        WeatherInfoModel *tempInfo = [[WeatherInfoModel alloc]init];
        tempInfo.cityName = [element attributeForName:@"k"].stringValue;
        
        NSString *d = [element attributeForName:@"d"].stringValue;
        
        NSRange range = [d rangeOfString:@"woeid"];
        NSString *cityId = [d substringFromIndex:range.location+range.length];
        NSArray *temparr = [cityId componentsSeparatedByString:@"&"];
        cityId = [temparr objectAtIndex:0];
        
        tempInfo.woeid = cityId;
        [_assembleModel.cityId addObject:tempInfo];
        
        NSMutableDictionary *passingVC=[[NSMutableDictionary alloc]init];
        [passingVC setValue:tempInfo forKey:@"locationMessage"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationNotification" object:self userInfo:passingVC];
        
        [_customBoxViewArr removeAllObjects];
        
        for (int i = 0; i < _assembleModel.cityId.count; i++) {
            GlassScrollView *glassScrollView = [[GlassScrollView alloc] initWithFrame:self.view.frame ViewDistanceFromBottom:200 ForegroundView:[self customBoxViewWithTagId:i]];
            
            [_glassScrollViewArr addObject:glassScrollView];
            
            NSString *animatingW = @"NO";
            [_windTurbineAnimating addObject:animatingW];
            NSString *animatingS = @"NO";
            [_sunAnimating addObject:animatingS];
        }
        [self refreshContentView];
        
        int i = 0;
        for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
            NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",tempinfoModel.woeid]];
            //     NSLog(@"%@",weatherUrl);
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
            request.delegate = self;
            request.tag = 200+i;
            
            [request startAsynchronous];
            
            i++;
        }
    }
    
    //将得到气温数据存储入Model
    if (20 != request.tag) {
        self.detailModel=[YahooDataProcessing ProcessData:[request responseData]];
      //  NSLog(@"model is %@",self.detailModel.curWeatherTemp);
        [_modelDictionary setValue:self.detailModel forKey:[NSString stringWithFormat:@"%ld",request.tag - 200]];
    
        [self updateUIWithModel:self.detailModel withTag:request.tag];
    }
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag >= 3000) {
        return 4;
    }else if (tableView.tag < 3000) {
        return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectZero];
        
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label3.backgroundColor = [UIColor clearColor];
        label4.backgroundColor = [UIColor clearColor];
        
        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor whiteColor];
        label3.textColor = [UIColor whiteColor];
        label4.textColor = PNTwitterColor;
        
        label2.textAlignment = NSTextAlignmentLeft;
        label3.textAlignment = NSTextAlignmentLeft;
        label4.textAlignment = NSTextAlignmentLeft;
        
        [label1 setTag:1];
        [label2 setTag:2];
        [label3 setTag:3];
        [label4 setTag:4];
        
        [cell addSubview:label1];
        [cell addSubview:label2];
        [cell addSubview:label3];
        [cell addSubview:label4];
        
        AddDotView *addDotView=[[AddDotView alloc]initWithFrame:CGRectZero];
        [cell setBackgroundView:addDotView];
    }
    
        if (tableView.tag < 3000) {
            WeatherDetailModel *model = [self.modelDictionary valueForKey:[NSString stringWithFormat:@"%ld",tableView.tag - 2000]];

            switch (indexPath.row) {
                case 0: {
                    
                    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
                    [label1 setFrame:CGRectMake(15, 5, 200, 120/3)];

                    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
                    [label2 setFrame:CGRectMake(210, 5, 140, 120/3)];
                    
                    label1.text = [NSString stringWithFormat:@"%@,%@",model.city,model.country];
                    label1.numberOfLines = 0;
                    label1.adjustsFontSizeToFitWidth = YES;
                    
                    NSArray *date = [model.date componentsSeparatedByString:@","];
                    label2.text = [date firstObject];
                    label2.adjustsFontSizeToFitWidth = YES;
                    label2.textAlignment = NSTextAlignmentRight;
                }
                    break;
                    
                case 1: {
                    if (model) {
                        
                        //自定义可滑动的Cell
                        NSString *windStr = [NSString stringWithFormat:@"%@ %@",model.speed,model.speedUnit];
                        NSString *humidityStr = [NSString stringWithFormat:@"%@%%",model.humidity];
                        NSArray *codeArr = @[@"66",model.directionCode,model.humidityCode,@"75",@"74"];
                        NSArray *textArr = @[windStr,model.direction,humidityStr,model.sunrise,model.sunset];
                        
                        scrollTableViewCell *cell =[[scrollTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil codeArr:codeArr textArr:textArr];
                        
                        return cell;
                    }
                }
                
                default:
                    break;
            }
        }else if (tableView.tag >= 3000 && tableView.tag < 4000) {
            WeatherDetailModel *model = [self.modelDictionary valueForKey:[NSString stringWithFormat:@"%ld",tableView.tag - 3000]];
            
            UILabel *label1 = (UILabel *)[cell viewWithTag:1];
            [label1 setFrame:CGRectMake(15, 5, 140, 300/6)];
            
            UILabel *label2 = (UILabel *)[cell viewWithTag:2];
            [label2 setFrame:CGRectMake(150, 5, 280/3, 300/6)];
            
            UILabel *label3 = (UILabel *)[cell viewWithTag:3];
            [label3 setFrame:CGRectMake(270, 5, 40, 300/6)];
            
            UILabel *label4 = (UILabel *)[cell viewWithTag:4];
            [label4  setFrame:CGRectMake(310, 5, 40, 300/6)];
            
            NSArray *date = [model.date componentsSeparatedByString:@","];
            label1.text = date[indexPath.row + 1];
            
            //将ConditionCode转化成天气字体
            NSArray *weatherConditionCode = [model.weatherConditionCode componentsSeparatedByString:@","];
            NSString *code = weatherConditionCode[indexPath.row + 1];
            NSInteger textColorCode = [ConditonCode convertCode:code.intValue];
            label2.text = [NSString stringWithFormat:@"%c",textColorCode];
            
            NSArray *high = [model.high componentsSeparatedByString:@","];
            label3.text = [NSString stringWithFormat:@"%@°",high[indexPath.row + 1]];
            
            NSArray *low = [model.low componentsSeparatedByString:@","];
            label4.text = [NSString stringWithFormat:@"%@°",low[indexPath.row + 1]];
            
             //不同天气对应不同颜色的天气字体
            if( 73 == textColorCode || 78 == textColorCode)
            {
                label2.textColor = [UIColor yellowColor];
            }
            if( 60 == textColorCode || 63 == textColorCode || 88 == textColorCode)
            {
                label2.textColor = [UIColor grayColor];
            }
            if( 55 == textColorCode || 51 == textColorCode || 57 == textColorCode)
            {
                label2.textColor = PNBlue;
            } 
            
            label2.font = [UIFont fontWithName:@"Climacons-Font"size:40];
            label2.textAlignment = NSTextAlignmentCenter;
            
            label3.textAlignment = NSTextAlignmentRight;
            label4.textAlignment = NSTextAlignmentRight;
            label4.textColor = PNTwitterColor;
        } else {
            
            WeatherDetailModel *model = [self.modelDictionary valueForKey:[NSString stringWithFormat:@"%ld",tableView.tag - 4000]];
            
            switch (indexPath.row) {
                case 0: {
                    
                    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
                    [label1 setFrame:CGRectMake(15, 5, 80, 40)];
                    
                    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
                    [label2 setFrame:CGRectMake(95, 5, 80, 40)];
                    
                    label1.text = @"体感温度";
                    label1.adjustsFontSizeToFitWidth = YES;
                    label1.textColor = [UIColor whiteColor];
                    
                    label2.text = [NSString stringWithFormat:@"%@°",model.curWeatherTemp];
                    label2.adjustsFontSizeToFitWidth = YES;
                    label2.textAlignment = NSTextAlignmentRight;
                    label2.textColor = [UIColor whiteColor];
                }
                    break;
                    
                case 1: {
                    
                    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
                    [label1 setFrame:CGRectMake(15, 5, 80, 40)];
                    
                    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
                    [label2 setFrame:CGRectMake(95, 5, 80, 40)];
                    
                    label1.text = @"气压";
                    label1.adjustsFontSizeToFitWidth = YES;
                    label1.textColor = [UIColor whiteColor];
                    
                    label2.text = [NSString stringWithFormat:@"%@ %@",model.pressure,model.pressureUnit];
                    label2.adjustsFontSizeToFitWidth = YES;
                    label2.textAlignment = NSTextAlignmentRight;
                    label2.textColor = [UIColor whiteColor];
                }
                    break;
                    
                case 2: {
                    
                    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
                    [label1 setFrame:CGRectMake(15, 5, 80, 40)];
                    
                    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
                    [label2 setFrame:CGRectMake(95, 5, 80, 40)];
                    
                    label1.text = @"能见度";
                    label1.adjustsFontSizeToFitWidth = YES;
                    label1.textColor = [UIColor whiteColor];
                    
                    label2.text = [NSString stringWithFormat:@"%@ %@",model.visibility,model.distanceUnit];
                    label2.adjustsFontSizeToFitWidth = YES;
                    label2.textAlignment = NSTextAlignmentRight;
                    label2.textColor = [UIColor whiteColor];
                }
                    break;
                    
                case 3: {
                    
                    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
                    [label1 setFrame:CGRectMake(15, 5, 80, 40)];
                    
                    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
                    [label2 setFrame:CGRectMake(95, 5, 80, 40)];
                    
                    label1.text = @"紫外线强度";
                    label1.adjustsFontSizeToFitWidth = YES;
                    label1.textColor = [UIColor whiteColor];
                    
                    label2.text = [NSString stringWithFormat:@"%@",model.rising];
                    label2.adjustsFontSizeToFitWidth = YES;
                    label2.textAlignment = NSTextAlignmentRight;
                    label2.textColor = [UIColor whiteColor];
                }
                    break;
                default:
                    break;
            }
        }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag < 3000) {
        switch (indexPath.row) {
            case 0:
                return 44;
                break;
            case 1:
                return 60;
                break;
                
            default:
                break;
        }
    }
    return 48;
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //将navigation tittle 设为当前显示城市名称
    NSInteger ratio = scrollView.contentOffset.x/_viewScroller.frame.size.width;
    
    if (ratio > _ratio) {
        _curPage++;
    }else if(ratio < _ratio) {
        _curPage--;
    }
    
    WeatherInfoModel *tempInfoModel = _assembleModel.cityId[_curPage];
    self.title = tempInfoModel.cityName;
    _ratio = ratio;
}

#pragma mark GlassScrollView Delegate

- (void)pullToUpdateUI {
    
    //刷新已有城市数据
    int i = 0;
    for (WeatherInfoModel *tempinfoModel in _assembleModel.cityId) {
        NSString *woeid = tempinfoModel.woeid;
        NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w%@&u=c",woeid]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:weatherUrl];
        request.delegate = self;
        request.tag = 200+i;
        
        [request startAsynchronous];
        
        i++;
    }
}

#pragma mark set viewScroller contentoffset
- (void)LoadNumberFromCityBarViewController:(NSNotification *)notification {
    NSDictionary *passingNumber = notification.userInfo;
    NSString *cityNumber = [passingNumber objectForKey:@"cityNumber"];
    [_viewScroller setContentOffset:CGPointMake((cityNumber.intValue - 1) *_viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    _viewScroller.scrollEnabled = YES;
    for (int i = 0; i < _assembleModel.cityId.count; i++) {
        int sum = 0;
        for (int j = 1; j <= i+1; j++) {
            sum = sum + j;
        }
            
        GlassScrollView *glassScorllView=[_glassScrollViewArr objectAtIndex:sum - 1];
        glassScorllView.foregroundScrollView.scrollEnabled = YES;
    }
    WeatherInfoModel *infoModel = _assembleModel.cityId[cityNumber.integerValue - 1];
    self.title = infoModel.cityName;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
