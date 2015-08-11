//
//  AddDotView.m
//  DRIZZLE
//
//  Created by Robbie on 15/4/13.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "AddDotView.h"

@implementation AddDotView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef dotted=UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(dotted, PNButtonGrey.CGColor);
    CGContextSetLineWidth(dotted, 1.5);
    
    const CGFloat dottedInfo[]={1,2};
    CGContextSetLineDash(dotted, 0, dottedInfo, 2);
    
    CGContextBeginPath(dotted);
    CGContextMoveToPoint(dotted, 15, rect.size.height - 1.5/2);
    CGContextAddLineToPoint(dotted, rect.size.width, rect.size.height - 1.5/2);
    CGContextStrokePath(dotted);
}

@end
