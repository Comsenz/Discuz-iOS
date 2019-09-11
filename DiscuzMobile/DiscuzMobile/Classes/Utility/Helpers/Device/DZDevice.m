//
//  DZDevice.m
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "DZDevice.h"
#define CC_MD5_DIGEST_LENGTH 16
#import <CommonCrypto/CommonDigest.h>
//#import "XGPush.h"
//// share sdk
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import "WXApi.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>

@implementation DZDevice


NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}


/**
 获取icon名字

 @return iconname
 */
+ (NSString *)getIconName {
    NSString *logoName = @"";
    if ([DataCheck isValidArray:[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]]) {
        NSArray *iconArr = [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
        logoName = iconArr.lastObject;
    }
    return logoName;
}


/**
 获取手机当前语言

 @return 语言种类
 */
+ (NSString*)getPreferredLanguage {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    DLog(@"%@",allLanguages);
    DLog(@"当前语言:%@", preferredLang);
    return preferredLang;
    
}


@end
