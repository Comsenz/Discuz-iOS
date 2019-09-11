//
//  SeccodeverifyView.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/27.
//  Copyright © 2017年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CodeSubmitBlock)(void);

@interface SeccodeverifyView : UIView

// 验证码
@property (nonatomic, strong) NSMutableDictionary *secureData;
@property (nonatomic, assign) BOOL isyanzhengma;

@property (nonatomic, strong) UITextField * yanTextField;
@property (nonatomic, strong) UITextField * secTextField;
@property (nonatomic, strong) UIWebView * identWebView;
@property (nonatomic, strong) UILabel * secqaaLabel;

@property (nonatomic, copy) CodeSubmitBlock submitBlock;

- (void)downSeccode:(NSString *)type success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

- (void)show;
- (void)close;

@end
