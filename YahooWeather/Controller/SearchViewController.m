//
//  SearchViewController.m
//  YahooWeather
//
//  Created by Robbie on 15/4/2.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController {
    NSMutableDictionary *tabarr;
    NSTimer *timer;
}

- (void)myInit {
    
    tabarr=[[NSMutableDictionary alloc]init];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myInit];

    //SearchResultController *src=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultController"];
    SearchResultController *src = [[SearchResultController alloc] init];
    src.delegate=self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:src];
    
    self.searchController.delegate=self;
    self.searchController.searchBar.delegate=self;
    
    self.searchController.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.navigationItem.titleView=self.searchController.searchBar;
    
    self.searchController.dimsBackgroundDuringPresentation=NO;
    self.definesPresentationContext=YES;
    
    self.searchController.searchBar.placeholder=@"请输入城市名称";
    UITextField *searchField=[self.searchController.searchBar valueForKey:@"_searchField"];
    searchField.textColor=[UIColor whiteColor];
    
    //设置cancelbutton字体为取消
    [self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    
    //设置cancelbutton字体为白色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
}
    
#pragma Unwind Segue Delegate
- (void)unwindSegue {
    [self.searchController.searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma Search Bar Delegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //[self getCityIdByCityName:searchBar.text];
    [self getCityIdByCityName:searchBar.text];
}

//update SearchResultController with your input in evey 0.5 second
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(createCityNameWithNSTimer:)
                                           userInfo:searchText
                                            repeats:NO];
}

- (void)createCityNameWithNSTimer:(NSTimer *)nsTimer {
 NSString *cityName = nsTimer.userInfo;
 [self getCityIdByCityName:cityName];
 }


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CancelFromSearchResultControllerToViewControllerNotification" object:self];
    [self unwindSegue];
}


#pragma Load NetWork

-(void)getCityIdByCityName:(NSString *)cityName {
    
    //从searchbar得到的城市名发起request
    //when your input is blank,still start a request to update tableView
    //if (cityName) {
        NSString *name=[cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *nameUrl=[NSURL URLWithString:[NSString stringWithFormat:Yahoo_Search_CityId,name]];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nameUrl];
        request.tag=10;
        
        //如果使用request.delegate，没有添加城市而unwind，会出现delegate已经释放，而ASIHTTPRequest不知道的bug
        //直接使用block就没有问题了，或者在viewwillunload里告诉ASIHTTPRequest，delegate已经释放
        __weak typeof (request) weakrequest = request;
        [request setCompletionBlock:^{
            //执行从searchbar输入得到城市名request后的操作
            
            NSMutableArray *tempCity=[[NSMutableArray alloc]init];
            
            if (10 == request.tag) {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:[weakrequest responseData] error:nil];
                GDataXMLElement *rootElement=[document rootElement];
                NSArray *elements=[rootElement elementsForName:@"s"];
                
                for (GDataXMLElement *element in elements) {
                    WeatherInfoModel *tempInfo=[[WeatherInfoModel alloc]init];
                    tempInfo.cityName=[element attributeForName:@"k"].stringValue;
                    
                    NSString *d=[element attributeForName:@"d"].stringValue;
                    
                    NSRange range=[d rangeOfString:@"woeid"];
                    NSString *cityId=[d substringFromIndex:range.location+range.length];
                    NSArray *temparr=[cityId componentsSeparatedByString:@"&"];
                    cityId=[temparr objectAtIndex:0];
                    
                    tempInfo.woeid=cityId;
                    [tempCity addObject:tempInfo];
                    
                    //   NSLog(@"cityid count %lu",(unsigned long)tabarr.count);
                    //   NSLog(@"assemble count %lu",(unsigned long)_assembleModel.cityId.count);
                    tempInfo=nil;
                }
                [tabarr setValue:tempCity forKey:@"CityName"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchViewControllerPassingDataToSearchResultViewControllerNotification" object:self userInfo:tabarr];
            }
        }];
        [request startAsynchronous];
  //  }
}

- (void)dealloc {
    [timer invalidate];
}

@end
