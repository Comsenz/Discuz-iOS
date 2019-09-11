//
//  JTLoginView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTLoginView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ShareCenter.h"

#import "WXApi.h"
#import "LoginCustomView.h"
#import "Web2AuthcodeView.h"
#import "ZHPickView.h"

#define TEXTHEIGHT 50

@implementation JTLoginView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupViews];
    }
    return self;
}


- (void)p_setupViews {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.showsVerticalScrollIndicator = NO;
    
    UIImageView *nameImageV = [[UIImageView alloc] init];
    nameImageV.image = [UIImage imageNamed:LOGONAME];
    nameImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:nameImageV];
    [nameImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(50);
#if Penjing
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(50);
#else
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(35);
#endif
        
    }];
    
    IQPreviousNextView *contentView = [[IQPreviousNextView alloc] init];
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat cwidth = CGRectGetWidth(self.frame) - 80;
        make.width.mas_equalTo(cwidth);
        make.top.equalTo(nameImageV.mas_bottom).offset(50);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    self.countView = [[LoginCustomView alloc] init];
    self.countView.userNameTextField.tag = 101;
    self.countView.userNameTextField.placeholder = @"账号";
    self.countView.imgView.image = [UIImage imageNamed:@"log_u"];
    [contentView addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.top.equalTo(contentView.mas_top);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(contentView.mas_left);
    }];
    
    self.pwordView = [[LoginCustomView alloc] init];
    self.pwordView.userNameTextField.tag = 102;
    self.pwordView.userNameTextField.placeholder = @"密码";
    self.pwordView.userNameTextField.secureTextEntry = YES;
    self.pwordView.imgView.image = [UIImage imageNamed:@"log_p"];
    [contentView addSubview:self.pwordView];
    [self.pwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.countView.mas_width);
        make.top.equalTo(self.countView.mas_bottom);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(contentView.mas_left);
    }];
    
    self.securityView = [[LoginCustomView alloc] init];
    self.securityView.userNameTextField.placeholder = @"安全提问（未设置请忽略）";
    self.securityView.imgView.image = [UIImage imageNamed:@"log_s"];
    self.securityView.userNameTextField.tag = 103;
    self.securityView.userNameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.securityView.userNameTextField.inputView = self.pickView;
    self.securityView.hidden = YES;
    [contentView addSubview:self.securityView];
    [self.securityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.pwordView.mas_width);
        make.top.equalTo(self.pwordView.mas_bottom);
        make.left.equalTo(self.pwordView.mas_left);
        make.height.mas_equalTo(0);
    }];
    
    
    self.answerView = [[LoginCustomView alloc] init];
    self.answerView.imgView.hidden = YES;
    [contentView addSubview:self.answerView];
    self.answerView.backgroundColor = [UIColor whiteColor];
    self.answerView.hidden = YES;
    self.answerView.userNameTextField.font = [FontSize forumtimeFontSize14];
    self.answerView.userNameTextField.placeholder = @"验证问答答案";
    
    [self.answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.securityView);
        make.top.equalTo(self.securityView.mas_bottom);
        make.width.equalTo(self.pwordView.mas_width);
        make.height.mas_equalTo(0);
    }];
    
    // 验证码 有无
    self.authcodeView = [[Web2AuthcodeView alloc] init];
    self.authcodeView.hidden = YES;
    
    [contentView addSubview:self.authcodeView];
    [self.authcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerView);
        make.top.equalTo(self.answerView.mas_bottom);
        make.width.equalTo(self.answerView.mas_width);
        make.height.mas_equalTo(0);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authcodeView);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.cs_acceptEventInterval = 1;
    [self addSubview:self.loginBtn];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = MAIN_COLLOR;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.top.equalTo(contentView.mas_bottom).offset(16);
        make.width.mas_equalTo(contentView.mas_width);
        make.height.mas_equalTo(45);
    }];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5.0;
    
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.forgetBtn];
    self.forgetBtn.hidden = YES;
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginBtn.mas_right);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    
    [self addSubview:self.thridAuthTipLabl];
    [self.thridAuthTipLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.loginBtn);
        make.top.equalTo(self.forgetBtn.mas_bottom).offset(5);
    }];
    self.thridAuthTipLabl.hidden = YES;
    
    
    self.thirdView = [[UIView alloc] init];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.thirdView];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn.mas_left);
        make.top.equalTo(self.thridAuthTipLabl.mas_bottom).offset(30);
        make.width.mas_equalTo(contentView.mas_width);
        make.height.mas_equalTo(15 + 20 + 45);
    }];
    
    UIImageView *line1 = [[UIImageView alloc] init];
    line1.image = [UIImage imageTintColorWithName:@"third_line_l" andImageSuperView:line1];
    [self.thirdView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdView.mas_left);
        make.top.equalTo(self.thirdView).offset(5);
        make.width.mas_equalTo(self.thirdView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(6);
    }];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor whiteColor];
    thirdLabel.textColor = LIGHT_TEXT_COLOR;
    thirdLabel.text = @"第三方登录";
    thirdLabel.font = [FontSize HomecellTitleFontSize15];
    [self.thirdView addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_right);
        make.top.equalTo(self.thirdView.mas_top);
        make.width.mas_equalTo(line1.mas_width);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *line2 = [[UIImageView alloc] init];
    line2.image = [UIImage imageTintColorWithName:@"third_line_r" andImageSuperView:line2];
    [self.thirdView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdLabel.mas_right);
        make.top.equalTo(line1);
        make.width.mas_equalTo(line1.mas_width);
        make.height.mas_equalTo(6);
    }];
    
    
//    self.wechatBtn = [UIImageView alloc] initWithImage:[UIImage]
    self.wechatBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.wechatBtn.cs_acceptEventInterval = 1;
    [self.wechatBtn setBackgroundImage:[UIImage imageTintColorWithName:@"third_w" andImageSuperView:self.wechatBtn] forState:UIControlStateNormal];
    [self.thirdView addSubview:self.wechatBtn];
    
    self.qqBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.qqBtn.cs_acceptEventInterval = 1;
    [self.qqBtn setBackgroundImage:[UIImage imageTintColorWithName:@"third_q" andImageSuperView:self.qqBtn] forState:UIControlStateNormal];
    [self.thirdView addSubview:self.qqBtn];
    
    BOOL isInstallWechat = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    BOOL isInstallQQ = [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
    
    
#if Jinbifun
    [self.thirdView setHidden:YES];
#endif
    if (isInstallWechat && isInstallQQ) {
        
        [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line1.mas_right).offset(-30);
            make.top.equalTo(thirdLabel.mas_bottom).offset(20);
            make.width.height.mas_equalTo(40);
        }];
        
        
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line2.mas_left).offset(-10);
            make.top.equalTo(self.wechatBtn);
            make.size.equalTo(self.wechatBtn);
        }];
    } else if (isInstallQQ){
        
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(line2.mas_left).offset(-10);
            make.centerX.equalTo(self.thirdView);
            make.top.equalTo(thirdLabel.mas_bottom).offset(20);
            make.width.height.mas_equalTo(40);
        }];
    } else if (isInstallWechat){
        [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.thirdView);
            make.top.equalTo(thirdLabel.mas_bottom).offset(20);
            make.width.height.mas_equalTo(40);
        }];
    } else {
        [self.thirdView setHidden:YES];
    }
    
}

- (void)thirdPlatformAuth {
    if ([ShareCenter shareInstance].bloginModel) {
        NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"亲爱的%@ 关联掌上论坛账号即可一键登录",[ShareCenter shareInstance].bloginModel.username]];
        NSRange dearRange = {0,3};
        NSInteger nameLength = [[NSString stringWithFormat:@"%@",[ShareCenter shareInstance].bloginModel.username] length];
        NSRange nameRange = {3,nameLength};
        NSRange allRange = {0,[describe length]};
        [describe addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:allRange];
        [describe addAttribute:NSFontAttributeName value:[FontSize forumtimeFontSize14] range:allRange];
        
        [describe addAttribute:NSForegroundColorAttributeName value:LIGHT_TEXT_COLOR range:dearRange];
        [describe addAttribute:NSFontAttributeName value:[FontSize HomecellTimeFontSize16] range:dearRange];
        
        [describe addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:nameRange];
        [describe addAttribute:NSFontAttributeName value:[FontSize HomecellTimeFontSize16] range:nameRange];
        self.thridAuthTipLabl.attributedText = describe;
        self.thridAuthTipLabl.hidden = NO;
        [self.loginBtn setTitle:@"关联" forState:UIControlStateNormal];
    } else {
        self.thridAuthTipLabl.hidden = YES;
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectGetMaxY(self.thirdView.frame) + 50 > self.frame.size.height) {
        self.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.thirdView.frame) + 50);
    } else {
        self.contentSize = CGSizeMake(WIDTH, self.frame.size.height + 50);
    }
}

- (ZHPickView *)pickView {
    if (!_pickView) {
        _pickView = [[ZHPickView alloc] initPickviewWithPlistName:@"安全问答" isHaveNavControler:NO];
        [_pickView setToolbarTintColor:TOOLBAR_BACK_COLOR];
    }
    return _pickView;
}

- (UILabel *)thridAuthTipLabl {
    if (!_thridAuthTipLabl) {
        _thridAuthTipLabl = [[UILabel alloc] init];
        _thridAuthTipLabl.numberOfLines = 0;
    }
    return _thridAuthTipLabl;
}

@end
