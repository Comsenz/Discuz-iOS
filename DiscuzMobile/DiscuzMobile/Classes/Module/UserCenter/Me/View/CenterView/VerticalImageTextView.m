//
//  VerticalImageTextView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "VerticalImageTextView.h"

@interface VerticalImageTextView () {
    id _target;
    SEL _action;
}

@end

@implementation VerticalImageTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommit];
    }
    return self;
}

- (void)initCommit {
    self.iconV = [[UIImageView alloc] init];
    [self addSubview:self.iconV];
    
    self.textLabel = [[UILabel alloc] init];
    [self addSubview:self.textLabel];
    self.textLabel.textColor = MAIN_TITLE_COLOR;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [FontSize HomecellNameFontSize16];
}

- (void)layoutSubviews { // 竖的
    [super layoutSubviews];
    self.iconV.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 17, 0, 34, 34);
    self.textLabel.frame = CGRectMake(5, CGRectGetMaxY(self.iconV.frame) + 5, CGRectGetWidth(self.frame) - 10, 25);
} // 85

- (void)addTarget:(id)target action:(SEL)action {
    if (target == _target) {
        return;
    }
    _target = target;
    _action = action;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_target) {
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self afterDelay:0.0];
        }
    }
}


@end
