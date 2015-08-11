//
//  UIScrollView+PullToRefresh.h
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GifRefreshControlHeight 42.0

#define DrawingImageNumber 67.0

@interface GifRefreshControll : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, strong) NSArray *drawingImages;
@property (nonatomic, strong) NSArray *loadingImages;

- (void)endLoading;
- (void)removeObserver;

@end

@interface UIScrollView (YahooRefresh)

@property (nonatomic, strong)GifRefreshControll *refreshControll;

- (void)addPullToRefreshWithDrawingImgs:(NSArray *)drawingImgs andLoadingImgs:(NSArray *)loadingImgs andActionHandler:(void (^)(void))actionHandler;
- (void)removePullToRefresh;
- (void)didFinishPullToRefresh;

@end
