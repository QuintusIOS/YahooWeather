//
//  customBoxView.h
//  YahooWeather
//
//  Created by Robbie on 15/4/15.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxView4.h"
#import "BoxView5.h"

@interface customBoxView : UIView

@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UILabel *conditionCodeLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;

@property (nonatomic, strong) UIView *box1;
@property (nonatomic, strong) UIView *box2;
@property (nonatomic, strong) UIView *box3;
@property (nonatomic, strong) BoxView4 *box4;
@property (nonatomic, strong) BoxView5 *box5;

@end
