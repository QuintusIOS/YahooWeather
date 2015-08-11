//
//  GlassScrollView.h
//  YahooWeather
//
//  Created by Robbie on 15/4/6.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#define DEFAULT_BLUR_RADIUS 14
#define DEFAULT_BLUR_TINT_COLOR [UIColor colorWithWhite:0 alpha:.3]
#define DEFAULT_BLUR_DELTA_FACTOR 1.4

#define DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL 150
#define DEFAULT_TOP_FADING_HEIGHT_HALF 10

#define GifAnimationDict @[\
@{@"name":@"Yahoo Weather Style",@"pattern":@"sun_%05d.png",@"drawingStart":@0,@"drawingEnd":@27,@"loadingStart":@42,@"loadingEnd":@109}\
]

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

#import "UIScrollView+YahooRefresh.h"
#import "StockPhotosManager.h"

@protocol GlassScrollViewDelegate <NSObject>
- (void)pullToUpdateUI;
@end

@interface GlassScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat viewDistanceFromBottom;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIScrollView *foregroundScrollView;
@property (nonatomic, assign) id<GlassScrollViewDelegate> delegate;
@property (nonatomic, weak) NSTimer *timer;
- (instancetype)initWithFrame:(CGRect)frame ViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom ForegroundView:(UIView *)foregroundView;
- (void)subviewLayoutGuide;

@end


