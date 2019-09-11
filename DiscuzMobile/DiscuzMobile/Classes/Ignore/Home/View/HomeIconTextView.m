//
//  HomeIconTextView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "HomeIconTextView.h"

@implementation HomeIconTextView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self commitInit];
//    }
//    return self;
//}

- (instancetype)init {
    if (self = [super init]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.iconV = [[UIImageView alloc] init];
    [self addSubview:self.iconV];
    
    self.textLab = [[UILabel alloc] init];
    self.textLab.textAlignment = NSTextAlignmentLeft;
    self.textLab.textColor = LIGHT_TEXT_COLOR;
    self.textLab.font = [FontSize HomecellTimeFontSize14];
    [self addSubview:self.textLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconV.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 23, 10, 16, 16);
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame) + 5, CGRectGetMinY(self.iconV.frame), CGRectGetWidth(self.frame) / 2, 16);
    
}

@end
