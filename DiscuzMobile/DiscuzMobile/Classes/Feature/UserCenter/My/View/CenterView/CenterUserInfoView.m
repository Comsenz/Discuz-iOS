// 放头像，用户名，身份
//  CenterUserInfoView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CenterUserInfoView.h"

@implementation CenterUserInfoView

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
    
    self.headView = [[UIImageView alloc] init];
    self.headView.userInteractionEnabled = YES;
    self.headView.image = [UIImage imageNamed:@"noavatar_small"];
    self.headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.headView];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.textColor = MAIN_TITLE_COLOR;
    self.nameLab.font = [FontSize HomecellTitleFontSize17];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLab];
    
    self.identityLab = [[UILabel alloc] init];
    self.identityLab.font = [UIFont boldSystemFontOfSize:13.0];
    self.identityLab.textColor = BTN_USE_COLOR;
    self.identityLab.backgroundColor = MAIN_COLLOR;
    self.identityLab.textAlignment = NSTextAlignmentCenter;
    self.identityLab.text = @"新手上路";
    [self addSubview:self.identityLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headView.frame = CGRectMake(CGRectGetMidX(self.frame) - 32, 10, 64, 64);
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = CGRectGetWidth(self.headView.frame) / 2; // 74
    
    self.nameLab.frame = CGRectMake(CGRectGetMidX(self.frame) - 60, CGRectGetMaxY(self.headView.frame) + 5, 120, 25); // 104
    
    
    CGSize maxSize = CGSizeMake(100, 20);
    CGSize textSize = [self.identityLab.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0] maxSize:maxSize];// 16
    self.identityLab.frame =  CGRectMake(CGRectGetMidX(self.frame) - textSize.width / 2 - 4, CGRectGetMaxY(self.nameLab.frame) + 5, textSize.width + 8, textSize.height);
    self.identityLab.layer.masksToBounds = YES;
    self.self.identityLab.layer.cornerRadius = 2; // 125
    
} // 135

- (void)setIdentityText:(NSString *)text {
    self.identityLab.text = text;
    CGSize maxSize = CGSizeMake(100, 20);
    CGSize textSize = [self.identityLab.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0] maxSize:maxSize];
    self.identityLab.frame =  CGRectMake(CGRectGetMidX(self.frame) - textSize.width / 2 - 4, CGRectGetMaxY(self.nameLab.frame) + 5, textSize.width + 8, textSize.height);
    self.identityLab.layer.masksToBounds = YES;
    self.self.identityLab.layer.cornerRadius = 2;
}

@end
