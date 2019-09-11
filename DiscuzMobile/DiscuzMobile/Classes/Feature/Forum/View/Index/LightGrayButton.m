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
        [self setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
        [self setTitle:@"已收藏" forState:UIControlStateNormal];
        self.layer.borderColor = LIGHT_TEXT_COLOR.CGColor;
    } else {
        [self setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
        [self setTitle:@"收藏" forState:UIControlStateNormal];
        self.layer.borderColor = MAIN_COLLOR.CGColor;
    }
}

@end
