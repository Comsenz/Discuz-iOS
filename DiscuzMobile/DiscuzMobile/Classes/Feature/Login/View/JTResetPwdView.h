//
//  JTResetPwdView.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/17.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginCustomView,AuthcodeView,Web2AuthcodeView;

@interface JTResetPwdView : UIScrollView <UITextFieldDelegate>

@property (nonatomic, strong) LoginCustomView *passwordView;
@property (nonatomic, strong) LoginCustomView *repassView;
@property (nonatomic, strong) LoginCustomView *newpasswordView;
@property (nonatomic, strong) Web2AuthcodeView *authcodeView;

@property (nonatomic, strong) UIButton *submitButton;
@end
