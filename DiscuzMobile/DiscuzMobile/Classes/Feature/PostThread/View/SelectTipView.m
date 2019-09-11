//
//  SelectTipView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "SelectTipView.h"

@implementation SelectTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.userInteractionEnabled = YES;
    self.tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 30 - 5, CGRectGetHeight(self.frame))];
    [self addSubview:self.tipLab];
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    self.tipLab.font = [FontSize forumtimeFontSize14];
    self.tipLab.text = @"不限";
    
    self.button.frame = CGRectMake(CGRectGetWidth(self.frame) - 30 - 5, (CGRectGetHeight(self.frame) - 30) / 2, 30, 30);
    [self addSubview:self.button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipLab.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 30 - 5, CGRectGetHeight(self.frame));
    self.button.frame = CGRectMake(CGRectGetWidth(self.frame) - 30 - 5, (CGRectGetHeight(self.frame) - 30) / 2, 30, 30);
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO;
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageTintColorWithName:@"open" andImageSuperView:_button] forState:UIControlStateNormal];
    }
    return _button;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
