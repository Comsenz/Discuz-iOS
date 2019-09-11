//
//  CheckHelper.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/12.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckHelper : NSObject

@property (nonatomic, strong) NSDictionary *regKeyDic;
@property (nonatomic, strong) NSString *regUrl;

+ (instancetype)shareInstance;

- (void)checkRequest;

- (void)checkRegisterRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure;

- (void)checkRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure;

@end

NS_ASSUME_NONNULL_END
