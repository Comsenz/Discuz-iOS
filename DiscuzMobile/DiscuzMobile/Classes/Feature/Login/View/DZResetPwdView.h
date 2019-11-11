//
//  DZResetPwdView.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/17.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Web2AuthCodeView.h"

@class LoginCustomView,DZAuthCodeView;

@interface DZResetPwdView : UIScrollView <UITextFieldDelegate>

@property (nonatomic, strong) LoginCustomView *passwordView;
@property (nonatomic, strong) LoginCustomView *repassView;
@property (nonatomic, strong) LoginCustomView *newpasswordView;
@property (nonatomic, strong) Web2AuthCodeView *authCodeView;

@property (nonatomic, strong) UIButton *submitButton;
@end
