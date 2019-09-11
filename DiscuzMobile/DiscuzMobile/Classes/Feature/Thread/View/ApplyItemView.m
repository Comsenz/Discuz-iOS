//
//  ApplyItemView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ApplyItemView.h"

@implementation ApplyItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.tipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (WIDTH - 35) / 3, 20)];
    self.tipLab.textColor = MESSAGE_COLOR;
    self.tipLab.font = [FontSize HomecellmessageNumLFontSize10];
    [self addSubview:self.tipLab];
    
    self.infoLab = [[ApplyStatusView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipLab.frame), CGRectGetMaxY(self.tipLab.frame) + 10, CGRectGetWidth(self.tipLab.frame), 20)];
    self.infoLab.statusLab.font = [FontSize ActiveListFontSize11];
    [self addSubview:self.infoLab];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipLab.frame = CGRectMake(10, 10, (WIDTH - 30 - 30) / 3, 20);
    self.infoLab.frame = CGRectMake(CGRectGetMinX(self.tipLab.frame), CGRectGetMaxY(self.tipLab.frame), CGRectGetWidth(self.tipLab.frame), 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
