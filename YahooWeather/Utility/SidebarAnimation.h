//
//  SidebarAnimation.h
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SidebarAnimation : NSObject

+ (void)animateContentView:(UIView *)contentView
               sidebarView:(UIView *)sidebarView
              visableWidth:(CGFloat)visableWidth
                  duration:(NSTimeInterval)animateDuration
                completion:(void (^)(BOOL finished))completion;

+ (void)reverseAnimateContentView:(UIView *)contentView
                      sidebarView:(UIView *)sidebarView
                     visableWidth:(CGFloat)visableWidth
                         duration:(NSTimeInterval)animateDuration
                       completion:(void (^)(BOOL finished))completion;

@end
