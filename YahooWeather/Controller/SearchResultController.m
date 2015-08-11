//
//  SearchResultController.m
//  YahooWeather
//
//  Created by Robbie on 15/4/2.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "SearchResultController.h"

@implementation SearchResultController {
    NSMutableArray *passingCityId;
    NSMutableArray *passingCityName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myInit];
    self.view.backgroundColor= PNBlack;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView:) name:@"SearchViewControllerPassingDataToSearchResultViewControllerNotification" object:nil];
    //去除多余的tableview的下划线
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResultSearchCell"];
}

- (void)myInit {
    passingCityId=[[NSMutableArray alloc]init];
    passingCityName=[[NSMutableArray alloc]init];
}

- (void)updateView:(NSNotification *)notification {
    NSDictionary *temp=[notification userInfo];
    NSMutableArray *passingCityNameHelper = [[NSMutableArray alloc] init];
    NSMutableArray *passingCityIdHelper = [[NSMutableArray alloc] init];

    NSArray *temparr=[temp valueForKey:@"CityName"];
    for (WeatherInfoModel *infoModel in temparr) {
        [passingCityNameHelper addObject:infoModel.cityName];
        [passingCityIdHelper addObject:infoModel.woeid];
    }
    passingCityName = passingCityNameHelper;
    passingCityId = passingCityIdHelper;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return passingCityName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultSearchCell" forIndexPath:indexPath];
    cell.backgroundColor= PNBlack;
    cell.textLabel.textColor= [UIColor whiteColor];
    
    NSString *city=[passingCityName objectAtIndex:indexPath.row];
    
    cell.textLabel.text=city;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //使用delegate unwind回View controller
    [self.delegate unwindSegue];
    NSString *cityId=[passingCityId objectAtIndex:indexPath.row];
    NSString *cityName=[passingCityName objectAtIndex:indexPath.row];
    WeatherInfoModel *tempModel=[[WeatherInfoModel alloc]init];
    tempModel.woeid=cityId;
    tempModel.cityName=cityName;
    NSMutableDictionary *passingVC=[[NSMutableDictionary alloc]init];
    [passingVC setValue:tempModel forKey:@"CityId"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchResultControllerPassingDataToViewControllerNotification" object:self userInfo:passingVC];
}

- (void)dealloc {
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
