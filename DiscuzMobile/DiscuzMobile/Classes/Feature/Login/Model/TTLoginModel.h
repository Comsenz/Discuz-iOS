//
//  TTLoginModel.h
//  DiscuzMobile
//
//  Created by HB on 16/9/22.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLoginModel : NSObject

@property (nonatomic,strong) NSString *logintype;
@property (nonatomic,strong) NSString *openid;
@property (nonatomic,strong) NSString *unionid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *gbkname;

- (instancetype)initWithLogintype:(NSString *)logintype andOpenid:(NSString *)openid andGbkname:(NSString *)gbkname andUsername:(NSString *)username;
+ (instancetype)initWithLogintype:(NSString *)logintype andOpenid:(NSString *)openid andGbkname:(NSString *)gbkname andUsername:(NSString *)username;
@end
