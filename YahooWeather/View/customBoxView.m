//
//  customBoxView.m
//  YahooWeather
//
//  Created by Robbie on 15/4/15.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "customBoxView.h"

@implementation customBoxView {
    UIImageView *_upImageView;
    UIImageView *_downImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _conditionCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 45, 70)];
        _conditionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 70)];
        
        _conditionLabel.adjustsFontSizeToFitWidth = YES;
        
        _temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.frame.size.width - 5, 140)];
        
        _highLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 65, 45, 35)];
        _lowLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 65, 45, 35)];
        
        _upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 65, 45, 35)];
        _upImageView.image = [UIImage imageNamed:@"Up"];
        _downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 65, 45, 35)];
        _downImageView.image = [UIImage imageNamed:@"Down"];
        
        [self addSubview:_upImageView];
        [self addSubview:_downImageView];
        
        _conditionLabel.textColor = [UIColor whiteColor];
        _conditionCodeLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _highLabel.textColor = [UIColor whiteColor];
        _lowLabel.textColor = [UIColor whiteColor];
        
        _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:130];
        _conditionLabel.font = [UIFont systemFontOfSize:25];
        _conditionCodeLabel.font = [UIFont fontWithName:@"Climacons-Font" size:50];
        _highLabel.font = [UIFont systemFontOfSize:25];
        _lowLabel.font = [UIFont systemFontOfSize:25];
        
        _conditionCodeLabel.shadowColor = [UIColor blackColor];
        _conditionCodeLabel.shadowOffset = CGSizeMake(1, 1);
        
        _conditionLabel.shadowColor = [UIColor blackColor];
        _conditionLabel.shadowOffset = CGSizeMake(1, 1);
        
        _temperatureLabel.shadowColor = [UIColor blackColor];
        _temperatureLabel.shadowOffset = CGSizeMake(1, 1);
        
        _highLabel.shadowColor = [UIColor blackColor];
        _highLabel.shadowOffset = CGSizeMake(1, 1);
        
        _lowLabel.shadowColor = [UIColor blackColor];
        _lowLabel.shadowOffset = CGSizeMake(1, 1);
        
        [self addSubview:_conditionLabel];
        [self addSubview:_conditionCodeLabel];
        [self addSubview:_temperatureLabel];
        [self addSubview:_highLabel];
        [self addSubview:_lowLabel];
        
        _box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 210, 365, 145)];
        _box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 365, 365, 265)];
        _box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 640, 365, 250)];
        _box4 = [[BoxView4 alloc] initWithFrame:CGRectMake(5, 900, 365, 200)];
        _box5 = [[BoxView5 alloc] initWithFrame:CGRectMake(5, 1110, 365, 200)];

        _box1.layer.cornerRadius = 3;
        _box2.layer.cornerRadius = 3;
        _box3.layer.cornerRadius = 3;
        _box4.layer.cornerRadius = 3;
        _box5.layer.cornerRadius = 3;

        _box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
        _box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
        _box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
        _box4.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
        _box5.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];

        [self addSubview:_box1];
        [self addSubview:_box2];
        [self addSubview:_box3];
        [self addSubview:_box4];
        [self addSubview:_box5];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
