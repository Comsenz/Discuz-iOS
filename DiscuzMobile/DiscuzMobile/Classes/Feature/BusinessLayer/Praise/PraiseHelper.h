//
//  PraiseHelper.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/21.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseHelper : NSObject

+ (void)praiseRequestTid:(NSString *)tid successBlock:(void(^)(void))success failureBlock:(void(^)(NSError *error))failure;

@end
