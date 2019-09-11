//
//  LoginCustomView.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 16/9/17.
//  Copyright © 2016年 Cjk. All rights reserved.
// 这个textfiled高度55

#import "LoginCustomView.h"

@interface LoginCustomView()

@property (nonatomic,strong) UIView * leftview;
@property (nonatomic,strong) UILabel *lineLabel;

@end

@implementation LoginCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}


- (void)p_setupViews {
    
    self.backgroundColor = [UIColor whiteColor];
    //用户名
    _userNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 1)];
    _userNameTextField.placeholder = @"请输入用户名";
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_userNameTextField];
    
    _leftview =[[UIView alloc] initWithFrame:CGRectMake(8, 0, 35, 20)];
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_head_dark"]];
    
    [_leftview addSubview:_imgView];
    _userNameTextField.leftView = _leftview;
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _userNameTextField.font = [FontSize HomecellNameFontSize16];//14
    ;
    
   _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
    _lineLabel.backgroundColor = LINE_COLOR;
    [self addSubview:_lineLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userNameTextField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 1);
    _leftview.frame = CGRectMake(0, 0, 35, 24);
    _imgView.frame = CGRectMake(0, 0, CGRectGetHeight(self.leftview.frame), CGRectGetHeight(self.leftview.frame));
    _lineLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
    
}

@end
