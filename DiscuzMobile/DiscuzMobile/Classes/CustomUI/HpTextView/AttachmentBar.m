//
//  AttachmentBar.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/6.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AttachmentBar.h"

@implementation AttachmentBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commInit];
    }
    return self;
}

- (void)commInit {
    CGFloat btn_width = 34;
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(15 , 5, btn_width, btn_width);
    [self.imageBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self addSubview:self.imageBtn];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
