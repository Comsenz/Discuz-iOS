//
//  WebAuthcodeView.h
//  DiscuzMobile
//
//  Created by HB on 16/11/25.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol webAuthcodeDelegate <NSObject>

- (void)OnclikeBG:(UITapGestureRecognizer *)tap;

- (void)oclcc;

- (void)postClick;


@end

@interface WebAuthcodeView : UIView
// 验证码
@property (nonatomic,strong) NSDictionary *secureData;

@property (nonatomic , strong) UIButton *loginBtn;
@property (nonatomic , strong)  UITextField * yanTextField;
@property (nonatomic , strong) UITextField * secTextField;
@property (nonatomic , strong) UIWebView * identWebView;
@property (nonatomic , strong) UILabel * secqaaLabel;

@property (nonatomic, weak) id<webAuthcodeDelegate> delegate;

- (void)creatSecureView;
- (void)createYtextView;

@end
