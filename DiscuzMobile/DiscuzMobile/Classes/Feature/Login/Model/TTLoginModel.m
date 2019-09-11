//
//  TTLoginModel.m
//  DiscuzMobile
//
//  Created by HB on 16/9/22.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTLoginModel.h"

@implementation TTLoginModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (instancetype)initWithLogintype:(NSString *)logintype andOpenid:(NSString *)openid andGbkname:(NSString *)gbkname andUsername:(NSString *)username {
    if (self = [super init]) {
        self.logintype = logintype;
        self.openid = openid;
        self.gbkname = gbkname;
        self.username = username;
    }
    return self;
}
+ (instancetype)initWithLogintype:(NSString *)logintype andOpenid:(NSString *)openid andGbkname:(NSString *)gbkname andUsername:(NSString *)username {
    return [[TTLoginModel alloc] initWithLogintype:logintype andOpenid:openid andGbkname:gbkname andUsername:username];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"登录方式:%@，openid:%@，用户名：%@",_logintype,_openid,_username];
}

@end
