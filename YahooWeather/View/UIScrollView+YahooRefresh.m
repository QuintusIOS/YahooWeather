//
//  UIScrollView+PullToRefresh.m
//  YahooWeather
//
//  Created by Robbie on 15/4/22.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "UIScrollView+YahooRefresh.h"
#import <objc/runtime.h>

typedef enum {
    GifPullToRefreshControllStateDrawing = 0,
    GifPullToRefreshControllStateLoading,
}GifPullToRefreshControllState;

static char UIScrollViewRefreshContoll;

@implementation GifRefreshControll {
    GifPullToRefreshControllState _state;
    UIImageView *_refreshView;
    UILabel *_commentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _refreshView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height)];
        _refreshView.contentMode = UIViewContentModeScaleAspectFit;
        _refreshView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_refreshView];
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0 , 200 , self.bounds.size.height)];
        _commentLabel.text = @"再大力一点哦╮(￣▽￣)╭" ;
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_commentLabel];
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [self removeObserver];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.scrollView.contentOffset.y <= 0) {
        if (self.scrollView.contentOffset.y <= -GifRefreshControlHeight) {
            _commentLabel.text = @"好啦，松手即可刷新*^ο^*" ;
        }
        if ([keyPath isEqualToString:@"tag"]) {
            [self setState:GifPullToRefreshControllStateLoading];
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.scrollView.contentInset = UIEdgeInsetsMake(GifRefreshControlHeight, 0.0f, 0.0f, 0.0f);
                             }
                             completion:^(BOOL finished){
                                 if (self.pullToRefreshActionHandler) {
                                     self.pullToRefreshActionHandler();
                                 }
                             }];
        }else if ([keyPath isEqualToString:@"contentOffset"]) {
            [self scrollViewContentOffsetChanged];
        }
    }
}

- (void)scrollViewContentOffsetChanged {
    if (_state != GifPullToRefreshControllStateLoading) {
        [self setState:GifPullToRefreshControllStateDrawing];
    }
}

- (void)setState:(GifPullToRefreshControllState)aState {
    CGFloat offset = - self.scrollView.contentOffset.y;
    if (offset < 0) {
        offset = 0;
    }
    if (offset > GifRefreshControlHeight) {
        offset = GifRefreshControlHeight;
    }
    CGFloat ratio = offset / GifRefreshControlHeight;
    NSUInteger imageIndex = ratio * ([self.drawingImages count] - 1);
    switch (aState) {
        case GifPullToRefreshControllStateDrawing:
            [_refreshView stopAnimating];
            _refreshView.image = self.drawingImages[imageIndex];
            break;
            
        case GifPullToRefreshControllStateLoading:
            _refreshView.animationImages = self.loadingImages;
            _refreshView.animationDuration = (CGFloat)self.loadingImages.count / 20.0;
            [_refreshView startAnimating];
            break;
    }
    _state = aState;
    
}

- (void)endLoading {
    if (_state == GifPullToRefreshControllStateLoading) {
        [self setState:GifPullToRefreshControllStateDrawing];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                         }
                         completion:nil];
        _commentLabel.text = @"再大力一点哦╮(￣▽￣)╭" ;

    }
}


- (void)dealloc {
    [self removeObserver];
}

- (void)removeObserver {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"tag"];
    _scrollView = nil;
}

@end

@implementation UIScrollView (YahooRefresh)

- (void)setRefreshControll:(GifRefreshControll *)refreshControll {
    objc_setAssociatedObject(self, &UIScrollViewRefreshContoll, refreshControll, OBJC_ASSOCIATION_ASSIGN);
}

- (GifRefreshControll *)refreshControll {
    return objc_getAssociatedObject(self, &UIScrollViewRefreshContoll);
}

- (void)addPullToRefreshWithDrawingImgs:(NSArray *)drawingImgs andLoadingImgs:(NSArray *)loadingImgs andActionHandler:(void (^)(void))actionHandler {
    
    GifRefreshControll *refreshContollView = [[GifRefreshControll alloc] initWithFrame:CGRectMake(0, -GifRefreshControlHeight, self.bounds.size.width, GifRefreshControlHeight)];
    
    refreshContollView.scrollView = self;
    refreshContollView.pullToRefreshActionHandler = actionHandler;
    refreshContollView.drawingImages = drawingImgs;
    refreshContollView.loadingImages = loadingImgs;
    
    self.refreshControll = refreshContollView;
    [self addSubview:refreshContollView];
}

- (void)removePullToRefresh {
    [self.refreshControll removeObserver];
}

- (void)didFinishPullToRefresh {
    [self.refreshControll endLoading];
}

@end
