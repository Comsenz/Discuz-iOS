//
//  ApplyStatusView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ApplyStatusView.h"

@interface ApplyStatusView()

@property (nonatomic, strong) UIImageView *iconV;


@end

@implementation ApplyStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active_check"]];
    self.iconV.contentMode = UIViewContentModeScaleAspectFit;
    self.iconV.frame = CGRectZero;
    self.statusLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconV.frame), 0, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame))];
    self.statusLab.font = [FontSize HomecellTimeFontSize14];
    [self addSubview:self.iconV];
    [self addSubview:self.statusLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([DataCheck isValidString:self.statusLab.text]) {
        if ([self.statusLab.text isEqualToString:@"允许参加"]) {
            self.iconV.frame =  CGRectMake(0, 2, 17, 17);
            self.statusLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame), 0, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame));
        } else {
            self.iconV.frame =  CGRectZero;
            self.statusLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
    }
}

- (void)setStatusText:(NSString *)text {
    
    self.statusLab.text = text;
    if ([DataCheck isValidString:text]) {
        if ([text isEqualToString:@"允许参加"]) {
            self.iconV.frame =  CGRectMake(0, 2, 17, 17);
            self.statusLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame), 0, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame));
        } else {
            self.iconV.frame =  CGRectZero;
            self.statusLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
