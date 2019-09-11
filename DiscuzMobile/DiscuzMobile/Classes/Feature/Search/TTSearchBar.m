//
//  TTSearchBar.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/22.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "TTSearchBar.h"

@implementation TTSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.borderWidth = 1;
    self.layer.borderColor = FORUM_GRAY_COLOR.CGColor;
    self.backgroundColor = FORUM_GRAY_COLOR;
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
    self.placeholder = @"关键字";
    UIImage* searchBarBg = [UIImage createImageWithColor:FORUM_GRAY_COLOR andHeight:30.0f];
    //设置背景图片
    [self setBackgroundImage:searchBarBg];
    //设置文本框背景
    [self setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
}

@end
