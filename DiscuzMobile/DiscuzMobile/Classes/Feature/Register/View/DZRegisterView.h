//
//  DZRegisterView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsertermsView.h"

@class LoginCustomView,DZAuthCodeView,Web2AuthCodeView;

@interface DZRegisterView : UIScrollView <UITextFieldDelegate>
@property (nonatomic, strong) LoginCustomView *usernameView;
@property (nonatomic, strong) LoginCustomView *passwordView;
@property (nonatomic, strong) LoginCustomView *repassView;
@property (nonatomic, strong) LoginCustomView *emailView;
@property (nonatomic, strong) Web2AuthCodeView *authCodeView;
@property (nonatomic, strong) UILabel *thridAuthTipLabl;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UsertermsView *usertermsView;

- (void)thirdPlatformAuth;

@end
