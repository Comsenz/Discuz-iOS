//
//  HorizontalImageTextView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "HorizontalImageTextView.h"

@implementation HorizontalImageTextView

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
    self.textLabel.font = [FontSize HomecellNameFontSize16];
    self.textLabel.textColor = MAIN_TITLE_COLOR;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.font = [FontSize HomecellNameFontSize16];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconV.frame = CGRectMake(0, 0, 25, 25);
    self.textLabel.frame = CGRectMake(CGRectGetMaxY(self.iconV.frame) + 10, CGRectGetMinY(self.iconV.frame), 150, CGRectGetHeight(self.iconV.frame));
}


@end
