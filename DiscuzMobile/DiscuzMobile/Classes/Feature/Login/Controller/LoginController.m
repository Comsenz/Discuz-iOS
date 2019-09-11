//
//  LoginController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LoginController.h"

#import <ShareSDK/ShareSDK.h>

#import "LoginModule.h"

#import "JTRegisterController.h"
#import "TTJudgeBoundController.h"

#import "JTLoginView.h"
#import "LoginCustomView.h"
#import "ZHPickView.h"

#import "ShareCenter.h"
#import "XinGeCenter.h"  // 信鸽
#import "CheckHelper.h"

#define TEXTHEIGHT 50

NSString * const debugUsername = @"debugUsername";
NSString * const debugPassword = @"debugPassword";

@interface LoginController ()<UITextFieldDelegate,ZHPickViewDelegate>{
    BOOL isQCreateView;  // 是否有安全问答
}

@property (nonatomic, strong) JTLoginView *logView;
@property (nonatomic, strong) NSString *preSalkey;

@end


@implementation LoginController

- (void)loadView {
    [super loadView];
    self.logView = [[JTLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.logView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.logView thirdPlatformAuth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarBtn];
    [[CheckHelper shareInstance] checkRequest];
    WEAKSELF;
    self.logView.authcodeView.refreshAuthCodeBlock = ^{
        [weakSelf downlodyan];
    };
    
    [self downlodyan];
    [self setViewDelegate];
    [self setViewAction];
    // 新进来的时候初始化下
    [ShareCenter shareInstance].bloginModel = nil;
    
    isQCreateView = NO;
    
#if DEBUG
    [self seupAutoButton];
#endif
}

- (void)seupAutoButton {
#if DEBUG
    if ([self isHaveFullContent]) {
        UIButton *autoFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        autoFullBtn.frame = CGRectMake(WIDTH - 60, 20, 40, 20);
        [autoFullBtn addTarget:self action:@selector(isHaveFullContent) forControlEvents:UIControlEventTouchUpInside];
        autoFullBtn.titleLabel.font = [FontSize messageFontSize14];
        [autoFullBtn setTitle:@"填充" forState:UIControlStateNormal];
        autoFullBtn.layer.borderWidth = 1;
        [autoFullBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
        [self.view addSubview:autoFullBtn];
    }
#endif
}

- (BOOL)isHaveFullContent {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userdefault objectForKey:debugUsername];
    NSString *password = [userdefault objectForKey:debugPassword];
    if ([DataCheck isValidString:username] && [DataCheck isValidString:password]) {
        self.logView.countView.userNameTextField.text = username;
        self.logView.pwordView.userNameTextField.text = password;
        return YES;
    }
    return NO;
}

- (void)setViewDelegate {
    self.logView.delegate = self;
    self.logView.pickView.delegate = self;
    self.logView.countView.userNameTextField.delegate = self;
    self.logView.pwordView.userNameTextField.delegate = self;
    self.logView.securityView.userNameTextField.delegate = self;
    self.logView.answerView.userNameTextField.delegate = self;
    self.logView.authcodeView.textField.delegate = self;
}

- (void)setViewAction {
    [self.logView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.logView.forgetBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.logView.qqBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:(UIControlEventTouchUpInside)];
    [self.logView.wechatBtn addTarget:self action:@selector(loginWithWeiXin) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 账号密码登录
-(void)loginBtnClick {
    [self.view endEditing:YES];
    
    NSString *username = self.logView.countView.userNameTextField.text;
    NSString *password = self.logView.pwordView.userNameTextField.text;
    
    if (![DataCheck isValidString:username]) {
        [MBProgressHUD showInfo:@"请输入用户名"];
        return;
    }
    if (![DataCheck isValidString:password]) {
        [MBProgressHUD showInfo:@"请输入密码"];
        return;
    }
    
    //       gei  &seccodeverify  验证码  &sechash={sechash值}    http header中加入之前获取到的saltkey,  coolkes
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:username forKey:@"username"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:@"yes" forKey:@"loginsubmit"];
    if (self.verifyView.isyanzhengma) {
        [dic setValue:self.logView.authcodeView.textField.text forKey:@"seccodeverify"];
        [dic setValue:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
    }
    if (isQCreateView) {
        NSDictionary * dicvalue = @{@"母亲的名字":@"1",
                                    @"爷爷的名字":@"2",
                                    @"父亲出生的城市":@"3",
                                    @"您其中一位老师的名字":@"4",
                                    @"您个人计算机的型号":@"5",
                                    @"您最喜欢的餐馆名称":@"6",
                                    @"驾驶执照最后四位数字":@"7"};
        
        [dic setValue:[dicvalue objectForKey:self.logView.securityView.userNameTextField.text] forKey:@"questionid"];
        [dic setValue:self.logView.answerView.userNameTextField.text forKey:@"answer"];
    }
    [dic setValue:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    
    NSMutableDictionary *getData = [NSMutableDictionary dictionary];
    if ([ShareCenter shareInstance].bloginModel.openid != nil) { // 三方登录过来的注册
        [getData setValue:[ShareCenter shareInstance].bloginModel.logintype forKey:@"type"];
        [dic setValue:[ShareCenter shareInstance].bloginModel.openid forKey:@"openid"];
        
        if ([[ShareCenter shareInstance].bloginModel.logintype isEqualToString:@"weixin"]
            && [DataCheck isValidString:[ShareCenter shareInstance].bloginModel.unionid]) {
            [dic setValue:[ShareCenter shareInstance].bloginModel.unionid forKey:@"unionid"];
        }
    }
    [self.HUD showLoadingMessag:@"登录中" toView:self.view];
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_Login;
        request.parameters = dic;
        request.getParam = getData;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        if ([[responseObject messageval] isEqualToString:@"login_question_empty"]) {
            [self.logView.securityView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TEXTHEIGHT);
                self.logView.securityView.hidden = NO;
            }];
            [MBProgressHUD showInfo:[responseObject messagestr]];
        } else {
            [self setUserInfo:responseObject];
#if DEBUG
            [self saveAccount];
#endif
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}

- (void)saveAccount {
    NSString *username = self.logView.countView.userNameTextField.text;
    NSString *password = self.logView.pwordView.userNameTextField.text;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:username forKey:debugUsername];
    [userdefault setObject:password forKey:debugPassword];
    [userdefault synchronize];
}

#pragma mark - qq登录
- (void)loginWithQQ {
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [[ShareCenter shareInstance] loginWithQQSuccess:^(id  _Nullable postData, id  _Nullable getData) {
        [self thirdConnectWithService:postData getData:getData];
    } finish:^{
        [self.HUD hide];
    }];
}

#pragma mark - 微信登录
- (void)loginWithWeiXin {
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [[ShareCenter shareInstance] loginWithWeiXinSuccess:^(id  _Nullable postData, id  _Nullable getData) {
        [self thirdConnectWithService:postData getData:getData];
    } finish:^{
        [self.HUD hide];
    }];
}

- (void)thirdConnectWithService:(NSDictionary *)dic getData:(NSDictionary *)getData {
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Login;
        request.methodType = JTMethodTypePOST;
        request.parameters = dic;
        request.getParam = getData;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self setUserInfo:responseObject];
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
        
        if ([[getData objectForKey:@"type"] isEqualToString:@"weixin"]) {
            if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            }
        }
    }];
}

#pragma mark - 请求成功操作
- (void)setUserInfo:(id)responseObject {

    if ([[responseObject messageval] containsString:@"no_bind"]) {
        // 去第三方绑定页面
        [self boundThirdview];
    } else {
        [super setUserInfo:responseObject];
    }
}


-(void)createBarBtn{
    [self createBarBtn:@"back" type:NavItemImage Direction:NavDirectionLeft];
    [self createBarBtn:@"注册" type:NavItemText Direction:NavDirectionRight];
    
    self.navigationItem.title = @"";
}

- (void)leftBarBtnClick {
    [self.view endEditing:YES];
    NSDictionary *userInfo = @{@"type":@"cancel"};
    [[NSNotificationCenter defaultCenter] postNotificationName:SETSELECTINDEX object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册
- (void)rightBarBtnClick {
    [self.view endEditing:YES];
    [self registerNavview];
}

- (void)registerNavview {
    // 重置一下
//    [ShareCenter shareInstance].bloginModel = nil;
    JTRegisterController * rvc =[[JTRegisterController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}


- (void)boundThirdview {
    
    TTJudgeBoundController * rvc =[[TTJudgeBoundController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)findPassword:(UIButton *)sender {
    
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"login" success:^{
        
        if (self.verifyView.isyanzhengma) {
            [self.logView.authcodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TEXTHEIGHT);
            }];
            self.logView.authcodeView.hidden = NO;
            [self loadSeccodeImage];
        }
        
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
}

- (void)loadSeccodeImage {
    
    [self performSelector:@selector(loadSeccodeWebView) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}


- (void)loadSeccodeWebView {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.verifyView.secureData objectForKey:@"seccode"]]];
    [self.logView.authcodeView.webview loadRequest:request];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag==103) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    } else {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
    return YES;
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString androw:(NSInteger)row{
    
    self.logView.securityView.userNameTextField.text = resultString;
    
    if ([DataCheck isValidString:resultString] && ![resultString isEqualToString:@"无安全提问"]) {
        
        [self.logView.answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(TEXTHEIGHT);
        }];
        self.logView.answerView.hidden = NO;
    } else {
        [self.logView.answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.logView.answerView.hidden = YES;
    }
    if (![self.logView.securityView.userNameTextField.text isEqualToString:@"无安全提问"]) {
        // 创建view
        isQCreateView = YES;

    } else {
        
        isQCreateView = NO;
    }
}


@end
