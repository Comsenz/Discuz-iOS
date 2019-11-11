//
//  LogoutCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LogoutCell.h"

@implementation LogoutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 100, 5, 200, 50)];
    self.lab.backgroundColor = [UIColor whiteColor];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.font = [DZFontSize HomecellTitleFontSize17];
    self.lab.textColor = K_Color_LightText;
    self.lab.text = @"退出登录";
    [self.contentView addSubview:self.lab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lab.frame = CGRectMake(15, 5, KScreenWidth - 30, 50);
    [self setRadius:self.lab];
}

- (void)setRadius:(UILabel *)lab {
    lab.layer.borderColor = K_Color_NaviBack.CGColor;
    lab.layer.borderWidth = 0.5;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 8;
}

@end
