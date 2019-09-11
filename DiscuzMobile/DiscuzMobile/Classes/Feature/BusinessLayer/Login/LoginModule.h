//
//  LoginModule.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const LoginFileName;
extern NSString * const CookieValue;

@interface LoginModule : NSObject

/*
 * 删除登录信息
 */

//+ (void)removeInfoWithSiteId:(NSString *)siteId key:(NSString *)key;

// 分析登录信息
+ (void)loginAnylyeData:(id)responseObject andView:(UIView *)view  andHandle:(void(^)(void))handle;

/*
 * 判断是否登录
 */
+ (BOOL)isLogged;

/*
 *  退出登录，清空用户信息
 */
+ (void)signout;

+ (void)cleanLogType;


/**
 判断是否三方登录

 @return YES 是三方登录
 */
+ (BOOL)isThirdplatformLogin;

/*
 * 设置自动登录状态
 */
+ (void)setAutoLogin;

// 获取当前登录的uid
+ (NSString *)getLoggedUid;

// 检查cookie
+ (void)checkCookie;

// 设置cookie
+ (void)setHttpCookie:(NSHTTPCookie *)cookie;

// 保存cookie
+ (void)saveCookie:(NSHTTPCookie *)cookie;
// 获取cookie
+ (NSHTTPCookie *)getCookie;
@end
