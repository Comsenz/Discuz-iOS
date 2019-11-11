//
//  LightGrayButton.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/31.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "LightGrayButton.h"

@implementation LightGrayButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
}

- (void)setLighted:(BOOL)lighted {
    _lighted = lighted;
    if (!lighted) {
        [self setTitleColor:K_Color_LightText forState:UIControlStateNormal];
        [self setTitle:@"已收藏" forState:UIControlStateNormal];
        self.layer.borderColor = K_Color_LightText.CGColor;
    } else {
        [self setTitleColor:K_Color_Theme forState:UIControlStateNormal];
        [self setTitle:@"收藏" forState:UIControlStateNormal];
        self.layer.borderColor = K_Color_Theme.CGColor;
    }
}

@end
