//
//  UnderLineLabel.m
//  YahooWeather
//
//  Created by Robbie on 15/4/13.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "UnderLineLabel.h"

@implementation UnderLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);
    CGContextSetLineWidth(ctx, 0.8f);
    
    CGPoint leftPoint = CGPointMake(0, self.frame.size.height);
    CGPoint rightPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
    CGContextStrokePath(ctx);
}

@end
