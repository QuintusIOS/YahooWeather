//
//  BoxView5.m
//  YahooWeather
//
//  Created by Robbie on 15/5/7.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "BoxView5.h"

@implementation BoxView5

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sunriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 90, 165, 100, 30)];
        self.sunriseLabel.textColor = [UIColor whiteColor];
        self.sunriseLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.sunriseLabel];
        
        self.sunsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 + 90, 165, 100, 30)];
        self.sunsetLabel.textColor = [UIColor whiteColor];
        self.sunsetLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.sunsetLabel];
    }
    return self;
}

@end
