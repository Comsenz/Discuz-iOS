//
//  Environment.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject
//登录用户的 一些数据
@property (nonatomic, copy) NSString *member_uid;      // uid
@property (nonatomic, copy) NSString *member_username; // 用户名
@property (nonatomic, copy) NSString *formhash; // 用于提交表单时进行安全验证的值，使用方法
@property (nonatomic, copy) NSString *member_avatar;   // 头像
@property (nonatomic, copy) NSString *member_loginstatus; // 登录方式

@property (nonatomic, copy) NSString *authKey;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *saltkey;


+ (Environment *)sharedEnvironment;

@end
