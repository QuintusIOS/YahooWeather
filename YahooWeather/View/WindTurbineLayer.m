//
//  WindTurbineLayer.m
//  YahooWeather
//
//  Created by Robbie on 15/5/3.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "WindTurbineLayer.h"

@implementation WindTurbineLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 100, 100);
        [self setNeedsDisplay];
    }
    return self;
}

- (void)display {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, center.x + 5, center.y + 3);
    CGContextAddLineToPoint(ctx, center.x + self.scale, center.y);
    CGContextAddLineToPoint(ctx, center.x + 5, center.y - 3);
    CGContextAddQuadCurveToPoint(ctx, center.x, center.y, center.x + 5, center.y + 3);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, center.x - 5 * sin(M_PI_2 / 3) - 3 * sin(M_PI_2  * 2/ 3), center.y + 5 * sin(M_PI_2  * 2/ 3) - 3 * sin(M_PI_2 / 3));
    CGContextAddLineToPoint(ctx, center.x - self.scale * sin(M_PI_2 / 3), center.y + self.scale * sin(M_PI_2  * 2/ 3));
    CGContextAddLineToPoint(ctx, center.x - 5 * sin(M_PI_2 / 3) + 3 * sin(M_PI_2  * 2/ 3), center.y + 5 * sin(M_PI_2  * 2/ 3) + 3 * sin(M_PI_2 / 3));
    CGContextAddQuadCurveToPoint(ctx, center.x, center.y, center.x - 5 * sin(M_PI_2 / 3) - 3 * sin(M_PI_2  * 2/ 3),  center.y + 5 * sin(M_PI_2  * 2/ 3) - 3 * sin(M_PI_2 / 3));
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, center.x - 5 * sin(M_PI_2 / 3) - 3 * sin(M_PI_2  * 2/ 3), center.y - 5 * sin(M_PI_2  * 2/ 3) + 3 * sin(M_PI_2 / 3));
    CGContextAddLineToPoint(ctx, center.x - self.scale * sin(M_PI_2 / 3), center.y - self.scale * sin(M_PI_2  * 2/ 3));
    CGContextAddLineToPoint(ctx, center.x - 5 * sin(M_PI_2 / 3) + 3 * sin(M_PI_2  * 2/ 3), center.y - 5 * sin(M_PI_2  * 2/ 3) - 3 * sin(M_PI_2 / 3));
    CGContextAddQuadCurveToPoint(ctx, center.x, center.y, center.x - 5 * sin(M_PI_2 / 3) - 3 * sin(M_PI_2  * 2/ 3),  center.y - 5 * sin(M_PI_2  * 2/ 3) + 3 * sin(M_PI_2 / 3));
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

@end
