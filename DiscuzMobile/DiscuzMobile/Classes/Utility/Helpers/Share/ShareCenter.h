//
//  ShareCenter.h
//  DiscuzMobile
//
//  Created by HB on 16/11/28.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLoginModel.h"

@interface ShareCenter : NSObject

@property (nonatomic, strong) TTLoginModel * _Nullable bloginModel;

// 单例
+ (nonnull instancetype)shareInstance;

/*
 *  设置shareSDK参数
 */
- (void)setupShareConfigure;
- (void)createShare:(nonnull NSString *)text andImages:(nullable id)images andUrlstr:(nonnull NSString *)urlStr andTitle:(nonnull NSString *)title andView:(nullable UIView *)view andHUD:(nullable MBProgressHUD *)HUD;

#pragma mark - qq登录
- (void)loginWithQQSuccess:(void(^_Nullable)(id _Nullable postData,id _Nullable getData))success finish:(void(^_Nullable)(void))finish;

#pragma mark - 微信登录
- (void)loginWithWeiXinSuccess:(void(^_Nullable)(id _Nullable postData,id _Nullable getData))success finish:(void(^_Nullable)(void))finish;

@end
