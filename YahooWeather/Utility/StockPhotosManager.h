//
//  StockPhotosManager.h
//  YahooWeather
//
//  Created by Robbie on 15/4/21.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#define kAsyncQueueLabel "org.tempuri"

#import <Foundation/Foundation.h>
#import "StockPhotos.h"

@interface StockPhotosManager : NSObject

@property (nonatomic, strong) NSMutableSet *stockPhotosSet;

+ (StockPhotosManager *)sharedManager;
- (void)randomStockPhoto:(void(^)(StockPhotos *photos)) completion;

@end
