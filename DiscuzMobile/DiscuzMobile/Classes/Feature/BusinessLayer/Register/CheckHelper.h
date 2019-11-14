//
//  CheckHelper.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/12.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckHelper : NSObject

@property (nonatomic, strong) NSString *regUrl;
@property (nonatomic, strong) NSDictionary *regKeyDic;

+ (instancetype)shareInstance;

- (void)checkAPIRequest;

- (void)checkRegisterRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure;

- (void)checkRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure;

@end

