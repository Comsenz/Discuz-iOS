//
//  CountRootController.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseViewController.h"
#import "ShareCenter.h"
#import "TTLoginModel.h"
#import "SeccodeverifyView.h"

typedef void(^RefreshBlock)(void);

@interface CountRootController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isKeepTabbarSelected;     // tabbar页面的时候跳登录页面考虑这个属性
@property (nonatomic, strong) SeccodeverifyView *verifyView; // 验证码

- (void)setUserInfo:(id)responseObject;

@end
