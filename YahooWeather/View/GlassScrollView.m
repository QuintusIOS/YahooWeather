//
//  GlassScrollView.m
//  YahooWeather
//
//  Created by Robbie on 15/4/6.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "GlassScrollView.h"

static const NSTimeInterval kTimerIntervalInScheduled = 25;

@implementation GlassScrollView {
    UIScrollView *_backgroundScrollView;
    UIView *_backgroundConstraitView;
    UIImage *_backgroundImage;
    UIImage *_blurredBackgroundImage;
    UIImageView *_backgroundImageView;
    UIImageView *_blurredBackgroundImageView;
    
    UIView *_foregroundContainView;
    
    CALayer *_topShadowLayer;
    CALayer *_botShadowLayer;
    
    NSMutableArray *drawingimages;
    NSMutableArray *loadingimages;
}

#pragma mark First called

- (instancetype)initWithFrame:(CGRect)frame ViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom ForegroundView:(UIView *)foregroundView {
    
    self = [super initWithFrame:frame];
    if (self) {
    
    //backgroundImage before dissove
    _backgroundImage = [UIImage imageNamed:@"CloudWallPaper.png"];
    _blurredBackgroundImage = [UIImage imageNamed:@"CloudWallPaper.png"];
    _viewDistanceFromBottom = viewDistanceFromBottom;
    _foregroundView = foregroundView;
    
    [self performSelector:@selector(retrieveBackgroundImagePhoto) withObject:nil afterDelay:0.05];
    //[self retrieveBackgroundImagePhoto];
    
    //change current runloop mode ,so that you can swipe scrollView and change background image
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerIntervalInScheduled
                                                  target:self
                                                selector:@selector(retrieveBackgroundImagePhoto)
                                                userInfo:nil
                                                 repeats:YES];
    NSRunLoop *currentRunLoop=[NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [self createBackgroundView];
    [self createForegroundView];
    [self createBotShadow];
    [self createTopShadow];
    }
    return self;
}

#pragma mark Second called

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect bound = CGRectOffset(frame, -frame.origin.x, -frame.origin.y);
    
    [_backgroundScrollView setFrame:bound];
    [_backgroundScrollView setContentSize:CGSizeMake(bound.size.width, bound.size.height+DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    [_backgroundConstraitView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    
    [_foregroundContainView setFrame:bound];
    [_foregroundScrollView setFrame:bound];
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, 0, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(bound.size.width, _foregroundView.frame.origin.y+_foregroundView.frame.size.height)];
    
    [_topShadowLayer setFrame:CGRectMake(0, 0, frame.size.width, DEFAULT_TOP_FADING_HEIGHT_HALF)];
    [_botShadowLayer setFrame:CGRectMake(0, bound.size.height-_viewDistanceFromBottom, bound.size.width, bound.size.height)];

}

#pragma mark Third called

- (void)subviewLayoutGuide {
    //rotation后，使GlassScrollView居中
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    
    _foregroundContainView.layer.mask=[self createTopMaskWithSize:CGSizeMake(_foregroundContainView.frame.size.width, _foregroundContainView.frame.size.height) startFadeAt:64 - DEFAULT_TOP_FADING_HEIGHT_HALF endAt:64 + DEFAULT_TOP_FADING_HEIGHT_HALF topColor:[UIColor colorWithWhite:1.0 alpha:0.0] botColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
    [self createTopShadow];
}

#pragma mark BackgroundView and ForegroundView
- (void)setViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom {
    _viewDistanceFromBottom = viewDistanceFromBottom;
}


- (void)createBackgroundView {
    _backgroundScrollView=[[UIScrollView alloc]initWithFrame:self.frame];
    [_backgroundScrollView setUserInteractionEnabled:NO];
    [_backgroundScrollView setShowsVerticalScrollIndicator:NO];
    [_backgroundScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    
    //向backgroundScrollView中加入GifRefreshControl
    
    drawingimages=[[NSMutableArray alloc]init];
    loadingimages=[[NSMutableArray alloc]init];
    
    NSUInteger drawingStart=[GifAnimationDict[0][@"drawingStart"] intValue];
    NSUInteger drawingEnd=[GifAnimationDict[0][@"drawingEnd"] intValue];
    NSUInteger loadingStart=[GifAnimationDict[0][@"loadingStart"] intValue];
    NSUInteger loadingEnd=[GifAnimationDict[0][@"loadingEnd"] intValue];
    
    for (NSUInteger i=drawingStart; i<=drawingEnd; i++) {
        NSString *imageName=[NSString stringWithFormat:GifAnimationDict[0][@"pattern"],i];
        [drawingimages addObject:[UIImage imageNamed:imageName]];
    }
    
    for (NSUInteger i=loadingStart; i<=loadingEnd; i++) {
        NSString *imageName=[NSString stringWithFormat:GifAnimationDict[0][@"pattern"],i];
        [loadingimages addObject:[UIImage imageNamed:imageName]];
    }
    
    __weak UIScrollView *tempScrollView=_backgroundScrollView;
    __weak typeof(self) weakSelf = self;
    
    [_backgroundScrollView addPullToRefreshWithDrawingImgs:drawingimages andLoadingImgs:loadingimages andActionHandler:^{
        [weakSelf.delegate pullToUpdateUI];
        [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:3];
    }];
    
    [self addSubview:_backgroundScrollView];
    
    _backgroundConstraitView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    [_backgroundScrollView addSubview:_backgroundConstraitView];
    
    _backgroundImageView=[[UIImageView alloc]initWithImage:_backgroundImage];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_backgroundConstraitView addSubview:_backgroundImageView];
    
    _blurredBackgroundImageView=[[UIImageView alloc]initWithImage:_blurredBackgroundImage];
    [_blurredBackgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_blurredBackgroundImageView setAlpha:0];
    [_backgroundConstraitView addSubview:_blurredBackgroundImageView];
    
    [_backgroundConstraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_backgroundConstraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_backgroundConstraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
    [_backgroundConstraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];

}

- (void)createForegroundView {
    _foregroundContainView=[[UIView alloc]initWithFrame:self.frame];
    [self addSubview:_foregroundContainView];
    
    _foregroundScrollView=[[UIScrollView alloc]initWithFrame:self.frame];
    [_foregroundScrollView setDelegate:self];
    [_foregroundScrollView setShowsVerticalScrollIndicator:NO];
    [_foregroundContainView addSubview:_foregroundScrollView];
    
    UITapGestureRecognizer *_tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(foregroundTapped:)];
    [_foregroundScrollView addGestureRecognizer:_tapRecognizer];
    
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, 0, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    
    [_foregroundScrollView addSubview:_foregroundView];
    
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];

}


#pragma mark Mask and Layer

- (CALayer *)createTopMaskWithSize:(CGSize)size startFadeAt:(CGFloat)top endAt:(CGFloat)bottom topColor:(UIColor *)topColor botColor:(UIColor *)botColor {
    top = top/size.height;
    bottom = bottom/size.height;
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.5f, 0.0f);
    maskLayer.endPoint = CGPointMake(0.5f, 1.0f);
    
    maskLayer.colors = @[(id)topColor.CGColor, (id)topColor.CGColor, (id)botColor.CGColor, (id)botColor.CGColor];
    maskLayer.locations = @[@0.0, @(top), @(bottom), @1.0f];
    maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    return maskLayer;
}

-(void)createTopShadow {
    //changing the top shadow
    [_topShadowLayer removeFromSuperlayer];
    _topShadowLayer = [self createTopMaskWithSize:CGSizeMake(_foregroundContainView.frame.size.width, 64 + DEFAULT_TOP_FADING_HEIGHT_HALF)
                                      startFadeAt:64 - DEFAULT_TOP_FADING_HEIGHT_HALF
                                            endAt:64 + DEFAULT_TOP_FADING_HEIGHT_HALF
                                         topColor:[UIColor colorWithWhite:0 alpha:.15]
                                         botColor:[UIColor colorWithWhite:0 alpha:0]];
    
    [self.layer insertSublayer:_topShadowLayer below:_foregroundContainView.layer];
}

-(void)createBotShadow {
    [_botShadowLayer removeFromSuperlayer];
    _botShadowLayer = [self createTopMaskWithSize:CGSizeMake(self.frame.size.width,_viewDistanceFromBottom)
                                      startFadeAt:0
                                            endAt:_viewDistanceFromBottom
                                         topColor:[UIColor colorWithWhite:0 alpha:0]
                                         botColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
    [_botShadowLayer setFrame:CGRectOffset(_botShadowLayer.bounds, 0, self.frame.size.height - _viewDistanceFromBottom)];
    [self.layer insertSublayer:_botShadowLayer below:_foregroundContainView.layer];
    
}


#pragma mark TapRecognizer

-(void)foregroundTapped:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tappedPoint=[tapRecognizer locationInView:_foregroundScrollView];
    
    if (tappedPoint.y < _foregroundScrollView.frame.size.height) {
        CGFloat ratio = _foregroundScrollView.contentOffset.y == 0? 1:0;
        [_foregroundScrollView setContentOffset:CGPointMake(0, ratio * _foregroundView.frame.origin.y) animated:YES];
    }
}

#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //when you scroll, it will block timer fire , but timer still add to runloop before you scroll this time
    /*
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:6]];
     */
    CGFloat ratio=scrollView.contentOffset.y/(_foregroundScrollView.frame.size.height - _viewDistanceFromBottom);
    ratio= ratio > 1 ? 1:ratio;
    if (_backgroundScrollView.contentOffset.y > -GifRefreshControlHeight) {
        [_backgroundScrollView setContentOffset:CGPointMake(0, ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    }else{
        [_backgroundScrollView setContentOffset:CGPointMake(0, -GifRefreshControlHeight)];
    }
    [_blurredBackgroundImageView setAlpha:ratio];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //当你松手且backgroundScrollview向上内容起点的位移量超过drawing张数，发起 GIF Animation
    if (_backgroundScrollView.contentOffset.y <= -GifRefreshControlHeight) {
        _backgroundScrollView.tag++;
    }
}

#pragma mark Retrieve Background Image Photo

- (void)retrieveBackgroundImagePhoto {
    [[StockPhotosManager sharedManager] randomStockPhoto:^(StockPhotos *photos) {
        [self crossDissovePhotos:photos];
    }];
}

- (void)crossDissovePhotos:(StockPhotos *)photos {
    [UIView transitionWithView:_backgroundImageView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        _backgroundImageView.image = photos.photo;
        _blurredBackgroundImageView.image = [photos.photoWithEffect applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
    }completion:NULL];
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
