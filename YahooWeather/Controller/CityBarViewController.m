//
//  CityBarViewController.m
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "CityBarViewController.h"

@implementation CityBarViewController {
    WeatherAssembleModel *_assmebleModel;
    
    BOOL _showMoreCitys;
    BOOL _animateWithVisabelCell;

    UIButton *_moreButton;
    UILabel *_cityLabel;
    UIImageView *_horizontalLineImage1;
    UIImageView *_horizontalLineImage2;
    UIImageView *_yahooImage;
}

#pragma mark View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PNButtonGrey;
    _showMoreCitys = NO;
    _animateWithVisabelCell = NO;
    
    _assmebleModel = [[WeatherAssembleModel alloc]init];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(280, self.view.frame.size.height);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    _horizontalLineImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Horizontal Line"]];
    _horizontalLineImage1.frame = CGRectZero;
    _horizontalLineImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Horizontal Line"]];
    _horizontalLineImage2.frame = CGRectZero;
    _yahooImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Yahoo"]];
    _yahooImage.frame = CGRectZero;
    [self.scrollView addSubview:_horizontalLineImage1];
    [self.scrollView addSubview:_horizontalLineImage2];
    [self.scrollView addSubview:_yahooImage];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor = PNButtonGrey;
    self.tableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.tableView];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectZero;
    UIImageView *markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"More"]];
    markerImageView.frame = CGRectMake(20, 10, 30, 30);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Expand Arrow"]];
    arrowImageView.frame = CGRectMake(220, 15, 20, 20);
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 140, 20)];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.text = [NSString stringWithFormat:@"显示其他%lu个项目",(unsigned long)(_assmebleModel.cityId.count - 2)];
    [_moreButton addTarget:self action:@selector(displayMoreCities) forControlEvents:UIControlEventTouchDown];
    
    [_moreButton addSubview:arrowImageView];
    [_moreButton addSubview:markerImageView];
    [_moreButton addSubview:_cityLabel];
    [_scrollView addSubview:_moreButton];
    
    [self.sidebarViewController addObserver:self forKeyPath:@"sidebarIsPresenting" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdate:) name:@"LocationNotification" object:nil ];
}

- (void)locationUpdate:(NSNotification *)notification {
    NSLog(@"location update");
    NSDictionary *tempDic = [[NSDictionary alloc]init];
    tempDic = [notification userInfo];
    WeatherInfoModel *tempInfo = [[WeatherInfoModel alloc]init];
    tempInfo = [tempDic valueForKey:@"locationMessage"];
    [_assmebleModel.cityId addObject:tempInfo];
    NSLog(@"count is %lu",(unsigned long)_assmebleModel.cityId.count);

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    _assmebleModel = self.sidebarViewController.model;
    
    //重新计算tableview和button位置,有两种情况，模型是否大于3，是否在拉开状态下
    if (!_showMoreCitys) {
        [_horizontalLineImage1 setFrame:CGRectMake(20, 155 + 50 * (_assmebleModel.cityId.count + 1), 280, 10)];
        [_horizontalLineImage2 setFrame:CGRectMake(20, 160 + 50 * (_assmebleModel.cityId.count + 1), 260, 10)];
        [_yahooImage setFrame:CGRectMake(90, 170 + 50 * (_assmebleModel.cityId.count + 1), 80, 80)];
        _yahooImage.layer.cornerRadius = _yahooImage.frame.size.width / 2;
        _yahooImage.clipsToBounds = YES;
        if (_assmebleModel.cityId.count < 3) {
            [self.tableView setFrame:CGRectMake(0, 150, 280, 50 * (_assmebleModel.cityId.count + 1))];
            _moreButton.hidden = YES;
        }else if (_assmebleModel .cityId.count >= 3){
            [self.tableView setFrame:CGRectMake(0, 150, 280, 150)];
            _moreButton.hidden = NO;
            [_moreButton setFrame:CGRectMake(0, 300, 280, 50)];
            [_horizontalLineImage1 setFrame:CGRectMake(20, 355, 280, 10)];
            [_horizontalLineImage2 setFrame:CGRectMake(20, 360, 280, 10)];
            [_yahooImage setFrame:CGRectMake(90, 370, 80, 80)];
            _yahooImage.layer.cornerRadius = _yahooImage.frame.size.width / 2;
            _yahooImage.clipsToBounds = YES;
            }
    }
    
    if (_showMoreCitys) {
        [self.tableView setFrame:CGRectMake(0, 150 - 50 * (_assmebleModel.cityId.count / 4), 250, 50 * (_assmebleModel.cityId.count + 1))];
        _moreButton.hidden = NO;
        [_moreButton setFrame:CGRectMake(0, 300 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2),250, 50)];
        [_horizontalLineImage1 setFrame:CGRectMake(20, 355 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 280, 10)];
        [_horizontalLineImage2 setFrame:CGRectMake(20, 360 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 260, 10)];
        [_yahooImage setFrame:CGRectMake(90, 370 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 80, 80)];
        _yahooImage.layer.cornerRadius = _yahooImage.frame.size.width / 2;
        _yahooImage.clipsToBounds = YES;
    }
    [self.tableView reloadData];
    _cityLabel.text = [NSString stringWithFormat:@"显示其他%lu个项目",(unsigned long)(_assmebleModel.cityId.count - 2)];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.sidebarViewController dismissSidebarViewContoller];
}

#pragma mark UITable View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_showMoreCitys) {
        if (_assmebleModel.cityId.count < 2) {
            return _assmebleModel.cityId.count + 1;
        }else {
            return 3;
        }
    }else {
        return _assmebleModel.cityId.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellId = @"CityBarCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (0 == indexPath.row) {
        for (UIView *cellSubViews in cell.subviews) {
            [cellSubViews removeFromSuperview];
        }
        UIImageView *markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Map Marker"]];
        markerImageView.frame = CGRectMake(20, 5, 30, 30);
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 80, 20)];
        cityLabel.textColor = [UIColor whiteColor];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.text = @"编辑地点";
        [cell addSubview:markerImageView];
        [cell addSubview:cityLabel];
    }
    if (0 != indexPath.row) {
        for (UIView *cellSubViews in cell.subviews) {
            [cellSubViews removeFromSuperview];
        }
        UIImageView *markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Marker"]];
        markerImageView.frame = CGRectMake(20, 5, 30, 30);
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 120, 20)];
        cityLabel.textColor = [UIColor whiteColor];
        cityLabel.backgroundColor = [UIColor clearColor];
        WeatherInfoModel *infoModel = _assmebleModel.cityId[indexPath.row - 1];
        cityLabel.text = infoModel.cityName;
        [cell addSubview:markerImageView];
        [cell addSubview:cityLabel];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark UITable View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.row) {
        EditCityViewController *edvc = [[EditCityViewController alloc] init];
        [self presentViewController:edvc animated:YES completion:nil];
        NSDictionary *passingModel = [NSDictionary dictionaryWithObject:_assmebleModel forKey:@"assmebelModel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityBarViewControllerPassingDataToEditCityViewControllerNotification" object:self userInfo:passingModel];
    } else {
        NSString *cityNumber = [NSString stringWithFormat:@"%ld",indexPath.row];
        NSDictionary *passingNumber = [NSDictionary dictionaryWithObject:cityNumber forKey:@"cityNumber"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityBarViewControllerPassingNumberToViewController" object:self userInfo:passingNumber];
        [self.sidebarViewController dismissSidebarViewContoller];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark VisabelCell Animate

- (void)prepareForVisabelCellAnimate {
    for (int i = 0; i < [self.tableView.visibleCells count]; i++) {
        UITableViewCell *visableCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        visableCell.alpha = 0.0f;
        visableCell.frame = CGRectMake(-CGRectGetWidth(visableCell.bounds), visableCell.frame.origin.y, CGRectGetWidth(visableCell.bounds), CGRectGetHeight(visableCell.bounds));
    }
}

- (void)animateVisableCell {
    for (int i = 0; i < [self.tableView.visibleCells count]; i++) {
        UITableViewCell *visabelCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        visabelCell.alpha = 1.0f;
        [UIView animateWithDuration:0.5f delay:i * 0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            visabelCell.frame = CGRectMake(0.0f, visabelCell.frame.origin.y, CGRectGetWidth(visabelCell.bounds), CGRectGetHeight(visabelCell.bounds));
        } completion:nil];
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    if (!_showMoreCitys && [self.tableView.visibleCells count] == 3 && [_assmebleModel.cityId count] != 2) {
        animation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_yahooImage.frame.origin.x, _yahooImage.frame.origin.y - 170 - 200) radius:90 startAngle:0 endAngle:M_PI clockwise:YES].CGPath;
    }else if (!_showMoreCitys && [self.tableView.visibleCells count] == 3 && [_assmebleModel.cityId count] == 2) {
        animation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_yahooImage.frame.origin.x, _yahooImage.frame.origin.y - 170 - 150) radius:90 startAngle:0 endAngle:M_PI clockwise:YES].CGPath;
    }
    else if(_showMoreCitys && [self.tableView.visibleCells count] == 4) {
                animation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_yahooImage.frame.origin.x, _yahooImage.frame.origin.y - 170 - 250) radius:90 startAngle:0 endAngle:M_PI clockwise:YES].CGPath;
    }else {
    animation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_yahooImage.frame.origin.x, _yahooImage.frame.origin.y - 170 - 50 * [self.tableView.visibleCells count]) radius:90 startAngle:0 endAngle:M_PI clockwise:YES].CGPath;
    }
    animation.duration = 1.0;
    animation.additive = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [_yahooImage.layer addAnimation:animation forKey:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //new valueForKey is 1 or 0,it always be 1 after convert to Bool animate
    //BOOL animate = [change valueForKey:@"new"];
    //if (animate) {
    //    NSLog(@"%i",animate);
    //}
    
    _animateWithVisabelCell = !_animateWithVisabelCell;
    
    if (_animateWithVisabelCell) {
        [self prepareForVisabelCellAnimate];
        [self animateVisableCell];
    }
}

#pragma mark Click Button

- (void)displayMoreCities {
    if (!_showMoreCitys) {
        //放大动画
        [UIView animateWithDuration:0.05
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.tableView setAlpha:0.65];
                             [_moreButton setAlpha:0];
                             [_horizontalLineImage1 setAlpha:0.65];
                             [_horizontalLineImage2 setAlpha:0.65];
                             [_yahooImage setAlpha:0.65];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  CGAffineTransform beginTransform = CGAffineTransformMakeScale(1, 2);
                                                  [self.tableView setTransform:beginTransform];
                                                  [_moreButton setTransform:beginTransform];
                                                  [_horizontalLineImage1 setTransform:beginTransform];
                                                  [_horizontalLineImage2 setTransform:beginTransform];
                                                  [_yahooImage setTransform:beginTransform];
                                                  CGAffineTransform endTransform = CGAffineTransformMakeScale(1, 1);
                                                  [self.tableView setTransform:endTransform];
                                                  [_moreButton setTransform:endTransform];
                                                  [_horizontalLineImage1 setTransform:endTransform];
                                                  [_horizontalLineImage2 setTransform:endTransform];
                                                  [_yahooImage setTransform:endTransform];
                                                  
                                                  [self.tableView setFrame:CGRectMake(0, 150 - 50 * (_assmebleModel.cityId.count / 4), 280, 50 * (_assmebleModel.cityId.count + 1))];
                                                  [_moreButton setFrame:CGRectMake(0, 300 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2),280, 50)];
                                                  [_horizontalLineImage1 setFrame:CGRectMake(20, 355 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 280, 10)];
                                                  [_horizontalLineImage2 setFrame:CGRectMake(20, 360 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 260, 10)];
                                                  [_yahooImage setFrame:CGRectMake(90, 370 - 50 * (_assmebleModel.cityId.count / 4) + 50 * (_assmebleModel.cityId.count - 2), 80, 80)];
                                                  _yahooImage.layer.cornerRadius = _yahooImage.frame.size.width / 2;
                                                  _yahooImage.clipsToBounds = YES;
                                                  
                                                  
                                                  [self.scrollView setContentSize:CGSizeMake(280, self.scrollView.frame.size.height + 50 * _assmebleModel.cityId.count)];
                                                  [_moreButton setAlpha:0.5];
                                                  [_horizontalLineImage1 setAlpha:1.0];
                                                  [_horizontalLineImage2 setAlpha:1.0];
                                                  [_yahooImage setAlpha:1.0];
                                                  [self.tableView setAlpha:1.0];
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.05
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveEaseIn
                                                                   animations:^{
                                                      [_moreButton setAlpha:1.0];
                                                  }completion:NULL];
                                              }];
                         }];
        _showMoreCitys = YES;
        [self.tableView reloadData];
        
        //重置button
        for (UIView *view in _moreButton.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"More"]];
        markerImageView.frame = CGRectMake(20, 10, 30, 30);
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Collapse Arrow"]];
        arrowImageView.frame = CGRectMake(220, 15, 20, 20);
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 140, 20)];
        cityLabel.textColor = [UIColor whiteColor];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.text = [NSString stringWithFormat:@"显示更少内容"];
        
        [_moreButton addSubview:arrowImageView];
        [_moreButton addSubview:markerImageView];
        [_moreButton addSubview:cityLabel];
        
    }else {
        
        //重置button
        for (UIView *view in _moreButton.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"More"]];
        markerImageView.frame = CGRectMake(20, 10, 30, 30);
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Expand Arrow"]];
        arrowImageView.frame = CGRectMake(220, 15, 20, 20);
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 140, 20)];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = [NSString stringWithFormat:@"显示其他%lu个项目",(unsigned long)(_assmebleModel.cityId.count - 2)];
        [_moreButton addTarget:self action:@selector(displayMoreCities) forControlEvents:UIControlEventTouchDown];
        
        [_moreButton addSubview:arrowImageView];
        [_moreButton addSubview:markerImageView];
        [_moreButton addSubview:_cityLabel];
        
        //缩回动画
        [UIView animateWithDuration:0.05
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.tableView setAlpha:0.65];
                             [_moreButton setAlpha:0.65];
                             [_horizontalLineImage1 setAlpha:0.65];
                             [_horizontalLineImage2 setAlpha:0.65];
                             [_yahooImage setAlpha:0.65];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  CGAffineTransform beginTransform =CGAffineTransformMakeScale(1, 2);
                                                  [self.tableView setTransform:beginTransform];
                                                  [_moreButton setTransform:beginTransform];
                                                  [_horizontalLineImage1 setTransform:beginTransform];
                                                  [_horizontalLineImage2 setTransform:beginTransform];
                                                  [_yahooImage setTransform:beginTransform];
                                                  CGAffineTransform endTransform = CGAffineTransformMakeScale(1, 1);
                                                  [self.tableView setTransform:endTransform];
                                                  [_moreButton setTransform:endTransform];
                                                  [_horizontalLineImage1 setTransform:endTransform];
                                                  [_horizontalLineImage2 setTransform:endTransform];
                                                  [_yahooImage setTransform:endTransform];
                                                  [self.tableView setFrame:CGRectMake(0, 150, 280, 150)];
                                                  [_moreButton setFrame:CGRectMake(0, 300, 280, 50)];
                                                  [_horizontalLineImage1 setFrame:CGRectMake(20, 355, 280, 10)];
                                                  [_horizontalLineImage2 setFrame:CGRectMake(20, 360, 280, 10)];
                                                  [_yahooImage setFrame:CGRectMake(90, 370, 80, 80)];
                                                  _yahooImage.layer.cornerRadius = _yahooImage.frame.size.width / 2;
                                                  _yahooImage.clipsToBounds = YES;
                                                  [self.scrollView setContentSize:CGSizeMake(280, self.scrollView.frame.size.height + 50 * _assmebleModel.cityId.count)];
                                                  [_horizontalLineImage1 setAlpha:1.0];
                                                  [_horizontalLineImage2 setAlpha:1.0];
                                                  [_yahooImage setAlpha:1.0];
                                                  [self.tableView setAlpha:1.0];
                                                  [_moreButton setAlpha:1.0];
                                              }
                                              completion:NULL];
                         }];
        _showMoreCitys = NO;
        //To make city marker look like swallowed up
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
