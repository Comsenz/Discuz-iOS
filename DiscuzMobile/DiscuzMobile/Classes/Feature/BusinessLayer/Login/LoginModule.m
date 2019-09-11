//
//  LoginModule.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "LoginModule.h"
#import "XinGeCenter.h"
#import "ShareCenter.h"

NSString * const LoginFileName = @"LoginFile";
NSString * const CookieValue = @"COOKIEVALU";

@implementation LoginModule

+ (void)loginAnylyeData:(id)responseObject andView:(UIView *)view andHandle:(void(^)(void))handle {
    NSDictionary *Variables = [responseObject objectForKey:@"Variables"];
    NSString *messageval = [responseObject messageval];
    NSString *messagestr = [responseObject messagestr];
    if (![messageval containsString:@"succeed"]) {
        [MBProgressHUD showInfo:messagestr];
        return;
    }
    
    if(![DataCheck isValidString:[Variables objectForKey:@"auth"]]) {
        [MBProgressHUD showInfo:messagestr];
        return;
    }
    
    if (![DataCheck isValidString:[Variables objectForKey:@"member_uid"]]) {
        [MBProgressHUD showInfo:@"未能获取到您的用户id"];
        return;
    }
    
    // 普通登录或者登录成功
    [[Environment sharedEnvironment] setValuesForKeysWithDictionary:Variables];
    [LoginModule saveUserInfo:Variables];
    
    for (NSHTTPCookie * cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if ([[cookie name] isEqualToString:[NSString stringWithFormat:@"%@",[Environment sharedEnvironment].authKey]]) {
            [LoginModule saveCookie:cookie];
        }
    }
    handle?handle():nil;
}

/*
 * 判断是否登录
 */
+ (BOOL)isLogged {
    NSString *uid = [Environment sharedEnvironment].member_uid;
    NSString *auth = [Environment sharedEnvironment].auth;
    if ([DataCheck isValidString:uid] && [DataCheck isValidString:auth]) {
        return YES;
    }
    return NO;
}


/*
 * 退出登录
 */
+ (void)signout {
    DLog(@"清除本地登录信息");
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CookieValue];
    [[XinGeCenter shareInstance] setXG];
    
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
//        if ([[cookie name] isEqualToString:[NSString stringWithFormat:@"%@",[Environment sharedEnvironment].loggedAuthKey]]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
    }
    NSMutableDictionary *infoDic = [LoginModule getUserInfokey].mutableCopy;
    for (NSString *key in infoDic.allKeys) {
        [infoDic setObject:@"" forKey:key];
    }
    [[Environment sharedEnvironment] setValuesForKeysWithDictionary:infoDic];
    //  LoginFile
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LoginFileName];
    
    [Environment sharedEnvironment].authKey = nil;
    [ShareCenter shareInstance].bloginModel = nil;
    
}

+ (void)cleanLogType {
    
    [Environment sharedEnvironment].member_loginstatus = @"0";
    [LoginModule saveUserInfo:@"member_loginstatus" value:@"0"];
}

/**
 判断是否三方登录
 
 @return YES 是三方登录
 */
+ (BOOL)isThirdplatformLogin {
    if ([DataCheck isValidString:[Environment sharedEnvironment].member_loginstatus]) {
        if ([[Environment sharedEnvironment].member_loginstatus isEqualToString:@"weixin"] || [[Environment sharedEnvironment].member_loginstatus isEqualToString:@"qq"]) {
            return YES;
        }
    }
    return NO;
}

/*
 * 设置自动登录状态
 */

+ (void)setAutoLogin {
    Environment *emviment = [Environment sharedEnvironment];
    if ([DataCheck isValidDictionary:[LoginModule getUserInfokey]]) {
        [emviment setValuesForKeysWithDictionary:[LoginModule getUserInfokey]];
        // 设置cookie 自动登录
        [self setHttpCookie:[self getCookie]];
    }
}

/*
 * 保存登录信息到本地
 */
+ (void)saveUserInfo:(NSDictionary *)info {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in info.allKeys) {
        if (![DataCheck isValidString:[info objectForKey:key]]) { // 处理下可能出现空值
            [info setValue:@"" forKey:key];
        }
    }
    [userDefaults setObject:info forKey:LoginFileName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * 保存登录信息到本地 一条条
 */
+ (void)saveUserInfo:(NSString *)key value:(NSString *)value {
    NSDictionary *info = [LoginModule getUserInfokey];
    if (![DataCheck isValidDictionary:info]) {
        info = [NSDictionary dictionary];
    }
    NSMutableDictionary *mutableInfo = [info mutableCopy];
    key = [key isKindOfClass:[NSString class]] ? key : [NSString stringWithFormat:@"%@",key];
    if (value != nil) {
        [mutableInfo setObject:value forKey:key];
        [LoginModule saveUserInfo:mutableInfo];
    }
}


/*
 * 获取登录信息
 */
+ (NSDictionary *)getUserInfokey {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [userDefaults objectForKey:LoginFileName];
    if (![DataCheck isValidDictionary:info]) {
        return nil;
    }
    return info;
}

// 获取当前登录的uid
+ (NSString *)getLoggedUid {
    NSString *uid = [Environment sharedEnvironment].member_uid;
    if (![DataCheck isValidString:uid]) {
        uid = @"0";
    }
    return uid;
}

#pragma mark - cookie
// 检查cookie
+ (void)checkCookie {
    if ([self isLogged]) {
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.methodType = JTMethodTypePOST;
            request.urlString = url_UserInfo;
        } success:^(id responseObject, JTLoadType type) {
            if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"] isEqualToString:@"请先登录后才能继续浏览"]) {
                [LoginModule signout];
            }
        } failed:nil];
    }
}

+ (void)setHttpCookie:(NSHTTPCookie *)cookie {
    if (cookie) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

// 保存cookie
+ (void)saveCookie:(NSHTTPCookie *)cookie {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:cookie];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CookieValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSHTTPCookie *)getCookie {
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:CookieValue];
    NSHTTPCookie * cookie_PD = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return cookie_PD;
}

@end

