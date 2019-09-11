//
//  JTRequestManager.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JTRequestManager.h"

@implementation JTRequestManager

#pragma mark - 配置请求
+ (void)requestWithConfig:(JTRequestConfig)config success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    [self requestWithConfig:config progress:nil success:success failed:failed];
}

+ (void)requestWithConfig:(JTRequestConfig)config progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    JTURLRequest *request=[[JTURLRequest alloc]init];
    config ? config(request) : nil;
    
    [[JTRequestOperation shareInstance] sendRequest:request progress:progress success:success failed:failed];
}

+ (BOOL)isCache:(NSString *)urlString andParameters:(id)parameters {
    JTURLRequest *request = [[JTURLRequest alloc] init];
    request.urlString = urlString;
    if (parameters != nil) {
        request.parameters = parameters;
    }
    return [[JTRequestOperation shareInstance] isCache:request];
}

+ (void)cancelRequest:(NSString *)urlString getParameter:(NSDictionary *)getParam completion:(JTCancelCompletedBlock)completion {
    if([urlString isEqualToString:@""]||urlString==nil)return;
    
    NSString *cancelUrlString= [[JTRequestOperation shareInstance] cancelRequest:urlString getParameter:getParam];
    if (completion) {
        completion(cancelUrlString);
    }
}

+ (JTBatchRequest *)sendBatchRequest:(batchRequestConfig)config success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    return [self sendBatchRequest:config progress:nil success:success failed:failed];
}

+ (JTBatchRequest *)sendBatchRequest:(batchRequestConfig)config progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    JTBatchRequest *batchRequest=[[JTBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    
    if (batchRequest.urlArray.count==0)return nil;
    [batchRequest.urlArray enumerateObjectsUsingBlock:^(JTURLRequest *request , NSUInteger idx, BOOL *stop) {
        [[JTRequestOperation shareInstance] sendRequest:request progress:progress success:success failed:failed];
    }];
    return batchRequest;
}


@end
