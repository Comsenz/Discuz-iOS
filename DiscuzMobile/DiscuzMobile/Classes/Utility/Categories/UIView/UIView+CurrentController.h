//
//  UIView+CurrentController.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/11/23.
//  Copyright © 2018年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CurrentController)

//获取当前屏幕显示的viewcontroller
+(UIViewController*)getCurrentUIVC;

+(UINavigationController*)getCurrentNaVC;

+(UIViewController*)getCurrentWindowVC;

+(UIViewController *)getSubUIVCWithVC:(UIViewController*)vc;


@end

NS_ASSUME_NONNULL_END
