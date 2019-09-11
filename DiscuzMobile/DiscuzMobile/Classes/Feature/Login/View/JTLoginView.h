//
//  JTLoginView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginCustomView.h"
#import "Web2AuthcodeView.h"
#import "ZHPickView.h"
@class LoginCustomView, Web2AuthcodeView, ZHPickView;

@interface JTLoginView : UIScrollView

@property (nonatomic, strong) LoginCustomView *countView;
@property (nonatomic, strong) LoginCustomView *pwordView;
@property (nonatomic, strong) LoginCustomView *securityView;
@property (nonatomic, strong) LoginCustomView *answerView;
@property (nonatomic, strong) Web2AuthcodeView *authcodeView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *forgetBtn;

@property (nonatomic, strong) UILabel *thridAuthTipLabl;
@property (nonatomic, strong) UIView *thirdView;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *qqBtn;

@property (nonatomic, strong) ZHPickView *pickView;

- (void)thirdPlatformAuth;

@end
