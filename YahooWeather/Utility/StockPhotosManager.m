//
//  StockPhotosManager.m
//  YahooWeather
//
//  Created by Robbie on 15/4/21.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "StockPhotosManager.h"

@implementation StockPhotosManager

static StockPhotosManager *sharedManager = nil;

+ (StockPhotosManager *)sharedManager {
    @synchronized (self) {
        if (!sharedManager) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load {
    
    NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"StockPhotos"];
    
    self.stockPhotosSet = [[NSMutableSet alloc] init];
    
    NSString *prefix;
    NSString *token;
    
    for (NSString *fileName in files) {
        prefix = [fileName lastPathComponent];
        token = [prefix substringWithRange:NSMakeRange(0, 3)];
        
        [self.stockPhotosSet addObject:token];
    }
}

- (int)randomNumberBetweenLow:(int)low AndHigh:(int)high {
    return ((arc4random() % (high - low + 1)) + low);
}

- (void)randomStockPhoto:(void (^)(StockPhotos *))completion {
    
    StockPhotos *photos = [[StockPhotos alloc] init];
    
    dispatch_queue_t queue = dispatch_queue_create(kAsyncQueueLabel, NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        int stockCount = [self.stockPhotosSet count] - 1;
        int indexpath = [self randomNumberBetweenLow:0 AndHigh:stockCount];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%03d-StockPhotos.png",@"StockPhotos",indexpath];
        photos.photo = [UIImage imageNamed:imagePath];
        photos.photoWithEffect = photos.photo;
        
        dispatch_async(main, ^{
            completion(photos);
        });
    });
}

@end
