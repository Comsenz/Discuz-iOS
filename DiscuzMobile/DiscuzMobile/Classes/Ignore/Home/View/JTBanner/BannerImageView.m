//
//  BannerImageView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BannerImageView.h"


@implementation BannerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    
//    self.clipsToBounds = YES;
//    self.contentMode = UIViewContentModeScaleAspectFill;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    _titleLabel  = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15.5];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"点击看看";
    
    [self addSubview:_bgView];
    [_bgView addSubview:_titleLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame), 30);
    _titleLabel.frame = CGRectMake(8, 0, CGRectGetWidth(_bgView.frame) - 68, CGRectGetHeight(_bgView.frame));
}


@end
