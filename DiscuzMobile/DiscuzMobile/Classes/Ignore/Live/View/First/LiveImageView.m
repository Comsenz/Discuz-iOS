//
//  LiveImageView.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveImageView.h"

@implementation LiveImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.nuberLabel = [[UILabel alloc] init];
    self.nuberLabel.font = [FontSize HomecellTimeFontSize14];
    self.nuberLabel.textAlignment = NSTextAlignmentLeft;
    self.nuberLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nuberLabel];
    [self.nuberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.width.bottom.equalTo(self);
        make.height.equalTo(@15);
    }];
}

@end
