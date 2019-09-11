//
//  EmptyAlertView.m
//  DiscuzMobile
//
//  Created by HB on 17/4/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "EmptyAlertView.h"

@implementation EmptyAlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.backgroundColor = [UIColor whiteColor];
    self.emptyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:EMPTYIMAGE]];
    self.emptyIcon.frame = CGRectMake(0, 0, 160, 140);
    self.emptyIcon.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    [self addSubview:self.emptyIcon];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.emptyIcon.frame = CGRectMake(0, 0, 150, 131.25);
    self.emptyIcon.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 50);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
