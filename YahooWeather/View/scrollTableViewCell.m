//
//  scrollTableViewCell.m
//  YahooWeather
//
//  Created by Robbie on 15/4/15.
//  Copyright (c) 2015年 Robbie. All rights reserved.
//

#import "scrollTableViewCell.h"

@implementation scrollTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier codeArr:(NSArray *)codeArr textArr:(NSArray *)textArr {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, 365, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height );
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i < codeArr.count; i++) {
            UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, self.frame.size.height )];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 100, self.frame.size.height )];
            
            codeLabel.textColor = [UIColor whiteColor];
            textLabel.textColor = [UIColor whiteColor];
            
            codeLabel.font = [UIFont fontWithName:@"Climacons-Font" size:60];
            
            NSString *code = codeArr[i];
            codeLabel.text = [NSString stringWithFormat:@"%c",code.intValue];
            textLabel.text = textArr[i];
            
            UIView *container = [[UIView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*175 + 25, 0)];
            [container addSubview:codeLabel];
            [container addSubview:textLabel];
            
            [_scrollView addSubview:container];
        }
        
        [self addSubview:_scrollView];
        
        AddDotView *dotView=[[AddDotView alloc]initWithFrame:CGRectZero];
        [self setBackgroundView:dotView];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
