//
//  scrollTableViewCell.h
//  YahooWeather
//
//  Created by Robbie on 15/4/15.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDotView.h"

@interface scrollTableViewCell : UITableViewCell

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier codeArr:(NSArray *)codeArr textArr:(NSArray *)textArr;


@end
