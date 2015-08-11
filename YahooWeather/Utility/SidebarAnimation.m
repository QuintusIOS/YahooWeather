//
//  SidebarAnimation.m
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "SidebarAnimation.h"

@implementation SidebarAnimation

+ (void)animateContentView:(UIView *)contentView sidebarView:(UIView *)sidebarView visableWidth:(CGFloat)visableWidth duration:(NSTimeInterval)animateDuration completion:(void (^)(BOOL))completion {
    
    CGRect contentFrame = contentView.frame;
    contentFrame.origin.x += visableWidth;
    
    [UIView animateWithDuration:animateDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         contentView.frame = contentFrame;
                     }
                     completion:^(BOOL finished){
                         completion(finished);
                     }];
}

+ (void)reverseAnimateContentView:(UIView *)contentView sidebarView:(UIView *)sidebarView visableWidth:(CGFloat)visableWidth duration:(NSTimeInterval)animateDuration completion:(void (^)(BOOL))completion {
    
    CGRect contentFrame = contentView.frame;
    contentFrame.origin.x = 0;
    
    [UIView animateWithDuration:animateDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         contentView.frame = contentFrame;
                     }
                     completion:^(BOOL finished){
                         completion(finished);
                     }];
}

@end
