//
//  UIAlertController+Extension.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/28.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

+ (void)alertTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller doneText:(NSString *)doneText cancelText:(NSString *)cancelText doneHandle:(void(^)(void))doneHandle cancelHandle:(void(^)(void))cancelHandle;

+ (void)alertTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller doneTextArr:(NSArray *)doneTextArr cancelText:(NSString *)cancelText doneHandle:(void(^)(NSInteger index))doneHandle cancelHandle:(void(^)(void))cancelHandle;

+ (void)alertSheetTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller doneTextArr:(NSArray *)doneTextArr cancelText:(NSString *)cancelText doneHandle:(void(^)(NSInteger index))doneHandle cancelHandle:(void(^)(void))cancelHandle;

@end
