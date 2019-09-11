//
//  JTRequestOperation.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JTRequestConst.h"
#import "JTURLRequest.h"

@interface JTRequestOperation : AFHTTPSessionManager

+ (instancetype)shareInstance;

/**
 发起请求
 
 @param request     JTURLRequest 对象
 @param progress    下载进度
 @param success     请求成功
 @param failed      请求失败
 */
- (void)sendRequest:(JTURLRequest *)request progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed;

// 判断是否已经有缓存了
- (BOOL)isCache:(JTURLRequest *)request;


/**
 监听网络状态
 */
+ (void)startMonitoring;

/**
 取消请求任务
 
 @param urlString 协议接口
 @param getParam get参数
 @return currentUrlString
 */
- (NSString *)cancelRequest:(NSString *)urlString getParameter:(NSDictionary *)getParam;

@end
