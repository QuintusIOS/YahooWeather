//
//  BoxView4.m
//  YahooWeather
//
//  Created by Robbie on 15/5/7.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "BoxView4.h"

@implementation BoxView4

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *windLabelUp = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 40, 30)];
        windLabelUp.textColor = [UIColor whiteColor];
        windLabelUp.text = @"风速";
        windLabelUp.font = [UIFont systemFontOfSize:14];
        [self addSubview:windLabelUp];
        
        self.windLabelDown = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 100, 30)];
        self.windLabelDown.textColor = [UIColor whiteColor];
        [self addSubview:self.windLabelDown];
        
        UILabel *pressureLabelUp = [[UILabel alloc] initWithFrame:CGRectMake(310, 140, 40, 30)];
        pressureLabelUp.text = @"气压";
        pressureLabelUp.textColor = [UIColor whiteColor];
        pressureLabelUp.textAlignment = NSTextAlignmentRight;
        pressureLabelUp.font = [UIFont systemFontOfSize:14];
        [self addSubview:pressureLabelUp];
        
        self.pressureLabelDown = [[UILabel alloc] initWithFrame:CGRectMake(250, 160, 100, 30)];
        self.pressureLabelDown.textColor = [UIColor whiteColor];
        self.pressureLabelDown.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.pressureLabelDown];
    }
    return self;
}
@end
