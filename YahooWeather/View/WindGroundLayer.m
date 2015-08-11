//
//  WindGroundLayer.m
//  YahooWeather
//
//  Created by Robbie on 15/5/3.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "WindGroundLayer.h"

@implementation WindGroundLayer

- (instancetype)init {
    if ((self = [super init]))
    {
        self.bounds = CGRectMake(0, 0, 40, 180);
        [self setNeedsDisplay];
    }
    return self;
}

- (void)display {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + 10);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextMoveToPoint(ctx, center.x - 2, center.y + self.scale);
    CGContextAddLineToPoint(ctx, center.x - 3 , center.y + self.scale * 9);
    CGContextAddLineToPoint(ctx, center.x + 3, center.y + self.scale * 9);
    CGContextAddLineToPoint(ctx, center.x + 2, center.y + self.scale);
    CGContextAddLineToPoint(ctx, center.x, center.y);
    CGContextAddLineToPoint(ctx, center.x - 2, center.y + self.scale);
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

@end
