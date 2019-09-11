//
//  BoundView.m
//  DiscuzMobile
//
//  Created by HB on 16/10/27.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "BoundView.h"

@implementation BoundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(8, 22, WIDTH - 16, 30)];
    tips.text = @"关联已有掌上论坛账户";
    tips.font = [FontSize HomecellTimeFontSize16];
    tips.textColor = [UIColor grayColor];
    [self addSubview:tips];
    
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(tips.frame) + 22, WIDTH - 16, 40)];
    _nameField.font = [FontSize HomecellTimeFontSize16];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.placeholder = @"请输入用户名/邮箱/已验证手机";
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_nameField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_nameField.frame) + 22, WIDTH - 16, 40)];
    _passwordField.font = [FontSize HomecellTimeFontSize16];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"请输入密码";
    [self addSubview:_passwordField];
    
    _authCodeField = [[UITextField alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_passwordField.frame) + 22, 110, 40)];
    _authCodeField.font = [FontSize HomecellTimeFontSize16];
    _authCodeField.borderStyle = UITextBorderStyleRoundedRect;
    _authCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeField.tag = 103;
    _authCodeField.placeholder = @"请输入验证码";
    _authCodeField.hidden = YES;
    [self addSubview:_authCodeField];
    
    _codeView = [[AuthcodeView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_authCodeField.frame) + 15, CGRectGetMinY(_authCodeField.frame), 100, 40)];
    _codeView.hidden = YES;
    [self addSubview:_codeView];
    
    UILabel *tips2 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_passwordField.frame) + 22, WIDTH - 16, 28)];
    
    tips2.textColor = LIGHT_TEXT_COLOR;
    tips2.font = [FontSize HomecellTimeFontSize14];
    tips2.numberOfLines = 0;
    tips2.text = @"关联后，你的微信/QQ账户和论坛账户都可以登录";
    CGSize textSize = [tips.text sizeWithFont:[FontSize HomecellTimeFontSize14] maxSize:CGSizeMake(WIDTH - 16, CGFLOAT_MAX)];
    tips2.frame = CGRectMake(8, CGRectGetMaxY(_codeView.frame) + 22, WIDTH - 16, textSize.height);
    [self addSubview:tips2];
    
    _boundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _boundBtn.cs_acceptEventInterval = 1;
    _boundBtn.frame = CGRectMake(10, CGRectGetMaxY(tips2.frame) + 15, WIDTH-20, 40);
    [_boundBtn setTitle:@"登录" forState:UIControlStateNormal];
    _boundBtn.backgroundColor = MAIN_COLLOR;
    _boundBtn.layer.cornerRadius = 5.0;
    [self addSubview:_boundBtn];
    
}

@end
