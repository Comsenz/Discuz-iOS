//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error;
+ (void)showSuccess:(NSString *)success;
+ (void)showWarn:(NSString *)warn;
+ (void)showInfo:(NSString *)info;

+ (void)showServerError:(NSError *)error;

- (void)showLoadingMessag:(NSString *)message toView:(UIView *)view;

- (void)showLoadingMessag:(NSString *)message toView:(UIView *)view blackColor:(UIColor *)blackColor;

- (void)hide;

@end
