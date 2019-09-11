//
//  DZApiRequest.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/23.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DZApiRequest.h"
#import "LoginModule.h"
#import "MessageNoticeCenter.h"

@implementation DZApiRequest

+ (void)requestWithConfig:(JTRequestConfig)config success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    [self requestWithConfig:config progress:nil success:^(id responseObject, JTLoadType type) {
        [self publicDo:responseObject];
        success(responseObject,type);
    } failed:failed];
}

+ (void)requestWithConfig:(JTRequestConfig)config progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    [JTRequestManager requestWithConfig:^(JTURLRequest *request) {
        config ? config(request) : nil;
        request.urlString = [self checkUrl:request.urlString];
    } progress:progress success:success failed:failed];
}

/**
 是否缓存过了
 
 @param request 请求对象
 */

/**
 是否缓存过了
 
 @param urlString 地址
 @param parameters 传递的参数
 @return 是否
 */
+ (BOOL)isCache:(NSString *)urlString andParameters:(id)parameters {
    JTURLRequest *request = [[JTURLRequest alloc] init];
    request.urlString = [self checkUrl:urlString];
    if (parameters != nil) {
        request.parameters = parameters;
    }
    return [[JTRequestOperation shareInstance] isCache:request];
}

+ (void)cancelRequest:(NSString *)urlString getParameter:(NSDictionary *)getParam completion:(JTCancelCompletedBlock)completion {
    if([urlString isEqualToString:@""]||urlString==nil)return;
    NSString *urlStr = [self checkUrl:urlString];
    [JTRequestManager cancelRequest:urlStr getParameter:getParam completion:completion];
}

+ (NSString *)checkUrl:(NSString *)urlStr {
    
    urlStr = [NSString stringWithFormat:@"api/mobile/%@",urlStr];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefault objectForKey:@"domain"];
    if ([DataCheck isValidString:domain]) {
        urlStr = [NSString stringWithFormat:@"%@%@",domain,urlStr];
    } else {
        urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,urlStr];
    }
    urlStr = [urlStr stringByAppendingString:@"&mobiletype=IOS"];
    return urlStr;
}

// 掌上论坛公共处理
+ (void)publicDo:(id)responseObject {
    if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]]) { // 公共提醒
        [Environment sharedEnvironment].formhash = [[responseObject objectForKey:@"Variables"] objectForKey:@"formhash"];
        if ([LoginModule isLogged]) {
            if ([DataCheck isValidDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"notice"]]) { //公共提醒
                [MessageNoticeCenter shareInstance].noticeDic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"notice"]];
            }
        }
        return;
    }
    NSString *error = [responseObject objectForKey:@"error"];
    if ([DataCheck isValidString:error] && [error isEqualToString:@"module_not_exists"]) {
        [MBProgressHUD showInfo:@"该模块暂未开放"];
    }
}

@end
