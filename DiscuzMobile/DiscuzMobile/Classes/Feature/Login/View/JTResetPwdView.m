//
//  JTResetPwdView.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/17.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JTResetPwdView.h"
#import "LoginCustomView.h"
#import "Web2AuthcodeView.h"

#define TEXTHEIGHT 50

@implementation JTResetPwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self P_setupViews];
    }
    return self;
}

- (void)P_setupViews {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.backgroundColor = [UIColor whiteColor];
    
    IQPreviousNextView *contentView = [[IQPreviousNextView alloc] init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor redColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat cwidth = CGRectGetWidth(self.frame) - 80;
        make.width.mas_equalTo(cwidth);
        make.top.equalTo(self).offset(50);
        //        make.height.mas_equalTo(200);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    self.passwordView = [[LoginCustomView alloc] init];
    self.passwordView.userNameTextField.tag = 102;
    self.passwordView.userNameTextField.delegate = self;
    self.passwordView.userNameTextField.placeholder = @"旧密码";
    self.passwordView.userNameTextField.secureTextEntry = YES;
    self.passwordView.imgView.image = [UIImage imageNamed:@"log_p"];
    [contentView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.top.equalTo(contentView.mas_top);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(contentView.mas_left);
    }];
    
    self.newpasswordView = [[LoginCustomView alloc] init];
    [contentView addSubview:self.newpasswordView];
    self.newpasswordView.backgroundColor = [UIColor whiteColor];
    self.newpasswordView.imgView.image = [UIImage imageNamed:@"log_p"];
    self.newpasswordView.userNameTextField.placeholder = @"新密码";
    self.newpasswordView.userNameTextField.delegate = self;
    self.newpasswordView.userNameTextField.secureTextEntry = YES;
    [self.newpasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.passwordView.mas_width);
        make.top.equalTo(self.passwordView.mas_bottom);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(self.passwordView.mas_left);
    }];
    
    self.repassView = [[LoginCustomView alloc] init];
    self.repassView.userNameTextField.placeholder = @"重复新密码";
    self.repassView.imgView.image = [UIImage imageNamed:@"log_r"];
    self.repassView.userNameTextField.tag = 103;
    self.repassView.userNameTextField.secureTextEntry = YES;
    self.repassView.userNameTextField.delegate = self;
    [contentView addSubview:self.repassView];
    [self.repassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newpasswordView);
        make.top.equalTo(self.newpasswordView.mas_bottom);
        make.width.equalTo(self.newpasswordView.mas_width);
        make.height.mas_equalTo(TEXTHEIGHT);
    }];
    
    
    // 验证码 有无
    self.authcodeView = [[Web2AuthcodeView alloc] init];
    self.authcodeView.hidden = YES;
    self.authcodeView.textField.delegate = self;
    [contentView addSubview:self.authcodeView];
    [self.authcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.repassView);
        make.top.equalTo(self.repassView.mas_bottom);
        make.width.equalTo(self.repassView.mas_width);
        make.height.mas_equalTo(0);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authcodeView);
    }];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.cs_acceptEventInterval = 1;
    [self addSubview:self.submitButton];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = MAIN_COLLOR;
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(self.authcodeView.mas_bottom).offset(16);
        make.width.mas_equalTo(contentView.mas_width);
        make.height.mas_equalTo(45);
    }];
    
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 5.0;
    
    [self.submitButton layoutIfNeeded];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat contentHeight = self.frame.size.height + 1;
    if (CGRectGetMaxY(_submitButton.frame) + 50 > contentHeight) {
        contentHeight = CGRectGetMaxY(_submitButton.frame) + 50;
    }
    self.contentSize = CGSizeMake(WIDTH, contentHeight);
}
@end
