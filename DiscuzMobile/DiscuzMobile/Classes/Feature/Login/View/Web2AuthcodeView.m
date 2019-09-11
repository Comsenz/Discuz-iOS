//
//  Web2AuthcodeView.m
//  DiscuzMobile
//
//  Created by HB on 16/12/6.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "Web2AuthcodeView.h"

@interface Web2AuthcodeView()<UIGestureRecognizerDelegate>

@end

@implementation Web2AuthcodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"请输入验证码";
    self.textField.font = [FontSize forumtimeFontSize14];
    [self.textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.textField];
    [self setHidden:YES];

    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.webview = [[UIWebView alloc] init];
    self.webview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.webview.userInteractionEnabled = YES;
    [self.webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.webview.scrollView.scrollEnabled = NO;
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
    tapges.delegate = self;
    [self.webview addGestureRecognizer:tapges];
    [self addSubview:self.webview];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(WIDTH * 0.48);
        make.height.mas_equalTo(0);
    }];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0);
        make.top.equalTo(self).offset(10);
        int width = WIDTH * 0.3;
        make.width.mas_equalTo(width);
    }];

}

- (void)tapGes {
    self.refreshAuthCodeBlock?self.refreshAuthCodeBlock():nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)setHidden:(BOOL)hidden {
    
    [super setHidden:hidden];
    
    if (self.hidden == NO)  {
        [self.superview layoutIfNeeded];
        if (self.frame.size.height > 2) {

            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.frame.size.height - 16);
            }];
            [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.frame.size.height - 10);
            }];
        }

    }
}


@end
