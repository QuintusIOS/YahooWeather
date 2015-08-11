//
//  SunRiseLayer.m
//  SunRise
//
//  Created by Robbie on 15/5/5.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "SunRiseLayer.h"

@implementation SunRiseLayer

@dynamic time;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 300, 200);
        [self setNeedsDisplay];
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"time"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"time"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = @([[self presentationLayer] time]);
        animation.duration = 2.0;
        return animation;
    }
    return [super actionForKey:event];
}

- (void)display {
    float time = [self.presentationLayer time];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        
    CGContextRef ctx = UIGraphicsGetCurrentContext();
        
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 3);
    CGContextAddArc(ctx, center.x, center.y, 90, 0, M_PI, YES);
    CGFloat legnth[] = {8,3};
    CGContextSetLineDash(ctx, 0, legnth, 2);
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetLineDash(ctx,0,normal,0);
    CGContextMoveToPoint(ctx, center.x - 130, center.y + 1);
    CGContextAddLineToPoint(ctx, center.x + 150, center.y + 1);
    CGContextStrokePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, PNStarYellow.CGColor);
    CGContextSetLineWidth(ctx, 4);
    CGContextMoveToPoint(ctx, center.x - 90, center.y);
    CGContextAddArc(ctx, center.x, center.y - 1, 88, M_PI, M_PI + time * M_PI, NO);
    if (0 == time) {
        self.ratioLine = 0;
    }
    if (time < 1 / 2 && time != 0) {
        self.ratioLine = 90 - cos(time * M_PI) * 90;
    }
    if (1 / 2 == time) {
        self.ratioLine = 90;
    }
    if (time > 1 / 2 && time != 1) {
        self.ratioLine = 90 + cos(M_PI - time * M_PI) * 90;
    }
    if (1 == time) {
        self.ratioLine = 180;
    }
    CGContextAddLineToPoint(ctx, center.x + self.ratioLine - 90, center.y);
    CGContextFillPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(center.x - 93, center.y - 3, 6, 6));
    CGContextFillPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(center.x + 87, center.y - 3, 6, 6));
    CGContextFillPath(ctx);
    
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

@end
