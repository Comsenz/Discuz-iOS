//
//  ResetPwdController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/17.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ResetPwdController.h"
#import "UsertermsController.h"

#import "JTResetPwdView.h"
#import "AuthcodeView.h"
#import "LoginCustomView.h"
#import "Web2AuthcodeView.h"

#import "XinGeCenter.h"

@interface ResetPwdController ()
@property (nonatomic,strong) JTResetPwdView *resetView;
@property (nonatomic, strong) NSString *bbrulestxt;
@end

@implementation ResetPwdController
- (void)loadView {
    [super loadView];
    _resetView = [[JTResetPwdView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _resetView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    
    _resetView.delegate = self;
    [_resetView.submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF;
    self.resetView.authcodeView.refreshAuthCodeBlock = ^{
        [weakSelf downlodyan];
    };
    
    [self downlodyan];
}

- (void)readTerms {
    UsertermsController *usertermsVc = [[UsertermsController alloc] init];
    usertermsVc.bbrulestxt = self.bbrulestxt;
    [self.navigationController pushViewController:usertermsVc animated:YES];
}

- (void)tapAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"password" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.resetView.authcodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
            }];
            self.resetView.authcodeView.hidden = NO;
        }
        
        [self loadSeccodeImage];
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
    
}


- (void)loadSeccodeImage {
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.verifyView.secureData objectForKey:@"seccode"]]];
    [self.resetView.authcodeView.webview loadRequest:request];
    
}

- (void)submitButtonClick {
    
    [self.view endEditing:YES];
    NSString *oldpassword = self.resetView.passwordView.userNameTextField.text;
    NSString *newpassword1 = self.resetView.newpasswordView.userNameTextField.text;
    NSString *newpassword2 = self.resetView.repassView.userNameTextField.text;
    
    if ([DataCheck isValidString:oldpassword] && [DataCheck isValidString:newpassword1] && [DataCheck isValidString:newpassword2]) { // 全部按要求填了
        if (![newpassword1 isEqualToString:newpassword2]) {
            [MBProgressHUD showInfo:@"请确定两次输入的密码相同"];
        } else { // 所有都输入了，去注册
            [self postResetData];
        }
    } else { // 未按要求填或者有空
        if (![DataCheck isValidString:oldpassword]) {
            [MBProgressHUD showInfo:@"请输入旧密码" ];
        } else if (![DataCheck isValidString:newpassword1]) {
            [MBProgressHUD showInfo:@"请输入新密码"];
        } else if (![DataCheck isValidString:newpassword2]) {
            [MBProgressHUD showInfo:@"请重复新密码"];
        }
    }
    
}

- (void)postResetData {
    NSString *oldpassword = self.resetView.passwordView.userNameTextField.text;
    NSString *newpassword1 = self.resetView.newpasswordView.userNameTextField.text;
    NSString *newpassword2 = self.resetView.repassView.userNameTextField.text;
//    NSString *email = [Environment sharedEnvironment].email;
    
    NSMutableDictionary *postDic = @{@"oldpassword":oldpassword,
                                     @"newpassword":newpassword1,
                                     @"newpassword2":newpassword2,
//                                     @"emailnew":email?email:@"",
                                     @"passwordsubmit":@"true",
                                     @"formhash":[Environment sharedEnvironment].formhash
                                     }.mutableCopy;
    if (self.verifyView.isyanzhengma) {
        [postDic setValue:self.resetView.authcodeView.textField.text forKey:@"seccodeverify"];
        [postDic setValue:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
    }
    [self.HUD showLoadingMessag:@"正在提交" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_resetPwd;
        request.parameters = postDic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        if ([[responseObject messageval] containsString:@"succeed"]) {
            [MBProgressHUD showInfo:@"修改密码成功，请重新登录"];
            [LoginModule signout];
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:SIGNOUTNOTIFY object:nil];
        } else {
            [MBProgressHUD showInfo:[responseObject messagestr]];
        }
    } failed:^(NSError *error) {
        [self showServerError:error];
        [self.HUD hide];
    }];
    
}

@end
