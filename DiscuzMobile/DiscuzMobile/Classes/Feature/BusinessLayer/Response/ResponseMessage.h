//
//  ResponseMessage.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/19.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseMessage : NSObject

+ (BOOL)autherityJudgeResponseObject:(NSDictionary *)responseObject refuseBlock:(void(^)(NSString *message))refuseBlock;

@end
