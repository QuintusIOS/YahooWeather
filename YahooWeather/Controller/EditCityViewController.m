//
//  EditCityViewController.m
//  YahooWeather
//
//  Created by Robbie on 15/4/27.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "EditCityViewController.h"

@implementation EditCityViewController {
    WeatherAssembleModel *_assmbelModel;
    WeatherInfoModel *_infoModel;
    int _cityNumber;
}

#pragma mark ViewController Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = PNBlack;
    
    UIView *containerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    containerView.backgroundColor = PNButtonGrey;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(segueToSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 26, 28, 28)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 26, 40, 28)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton addTarget:self action:@selector(dismissEditCityViewController) forControlEvents:UIControlEventTouchUpInside];
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 20, 40, 40)];
    status.text = @"城市";
    [containerView addSubview:rightButton];
    [containerView addSubview:leftButton];
    [containerView addSubview:status];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = PNBlack;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:containerView];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromCityBarViewController:) name:@"CityBarViewControllerPassingDataToEditCityViewControllerNotification" object:nil];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureRecognize:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark Notification From City Bar View Controller
- (void)loadDataFromCityBarViewController:(NSNotification *)notification {
    NSDictionary *temp = [notification userInfo];
    _assmbelModel = [temp objectForKey:@"assmebelModel"];
    _cityNumber = (int)_assmbelModel.cityId.count;
}

#pragma mark Segue And Dismiss
- (void)segueToSearchViewController {
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //SearchViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    SearchViewController *svc = [[SearchViewController alloc] init];
    svc.view.backgroundColor = PNBlack;
    
    UINavigationController *snav = [[UINavigationController alloc]initWithRootViewController:svc];
    
    snav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self presentViewController:snav animated:YES completion:nil];
}

- (void)dismissEditCityViewController {
    if (_assmbelModel.cityId.count == _cityNumber) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelFromSearchResultControllerToViewControllerNotification" object:self];
    }
    if (_assmbelModel.cityId.count > _cityNumber) {
        NSString *addCityNumber = [NSString stringWithFormat:@"%lu",_assmbelModel.cityId.count - _cityNumber];
        NSDictionary *tempCityNumber=[NSDictionary dictionaryWithObject:addCityNumber forKey:@"AddCityNumber"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddCityNumberToViewControllerNotification" object:self userInfo:tempCityNumber];
    }
    if (_assmbelModel.cityId.count < _cityNumber) {
        NSString *deleteCityNumber = [NSString stringWithFormat:@"%lu",_cityNumber - _assmbelModel.cityId.count];
        NSDictionary *tempCityNumber=[NSDictionary dictionaryWithObject:deleteCityNumber forKey:@"DeleteCityNumber"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteCityNumberToViewControllerNotification" object:self userInfo:tempCityNumber];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assmbelModel.cityId.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"editCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 200, 34)];
        WeatherInfoModel *temp = _assmbelModel.cityId[indexPath.row];
        cityName.text = temp.cityName;
        cityName.textColor = [UIColor whiteColor];
        [cell addSubview:cityName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = PNBlack;
    return cell;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_assmbelModel.cityId removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark Long Press Gesture 
- (void)longGestureRecognize:(UILongPressGestureRecognizer *)longPress {
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    UIGestureRecognizerState state = longPress.state;
    static UIView *snapShotView = nil;
    static NSIndexPath *sourcePath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourcePath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                snapShotView = [self customSnapShotViewFromInputView:cell];
                
                __block CGPoint center = cell.center;
                snapShotView.center = cell.center;
                snapShotView.alpha = 0.0;
                [self.tableView addSubview:snapShotView];
                
                [UIView animateWithDuration:0.25f animations:^{
                    center.y = location.y;
                    snapShotView.center = center;
                    snapShotView.alpha = 0.98;
                    snapShotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    
                    for (UIView *view in cell.subviews) {
                        view.alpha = 0.0;
                    }
                }];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapShotView.center;
            center.y = location.y;
            snapShotView.center = center;
            
            if (indexPath && indexPath != sourcePath) {
                [_assmbelModel.cityId exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourcePath.row];
                [self.tableView moveRowAtIndexPath:sourcePath toIndexPath:indexPath];
                
                sourcePath = indexPath;
            }
        }
            break;
            
        default: {
            UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:sourcePath];
            
            [UIView animateWithDuration:0.25f animations:^{
                snapShotView.center = cell.center;
                snapShotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                snapShotView.alpha = 0.0;
                
                for (UIView *view in cell.subviews) {
                    view.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
                [snapShotView removeFromSuperview];
                snapShotView = nil;
            }];
        }
            break;
    }
}

- (UIView *)customSnapShotViewFromInputView:(UIView *)inputView {
    UIView *snapShotView = [inputView snapshotViewAfterScreenUpdates:YES];
    snapShotView.layer.masksToBounds = NO;
    snapShotView.layer.cornerRadius = 0.0;
    snapShotView.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapShotView.layer.shadowRadius = 5.0;
    snapShotView.layer.shadowOpacity = 0.4;
    return snapShotView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
