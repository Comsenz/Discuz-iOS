//
//  WebAuthcodeView.m
//  DiscuzMobile
//
//  Created by HB on 16/11/25.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "WebAuthcodeView.h"

@interface WebAuthcodeView()<UIWebViewDelegate>

@end

@implementation WebAuthcodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self createYtextView];
    }
    return self;
}

-(void)createYtextView {
    // 黑色半透明背景
//    _loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    //    _loginView.backgroundColor = [UIColor greenColor];
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnclikeBG:)];
    [self addGestureRecognizer:singleTap];
//    [self.view addSubview:_loginView];
    
    UIView *  bgview = [[UIView alloc]initWithFrame:CGRectMake(40, 116, WIDTH-80, 300)];
    
    if (iPhone320) {
        bgview.frame = CGRectMake(40, 80, WIDTH-80, 260);
    }
    
    bgview.userInteractionEnabled = YES;
    bgview.backgroundColor = mRGBColor(241, 241, 241);
    [self addSubview:bgview];
    
    _loginBtn.frame = CGRectMake(10, 212, WIDTH-20, 41);
    // 验证码field
    _yanTextField= [[UITextField alloc] initWithFrame:CGRectMake(10, 50, WIDTH-100, 57)];
//    _yanTextField.delegate = self;
    _yanTextField.placeholder = @"请输入验证码";
    _yanTextField.tag=10010;
    _yanTextField.borderStyle= UITextBorderStyleRoundedRect;
    _yanTextField.layer.borderWidth = 1.0f;
    _yanTextField.layer.cornerRadius = 5;
    _yanTextField.layer.borderColor = MAIN_COLLOR.CGColor;
    _yanTextField.font = [FontSize forumtimeFontSize14];//14
    [bgview addSubview:_yanTextField];
    
    //验证码webview
    _identWebView=[[UIWebView alloc]initWithFrame:CGRectMake(10, 120, _yanTextField.frame.size.width/2, 40)];
    _identWebView.delegate=self;
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

- (void)OnclikeBG:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(OnclikeBG:)]) {
        [self.delegate performSelector:@selector(OnclikeBG:) withObject:tap];
    }
}

- (void)oclcc {
    if ([self.delegate respondsToSelector:@selector(oclcc)]) {
        [self.delegate performSelector:@selector(oclcc) withObject:nil];
    }
}

- (void)postClick {
    if ([self.delegate respondsToSelector:@selector(postClick)]) {
        [self.delegate performSelector:@selector(postClick) withObject:nil];
    }
}

-(void)creatSecureView {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_secureData objectForKey:@"seccode"]]];
    DLog(@"%@",[_secureData objectForKey:@"seccode"]);
    [_identWebView loadRequest:request];
    DLog(@"creatSecureView");
    
    _secqaaLabel.text = [_secureData objectForKey:@"secqaa"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
