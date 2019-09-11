//
//  PraiseHelper.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/21.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "PraiseHelper.h"
#import "LoginModule.h"
#import "ThreadListModel.h"

@implementation PraiseHelper

+ (void)praiseRequestTid:(NSString *)tid successBlock:(void(^)(void))success failureBlock:(void(^)(NSError *error))failure {
    if ([LoginModule isLogged]) {
        NSDictionary * paramter=@{@"tid":tid,
                                  @"hash":[Environment sharedEnvironment].formhash
                                  };
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.urlString = url_Praise;
            request.parameters = paramter;
        } success:^(id responseObject, JTLoadType type) {
            NSString *messageval = [responseObject messageval];
            NSString *messagestr = [responseObject messagestr];
            
            if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]) {
                success?success():nil;
            } else {
                failure?failure(nil):nil;
                [MBProgressHUD showInfo:messagestr];
            }
            
        } failed:^(NSError *error) {
            failure?failure(error):nil;
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:nil];
    }
}

@end
