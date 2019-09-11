//
//  TTBoundController.m
//  DiscuzMobile
//
//  Created by HB on 16/9/18.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTBoundController.h"
#import "LoginCustomView.h"
#import "AuthcodeView.h"
#import "BoundView.h"
#import "XinGeCenter.h"

@interface TTBoundController () <UITextFieldDelegate>

@property (nonatomic,strong) BoundView *boundView;

@end

@implementation TTBoundController

- (void)loadView {
    [super loadView];
    _boundView = [[BoundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _boundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _boundView.delegate = self;
    _boundView.contentSize = CGSizeMake(WIDTH, HEIGHT + 1);
    self.navigationItem.title = @"登录绑定";
    self.view.backgroundColor = mRGBColor(246, 246, 246);
    
    [self setAction];
}

- (void)setAction {
    _boundView.authCodeField.delegate = self;
    _boundView.nameField.delegate = self;
    _boundView.passwordField.delegate = self;
    _boundView.authCodeField.delegate = self;
    [_boundView.boundBtn addTarget:self action:@selector(boundBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 103) {
        [self isCodeRight];
    }
}


- (BOOL)isCodeRight {
    // 忽略大小写
    BOOL result = [_boundView.authCodeField.text compare:_boundView.codeView.authCodeStr
                                       options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    if (![DataCheck isValidString:_boundView.authCodeField.text]) {
        [MBProgressHUD showInfo:@"请输入验证码"];
        //验证不匹配，验证码和输入框抖动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-20,@20,@-20];
        //        [authCodeView.layer addAnimation:anim forKey:nil];
        [_boundView.authCodeField.layer addAnimation:anim forKey:nil];
    } else {
        //判断输入的是否为验证图片中显示的验证码
        if (!result) {
            [MBProgressHUD showInfo:@"验证码不正确"];
            //验证不匹配，验证码和输入框抖动
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20,@20,@-20];
            //        [authCodeView.layer addAnimation:anim forKey:nil];
            [_boundView.authCodeField.layer addAnimation:anim forKey:nil];
        }
    }
    return result;
}

- (void)boundBtnClick {
    [self.view endEditing:YES];
    
    NSString *name = _boundView.nameField.text;
    NSString *pass = _boundView.passwordField.text;
    NSString *code = _boundView.authCodeField.text;
    
    if ([DataCheck isValidString:name]
        && [DataCheck isValidString:pass]
//        && [DataCheck isValidString:code]
        ) {
        if ([self isCodeRight]) {
            [self boundData];
        }
    } else {
        if (![DataCheck isValidString:name]) {
            [MBProgressHUD showInfo:@"请输入用户"];
        } else if (![DataCheck isValidString:pass]) {
            [MBProgressHUD showInfo:@"请输入密码"];
        }
//        else if (![DataCheck isValidString:code]) {
//            [MBProgressHUD showInfo:@"请输入验证码"];
//        }
    }
}

- (void)boundData {
    NSString *name = _boundView.nameField.text;
    NSString *pass = _boundView.passwordField.text;
    
    DLog(@"name = %@, pass = %@",name,pass);
    if ([ShareCenter shareInstance].bloginModel.openid != nil) {
        
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            [self.HUD showLoadingMessag:@"登录中" toView:self.view];
            NSMutableDictionary *getDic = @{@"openid":[ShareCenter shareInstance].bloginModel.openid,
                                            @"type":[ShareCenter shareInstance].bloginModel.logintype,
                                            @"username":name,
                                            @"password":pass}.mutableCopy;
            if ([[ShareCenter shareInstance].bloginModel.logintype isEqualToString:@"weixin"] && [DataCheck isValidString:[ShareCenter shareInstance].bloginModel.unionid]) {
                [getDic setValue:[ShareCenter shareInstance].bloginModel.unionid forKey:@"unionid"];
            }
//            request.urlString = url_BindThird;
            request.parameters = getDic;
        } success:^(id responseObject, JTLoadType type) {
            [self.HUD hideAnimated:YES];
            [self setUserInfo:responseObject];
        } failed:^(NSError *error) {
            [self.HUD hideAnimated:YES];
            [self showServerError:error];
        }];
    }
}

@end
