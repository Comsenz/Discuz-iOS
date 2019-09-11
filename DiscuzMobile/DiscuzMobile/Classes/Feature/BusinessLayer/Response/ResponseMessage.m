//
//  ResponseMessage.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/19.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ResponseMessage.h"

@implementation ResponseMessage

+ (BOOL)autherityJudgeResponseObject:(NSDictionary *)responseObject refuseBlock:(void(^)(NSString *message))refuseBlock {
    NSString *messageval = [responseObject messageval];
    if ([messageval containsString:@"nonexistence"] || [messageval containsString:@"nopermission"] || [messageval containsString:@"nomedal"]) {
        refuseBlock?refuseBlock([responseObject messagestr]):nil;
        return NO;
    }
    return YES;
}

@end
