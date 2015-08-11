//
//  BoxView4.h
//  YahooWeather
//
//  Created by Robbie on 15/5/7.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxView4 : UIView

// independent creat BoxView4 and BoxView5 could handle exchange model in EditCityViewController
// else it will add many repeat UILabel in BoxView4
@property (nonatomic, strong) UILabel *windLabelDown;
@property (nonatomic, strong) UILabel *pressureLabelDown;

@end
