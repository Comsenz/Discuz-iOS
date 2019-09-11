//
//  SeccodeverifyView.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/27.
//  Copyright © 2017年 Cjk. All rights reserved.
//

#import "SeccodeverifyView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface SeccodeverifyView() <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, strong) NSString *type;

@end

@implementation SeccodeverifyView


- (void)downSeccode:(NSString *)type success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    _type = type;
    static NSInteger downYan_count = 0;
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"type":type};
        request.urlString = url_secureCode;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        downYan_count = 0;
        DLog(@"%@",responseObject);
        if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]]) {
            self.secureData = [responseObject objectForKey:@"Variables"];
        }
        NSString * secHash;
        NSString * seccode;
        NSString * secqaa;
        
        //        self.isyanzhengma = YES;
        //        if (success) {
        //            success();
        //        }
        //        return;
        if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]]) {
            
            secHash = [self.secureData objectForKey:@"sechash"];
            seccode = [self.secureData objectForKey:@"seccode"];
            secqaa  = [self.secureData objectForKey:@"secqaa"];
            if ([DataCheck isValidString:[responseObject objectForKey:@"Variables"]]) {
                [Environment sharedEnvironment].formhash=[[responseObject objectForKey:@"Variables"] objectForKey:@"formhash"];
            }
            //  如果为空则 不需要验证码
            if ([DataCheck isValidString:secHash]&&[DataCheck isValidString:seccode]) {
                self.isyanzhengma = YES;
                if (_isCreate) {
                    [self creatSecureView];
                }
            } else {
                self.isyanzhengma = NO;
                
            }
        } else {
            self.isyanzhengma = NO;
            
        }
        
        if (success) {
            success();
        }
    } failed:^(NSError *error) {
        
        if (downYan_count < 2) {
            downYan_count ++;
            [self downSeccode:type success:(void(^)(void))success failure:(void(^)(NSError *error))failure];
        } else {
            downYan_count = 0;
            if (failure) {
                failure(error);
            }
        }
    }];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBACOLOR(83, 83, 83, 0.5);
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.frame = window.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        _isCreate = NO;
        
    }
    return self;
}


-(void)createYtextView {
    
    _isCreate = YES;

    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    UIView *  bgview = [[UIView alloc]initWithFrame:CGRectMake(40, 116, WIDTH-80, 300)];
    if (iPhone320) {
        bgview.frame = CGRectMake(40, 80, WIDTH-80, 260);
    }
    
    bgview.backgroundColor = mRGBColor(241, 241, 241);
    [self addSubview:bgview];
    
    // 验证码field
    _yanTextField= [[UITextField alloc] initWithFrame:CGRectMake(10, 50, WIDTH-100, 57)];
    _yanTextField.placeholder = @"请输入验证码";
    _yanTextField.tag=10010;
    _yanTextField.borderStyle= UITextBorderStyleRoundedRect;
    _yanTextField.layer.borderWidth = 2.0f;
    _yanTextField.layer.cornerRadius = 5;
    _yanTextField.layer.borderColor = MAIN_COLLOR.CGColor;
    _yanTextField.font = [FontSize forumtimeFontSize14];//14
    [bgview addSubview:_yanTextField];
    
    //验证码webview
    _identWebView=[[UIWebView alloc]initWithFrame:CGRectMake(10, 120, _yanTextField.frame.size.width/2, 40)];
    _identWebView.userInteractionEnabled=YES;
    _identWebView.backgroundColor = [UIColor yellowColor];
    UIButton * buttonSeccode = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSeccode.frame = CGRectMake(10+_yanTextField.frame.size.width/2, 120, _yanTextField.frame.size.width/2, 40);
    [buttonSeccode addTarget:self action:@selector(oclcc) forControlEvents:UIControlEventTouchUpInside];
    buttonSeccode.layer.cornerRadius = 5;
    [buttonSeccode setTitle:@"看不清?" forState:UIControlStateNormal];
    [buttonSeccode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSeccode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    
    [bgview addSubview:buttonSeccode];
    
    _secqaaLabel = [[UILabel alloc] init];
    _secTextField= [[UITextField alloc] init];
    _secTextField.frame = CGRectMake(CGRectGetMinX(_identWebView.frame), CGRectGetMaxY(_identWebView.frame) + 15,CGRectGetWidth(_identWebView.frame), 0);
    _secqaaLabel.frame = CGRectMake(CGRectGetMinX(buttonSeccode.frame), CGRectGetMaxY(_identWebView.frame) + 15, CGRectGetWidth(buttonSeccode.frame), 0);
    [bgview addSubview:_secqaaLabel];
    [bgview addSubview:_secTextField];
    if ([DataCheck isValidString:[self.secureData objectForKey:@"secqaa"]]) {
        _secqaaLabel.frame = CGRectMake(CGRectGetMinX(_identWebView.frame), CGRectGetMaxY(_identWebView.frame) + 15,CGRectGetWidth(_identWebView.frame), 40);
        _secqaaLabel.font = [FontSize forumtimeFontSize14];
        _secqaaLabel.textAlignment = NSTextAlignmentCenter;
        
        _secTextField.frame = CGRectMake(CGRectGetMinX(buttonSeccode.frame), CGRectGetMaxY(_identWebView.frame) + 15, CGRectGetWidth(buttonSeccode.frame), 40);
        _secTextField.placeholder = @"请输入答案";
        _secTextField.tag=10010;
        _secTextField.borderStyle= UITextBorderStyleRoundedRect;
        _secTextField.layer.borderWidth = 2.0f;
        _secTextField.layer.cornerRadius = 5;
        _secTextField.layer.borderColor = MAIN_COLLOR.CGColor;
        _secTextField.font = [FontSize forumtimeFontSize14];//14
    }
    //    _yanTextField.delegate = self;
    UIButton * buttonpost = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonpost.frame = CGRectMake(11, CGRectGetMaxY(_secTextField.frame) + 15,WIDTH-100, 50);
    buttonpost.backgroundColor = MAIN_COLLOR;
    [buttonpost addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    buttonpost.layer.cornerRadius = 5;
    [buttonpost setTitle:@"提交" forState:UIControlStateNormal];
    [buttonpost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [buttonpost setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    //    buttonSeccode.layer.borderColor = MAIN_COLLOR.CGColor;
    [bgview addSubview:buttonpost];
    
    [self creatSecureView];
    [bgview addSubview:_identWebView];
    
}

- (void)oclcc {
    [self downSeccode:self.type success:nil failure:nil];
}

- (void)show {
    DLog(@"显示");
    if (!_isCreate) {
        [self createYtextView];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}

- (void)close {
    DLog(@"关闭");
    [self removeFromSuperview];
}

- (void)postClick {
    if (![DataCheck isValidString:_yanTextField.text]) {
        [MBProgressHUD showInfo:@"请输入验证码"];
        return;
    }
    [self close];
    if (self.submitBlock) {
        self.submitBlock();
    }
}

-(void)creatSecureView {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_secureData objectForKey:@"seccode"]]];
    DLog(@"%@",[_secureData objectForKey:@"seccode"]);
    [_identWebView loadRequest:request];
    DLog(@"creatSecureView");
    _secqaaLabel.text = [_secureData objectForKey:@"secqaa"];
}

- (NSMutableDictionary *)secureData {
    if (!_secureData) {
        _secureData = [NSMutableDictionary dictionary];
    }
    return _secureData;
}


@end
